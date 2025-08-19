{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      shell = "${pkgs.tmux}/bin/tmux new -A -s main";
    };

    shellIntegration = {
      enableZshIntegration = true;
    };
  };
}
