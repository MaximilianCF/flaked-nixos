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
    # ./modules/scripts/nixos-options.nix
    ./modules/scripts/hal-scripts-completo.nix
    ./modules/git/default.nix
    ./modules/tmux/default.nix
    ./modules/neovim-ide/neovim-ide.nix
  ];

  programs.bash = {
    enable = true;
  };
  programs.gh.enable = true;

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.neovim.enable = true;
  programs.tmux.enable = true;
  programs.bat.enable = true;
  programs.eza.enable = true;
  # programs.chromium.enable = true;

  programs.java = {
    enable = true;
    package = pkgs.jdk;
  };

  programs.git.enable = true;

  max.scripts.all.enable = true;

  programs.home-manager.enable = true;
  home.stateVersion = "25.05";
}
