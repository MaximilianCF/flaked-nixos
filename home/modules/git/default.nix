{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git-review
    git-secret
    gh
    gitRepo
    git-credential-manager
  ];

  programs.git = {
    enable = true;
    userName = "Max";
    userEmail = "maximiliancf.dev@icloud.com";
    package = pkgs.gitFull;
  };

}
