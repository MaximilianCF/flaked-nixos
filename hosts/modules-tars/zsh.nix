{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh-autosuggestion
    zsh-syntax-highlighting
    zsh-powerlevel10k
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    plugins = [
      {
        name = "zsh-autosuggestion";
        src = pkgs.zsh-autosuggestion;
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
      }
    ];

    initExtra = ''
      autoload -U promptinit; promptinit
      prompt powerlevel10k
    '';
  };
}
