{ lib, pkgs, ... }:

{

  imports = [
    ./emacs.nix
    ./neovim-ide.nix
    #./zed.nix
  ];

}
