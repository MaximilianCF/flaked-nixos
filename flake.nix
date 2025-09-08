{
  description = "Sistema declarativo NixOS com Home Manager integrado (flake-parts)";

  nixConfig = {
    extra-substituters = [
      "https://cachix.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="

    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    browser-previews = {
      url = "github:nix-community/browser-previews";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensures browser-previews uses the same nixpkgs as your main flake
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    treefmt-nix.url = "github:numtide/treefmt-nix";

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
      home-manager,
      flake-parts,
      nix-github-actions,
      git-hooks-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      imports = [
        inputs.git-hooks-nix.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      systems = nixpkgs.lib.systems.flakeExposed;

      flake.homeConfigurations = {
        max = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          modules = [
            ./home/allhomes.nix
          ];
        };
      };

      flake.nixosConfigurations = {
        tars = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
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
              home-manager.users.max = {
                imports = [
                  ./home/allhomes.nix
                ];
              };
            }
          ];
        };
      };

      flake.githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
        inherit (self) checks;
      };

      perSystem =
        {
          system,
          pkgs,
          config,
          lib,
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

          formatter = config.treefmt.build.wrapper;

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
              config.treefmt.build.devShell
              config.pre-commit.devShell
            ]
            ++ config.pre-commit.settings.enabledPackages;
          };

          checks.hm-activation = pkgs.stdenv.mkDerivation {
            name = "check-home-activation";
            dontUnpack = true;
            dontBuild = true;
            installPhase = ''mkdir -p $out'';
          };
        };
    };
}
