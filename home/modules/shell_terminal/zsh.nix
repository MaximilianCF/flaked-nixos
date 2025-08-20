{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;

    # Módulos nativos do HM (mais estáveis que via plugin duplicado)
    autosuggestions = {
      enable = true;
      strategy = [ "history" ];
    };

    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" ];
    };

    # Antidote como ÚNICO gerenciador de plugins
    antidote = {
      enable = true;
      package = pkgs.antidote;
      # Plugins/temas (pode adicionar/remover à vontade)
      plugins = [
        # Tema ultra rápido e popular
        "romkatv/powerlevel10k"

        # Compleções extras (além das do Zsh)
        "zsh-users/zsh-completions"

        # Busca por substring no histórico (atalhos logo abaixo)
        "zsh-users/zsh-history-substring-search"

        # (Opcional) fzf-tab dá menu melhor de completion com fzf
        # "Aloxaf/fzf-tab"
      ];
    };

    # Desliga frameworks concorrentes
    zplug.enable = false;

    oh-my-zsh = {
      enable = false;
      # Se um dia reativar oh-my-zsh, defina tema/plugins aqui
      # theme = "agnoster";
      # plugins = [ "git" "git-commit" ];
      package = pkgs.oh-my-zsh;
    };

    # Ajustes extras no shell
    initExtra = ''
      # Evita o wizard do p10k na 1ª execução; use 'p10k configure' quando quiser
      export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

      # Carrega o tema Powerlevel10k se presente (Antidote clona em ~/.zsh_plugins)
      if [ -r "$HOME/.zsh_plugins/powerlevel10k/powerlevel10k.zsh-theme" ]; then
        source "$HOME/.zsh_plugins/powerlevel10k/powerlevel10k.zsh-theme"
      fi

      # Keybindings pro history-substring-search (funciona em Emacs e Vi)
      bindkey '^[[A' history-beginning-search-backward   # Up
      bindkey '^[[B' history-beginning-search-forward    # Down
      bindkey -M vicmd 'k' history-beginning-search-backward
      bindkey -M vicmd 'j' history-beginning-search-forward

      # (Opcional) fzf-tab configuração básica
      # zstyle ':completion:*' menu no
      # zstyle ':fzf-tab:*' switch-group ',' '.'
    '';
  };

  # Qualquer Nerd Font pra ícones do p10k (escolha sua preferida)
  home.packages = [
    pkgs.nerdfonts
    pkgs.fzf
  ];
}
