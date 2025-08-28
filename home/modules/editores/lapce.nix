{ pkgs, ... }:

{

  programs.lapce = {
    enable = true;
    package = pkgs.lapce;
    channel = "stable";
  };

}
