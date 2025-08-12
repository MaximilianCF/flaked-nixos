{ pkgs, ... }:

{

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    plugins = [
      pkgs.rofi-calc

    ];
  };

}
