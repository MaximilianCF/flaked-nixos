{ config, lib, pkgs, ... }:

let
  scripts = [
    "nixos-upgrade.sh"
    "devshell-list.sh"
    "flake-diff.sh"
    "nix-gc-safe.sh"
  ];
in {
  options.max.scripts.hal.enable = lib.mkEnableOption "Habilita o pacote HAL de scripts Nix/NixOS";

  config = lib.mkIf config.max.scripts.hal.enable {
    home.packages = with pkgs; [ fzf jq ];

    xdg.configFile = builtins.listToAttrs (map (name: {
      name = "bin/${lib.removeSuffix ".sh" name}";
      value.source = ../../scripts/${name};
    }) scripts);

    home.sessionPath = [ "$HOME/.config/bin" ];
  };
}

