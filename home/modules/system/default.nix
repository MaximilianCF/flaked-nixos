{ lib, pkgs, ... }:

{

  imports = [
    ./bat.nix
    ./btop.nix
    ./direnv.nix
    ./eza.nix
    ./git.nix
    ./java.nix
    #./rofi.nix
    #./mise.nix
    ./nh.nix
    ./virtualization.nix
  ];

}
