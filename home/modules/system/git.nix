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
    extraConfig = {
      init.defaultBranch = "main";
      include.path = "~/.gitconfig.local";
    };
    delta = {
      enable = true;
      package = pkgs.delta;
      options = {
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-decoration-style = "none";
          file-style = "bold yellow ul";
        };
        features = "decorations";
        whitespace-error-style = "22 reverse";
      };
    };
  };
  # >>> NOVO: garante que o arquivo local exista (onde o SmartGit vai escrever)
  home.file.".gitconfig.local".text = ''
    # Configs locais graváveis (SmartGit/CLI).
    # Exemplo:
    # [alias]
    #   co = checkout
  '';

  # >>> NOVO: força o Git global a ser ~/.gitconfig, não XDG ~/.config/git/config
  home.sessionVariables.GIT_CONFIG_GLOBAL = "$HOME/.gitconfig";

  # >>> NOVO: wrapper que abre o SmartGit usando o .gitconfig.local
  home.packages = [
    (pkgs.writeShellScriptBin "smartgit-local" ''
      #!/usr/bin/env bash
      export GIT_CONFIG_GLOBAL="$HOME/.gitconfig.local"
      exec ${pkgs.smartgit}/bin/smartgit "$@"
    '')
  ];

  # (Opcional) ícone/entrada no menu para o wrapper
  xdg.desktopEntries.smartgit-local = {
    name = "SmartGit (Local)";
    exec = "smartgit-local";
    icon = "smartgit";
    terminal = false;
    categories = [ "Development" ];
  };
}
