{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git-review
    git-secret
    gh
    gitRepo
  ];

  programs.git = {
    enable = true;
    userName = "Max";
    userEmail = "maximiliancf.dev@icloud.com";
  };

}
