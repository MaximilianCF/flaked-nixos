{ config, pkgs, ... }:

let
  devPkgs = import ./pkgs/dev.nix { inherit pkgs; };
  gnomePkgs = import ./pkgs/gnome.nix { inherit pkgs; };
  mediaPkgs = import ./pkgs/media.nix { inherit pkgs; };
  netPkgs = import ./pkgs/net.nix { inherit pkgs; };
  sysPkgs = import ./pkgs/system.nix { inherit pkgs; };
in
{
  home.username = "max";
  home.homeDirectory = "/home/max";

  home.packages = devPkgs ++ gnomePkgs ++ mediaPkgs ++ netPkgs ++ sysPkgs;

  imports = [
    # ./modules/scripts/nixos-options.nix
    ./modules/scripts/hal-scripts-completo.nix
  ];

  programs.bash = {
    enable = true;
  };
  programs.gh.enable = true;
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.neovim.enable = true;
  programs.tmux = {
    shortcut = "a";
    enable = true;
    clock24 = true;

  };
  programs.bat.enable = true;
  programs.eza.enable = true;

  programs.java = {
    enable = true;
    package = pkgs.jdk;
  };

  programs.git = {
    package = pkgs.gitFull;
    enable = true;
    userName = "Max";
    userEmail = "max@example.com";
  };

  max.scripts.all.enable = true;

  programs.home-manager.enable = true;
  home.stateVersion = "25.05";
}
