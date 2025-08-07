{ config, pkgs, ... }:

let
  devPkgs = import ./pkgs/dev.nix { inherit pkgs; };
  gnomePkgs = import ./pkgs/gnome.nix { inherit pkgs; };
  mediaPkgs = import ./pkgs/media.nix { inherit pkgs; };
  netPkgs = import ./pkgs/net.nix { inherit pkgs; };
  sysPkgs = import ./pkgs/system.nix { inherit pkgs; };
  robotPkgs = import ./pkgs/robotica.nix { inherit pkgs; };
in
{
  home.packages = devPkgs ++ gnomePkgs ++ mediaPkgs ++ netPkgs ++ sysPkgs ++ robotPkgs;

  imports = [
    ./modules/scripts/hal-scripts-completo.nix
    ./modules/git.nix
    ./modules/tmux/default.nix
    ./modules/neovim-ide.nix
    ./modules/zsh.nix
    ./modules/java.nix
    ./modules/eza.nix
    ./modules/floorp.nix
  ];

  programs.gh.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.home-manager = {
    enable = true;
  };

  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "daily";
  };

  home.stateVersion = "25.05";
}
