{ lib, pkgs, ... }:

{

  imports = [
    #./ghostty.nix
    #./wezterm.nix
    ./zsh.nix
  ];
}
