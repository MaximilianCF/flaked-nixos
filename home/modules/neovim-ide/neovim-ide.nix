# modules/neovim-ide.nix
{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = false;

    plugins = with pkgs.vimPlugins; [
      # Essentials
      lazy-nvim
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-path
      cmp-buffer
      luasnip
      cmp_luasnip
      # UI
      lualine-nvim
      nvim-web-devicons
      nvim-tree-lua
      telescope-nvim
      # Syntax & Treesitter
      nvim-treesitter.withAllGrammars
      nvim-ts-autotag
      # Git
      gitsigns-nvim
      # Debugging
      nvim-dap
      nvim-dap-ui
    ];
  };

  home.packages = with pkgs; [
    nodejs
    python3
    ripgrep
    fd
    unzip
    git
    cargo
  ];
}
