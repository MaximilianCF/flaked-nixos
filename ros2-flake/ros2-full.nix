# ros2-flake/ros2-full.nix
{ pkgs, ... }:

let
  ros = pkgs.rosPackages.jazzy;
in
{
  environment.systemPackages = [
    pkgs.colcon
  ] ++ (with ros; [  
    ros-core
    geometry-msgs
    ament-cmake-core
    python-cmake-module
    turtlebot4-desktop
    turtlebot4-simulator
    # slam-toolbox
    nav2-minimal-tb4-sim
    nav2-minimal-tb3-sim
    # rqt metapackages
    rqt-common-plugins
    rqt-tf-tree
    tf2-tools
  ]);
  environment.variables = {
      ROS_DISTRO = "jazzy";
      ROS_VERSION = "2";
  };
}