{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Max";
    userEmail = "maximiliancf.dev@icloud.com";
    package = pkgs.git;
    lfs = {
      enable = true;
    };
  };

}
