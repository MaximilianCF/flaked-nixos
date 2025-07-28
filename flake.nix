{
  description = "Sistema declarativo NixOS com Home Manager integrado + ROS2";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
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
        nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixos.nix
            #inputs.ros2-flake.nixosModules.ros2SystemPkgs
            home-manager.nixosModules.home-manager
            {
              nixpkgs.config = {
                allowUnfree = true;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.max = import ./home/max.nix;
            }
          ];
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

  nixConfig = {
    extra-substituters = [ "https://ros.cachix.org" ];
    extra-trusted-public-keys = [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
  };
}
