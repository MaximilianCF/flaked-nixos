{
  description = "DevShell para simulações e pacotes ROS2";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      nix-ros-overlay,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ nix-ros-overlay.overlays.default ];
        pkgs = import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "ros2-dev-shell";
          buildInputs = with pkgs; [
            git
            colcon
            rosPackages.ros2Control
            rosPackages.ros2cli
            rosPackages.ros2Launch
            gazebo
            rviz
          ];
          shellHook = ''
            echo "🤖 Ambiente ROS2 ativo! Rode: colcon build && source install/setup.bash"
          '';
        };
      }
    );
}
