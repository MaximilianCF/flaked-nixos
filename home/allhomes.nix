{ pkgs, ... }:

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
    ./modules/tmux/default.nix
    ./modules/editores/default.nix
    ./modules/system/default.nix
    ./modules/shell_terminal/default.nix
    ./modules/browsers/default.nix
  ];

  programs.gh.enable = true;

  programs.home-manager = {
    enable = true;
  };

  services.psd.browsers = [
    "chromium"
    "floorp"
    "google-chrome"
  ];

  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "daily";
  };

  home.stateVersion = "25.05";
}
