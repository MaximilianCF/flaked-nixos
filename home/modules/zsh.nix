{ config, pkgs, ... }:

{
  # Enable Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      strategy = [ "history" ];
    };
    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" ];
    };
    oh-my-zsh = {
      enable = true;
      package = pkgs.oh-my-zsh;
      theme = "robbyrussell";
      plugins = with pkgs; [
        "git"
      ];
    };
  };
}
