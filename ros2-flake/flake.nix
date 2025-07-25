# ros2-flake/flake.nix
{
  description = "ROS2 full environment for specific projects";

  inputs = {
    nixpkgs.follows = "nix-ros-overlay/nixpkgs";
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/master";
  };

  outputs = inputs@{ self, nixpkgs, nix-ros-overlay, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.permittedInsecurePackages = [
          "freeimage-3.18.0-unstable-2024-04-18"
        ];
        overlays = [
          nix-ros-overlay.overlays.default
        ];
      };
    in {
      devShells.${system}.default = pkgs.mkShell {
        name = "ROS2 Project Dev Shell";
        packages = [
          pkgs.colcon
          (with pkgs.rosPackages.jazzy; pkgs.buildEnv {
            paths = [
              ros-core
              rclpy
              ros-gz-sim
              geometry-msgs
              ament-cmake-core
              python-cmake-module
              turtlebot4-desktop
              turtlebot4-simulator
              # slam-toolbox
              nav2-minimal-tb4-sim
              nav2-minimal-tb3-sim
              rqt-common-plugins
              rqt-tf-tree
              tf2-tools
            ];
          })
        ];
      };
      modules.ros2SystemPkgs = import ./ros2-full.nix { inherit pkgs; };
    };
  nixConfig = {
   extra-substituters = [ "https://ros.cachix.org" ];
   extra-trusted-public-keys = [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
  };  
}