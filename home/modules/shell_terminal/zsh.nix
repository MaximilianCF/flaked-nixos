{ pkgs, ... }:

{
  # Enable Zsh
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      strategy = [ "history" ];
    };
    antidote = {
      enable = true;
      package = pkgs.antidote;
    };
    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" ];
    };
    zplug = {
      enable = true;
    };
    oh-my-zsh = {
      enable = true;
      package = pkgs.oh-my-zsh;
      theme = "agnoster";
      plugins = with pkgs; [
        "git"
        "git-commit"
      ];
    };
  };
}
