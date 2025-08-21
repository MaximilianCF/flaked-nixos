{ pkgs, ... }:

{

  programs.sagemath = {
    enable = true;
    package = pkgs.sage;
    initScript = "%colors linux";
  };

}
