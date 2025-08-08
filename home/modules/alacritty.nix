{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    tmux
  ];

  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;
  };

  programs.alacritty.settings = {
    shell = {
      program = "${pkgs.tmux}/bin/tmux";
      args = [
        "new-session"
      ];
    };
  };

}
