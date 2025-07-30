{
  description = "Sistema declarativo NixOS com Home Manager integrado";

  nixConfig = {
    extra-substituters = [ "https://ros.cachix.org" ];
    extra-trusted-public-keys = [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #ros2-flake.url = "./ros2-flake";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    flake-parts.url = "github:hercules-ci/flake-parts";

    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-github-actions = {
      url = "github:nix-community/nix-github-actions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      home-manager,
      nix-github-actions,
      ...
    }: # ros2-flake, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.git-hooks-nix.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      systems = nixpkgs.lib.systems.flakeExposed;

      flake = {
        githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
          inherit (self) checks;
        };
        nixosConfigurations = {
          tars = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./hosts/tars.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.max = import ./home/allhomes.nix;
              }
            ];
          };
          hal9000 = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./hosts/hal9000.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.max = import ./home/allhomes.nix;
              }
            ];
          };
        };
      };
      perSystem =
        {
          system,
          pkgs,
          config,
          ...
        }:
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          treefmt.config = {
            programs.nixfmt.enable = true;
            programs.prettier = {
              enable = true;
              settings = {
                tabWidth = 2;
                semi = true;
              };
            };
          };
          pre-commit.settings = {
            hooks = {
              convco = {
                enable = true;
                package = pkgs.convco;
              };
              nixfmt-rfc-style = {
                enable = true;
                package = pkgs.nixfmt-rfc-style;
              };
            };
          };
          devShells.default = pkgs.mkShell {
            inputsFrom = [
              config.pre-commit.devShell
              config.treefmt.build.devShell
            ]
            ++ config.pre-commit.settings.enabledPackages;
          };
        };
    };
}
