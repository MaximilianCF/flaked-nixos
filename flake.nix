{
  description = "Sistema declarativo NixOS com Home Manager integrado + ROS2";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #ros2-flake.url = "./ros2-flake";
  };

  outputs = { nixpkgs, home-manager, ... }: #ros2-flake, ... }:
      let  
      system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        overlays = [ 
        ];
      };
      in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        pkgs = pkgs;

        modules = [
          ./hosts/nixos.nix
          #ros2-flake.modules.ros2SystemPkgs
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.max = import ./home/max.nix;
          }
          
        ];
      };
    };      
  nixConfig = {
    extra-substituters = [ "https://ros.cachix.org" ];
    extra-trusted-public-keys = [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
  };  
}

