{ config, pkgs, ... }:

{

  programs.floorp = {
    enable = true;
    package = pkgs.floorp;
    languagePacks = [ "pt-BR" ];

  };

}
