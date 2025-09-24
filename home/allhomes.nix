{ pkgs, config, ... }:

let
  devPkgs = import ./pkgs/dev.nix { inherit pkgs; };
  gnomePkgs = import ./pkgs/gnome.nix { inherit pkgs; };
  mediaPkgs = import ./pkgs/media.nix { inherit pkgs; };
  netPkgs = import ./pkgs/net.nix { inherit pkgs; };
  sysPkgs = import ./pkgs/system.nix { inherit pkgs; };
  mathPkgs = import ./pkgs/math.nix { inherit pkgs; };
  miscPkgs = import ./pkgs/misc.nix { inherit pkgs; };
in
{
  home.packages = devPkgs ++ gnomePkgs ++ mediaPkgs ++ netPkgs ++ sysPkgs ++ mathPkgs ++ miscPkgs;

  imports = [
    ./modules/scripts/hal-scripts-completo.nix
    ./modules/tmux/default.nix
    ./modules/editores/default.nix
    ./modules/system/default.nix
    ./modules/shell_terminal/default.nix
    #./modules/browsers/default.nix
    ./modules/misc/default.nix
  ];

  programs.gh.enable = true;

  programs.home-manager = {
    enable = true;
  };

  services.psd.browsers = [
    "google-chrome"
  ];

  home.username = "max";
  home.homeDirectory = "/home/max";

  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "daily";
  };

  nix.settings = {
    substituters = [ "https://192.168.150.10" ];
    trusted-public-keys = [ "cache.192.168.150.10.tld-1:Tw0JRN9jnhck/ieDcxc3wQEUGIfBwrAN/HrHmhpBB1w=" ];
  };

  home.stateVersion = "25.11";
}
