{ config, lib, pkgs, ... }:

let
  scriptName = "nixos-options-fzf";
in {
  options.max.scripts.nixosOptions.enable = lib.mkEnableOption "Enable NixOS/Home Manager options fuzzy finder";

  config = lib.mkIf config.max.scripts.nixosOptions.enable {
    home.packages = with pkgs; [
      fzf
      curl
      jq
      bat # opcional para preview colorido
    ];

    xdg.configFile."bin/${scriptName}".source = ../../scripts/${scriptName}.sh;

    home.sessionPath = [ "$HOME/.config/bin" ];

    home.file.".config/${scriptName}.meta".text = ''
      # Atalho disponível: ${scriptName}
      # Rode no terminal: ${scriptName}
    '';
  };
}
