{ config, pkgs, ... }:

let
  devPkgs = import ./pkgs/dev.nix { inherit pkgs; };
  gnomePkgs = import ./pkgs/gnome.nix { inherit pkgs; };
  mediaPkgs = import ./pkgs/media.nix { inherit pkgs; };
  netPkgs = import ./pkgs/net.nix { inherit pkgs; };
  sysPkgs = import ./pkgs/system.nix { inherit pkgs; };
  fontsPkgs = import ./pkgs/fonts.nix { inherit pkgs; };
in
{
  home.username = "max";
  home.homeDirectory = "/home/max";

  home.packages = devPkgs ++ gnomePkgs ++ mediaPkgs ++ netPkgs ++ sysPkgs ++ fontsPkgs; 

  programs.bash.enable = true;

  programs.git = {
    enable = true;
    userName = "Max";
    userEmail = "max@example.com";
  };

  programs.home-manager.enable = true;
  home.stateVersion = "25.05";
}

