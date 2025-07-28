{
  config,
  lib,
  pkgs,
  ...
}:

let
  scripts = [
    "nixos-options-fzf.sh"
    "nixos-upgrade.sh"
    "devshell-list.sh"
    "flake-diff.sh"
    "nix-gc-safe.sh"
    "nix-hub.sh"
  ];
in
{
  options.max.scripts.all.enable = lib.mkEnableOption "Habilita todos os scripts HAL declarativos";

  config = lib.mkIf config.max.scripts.all.enable {
    home.packages = with pkgs; [
      fzf
      jq
      curl
      bat
    ];

    xdg.configFile = builtins.listToAttrs (
      map (name: {
        name = "bin/${lib.removeSuffix ".sh" name}";
        value.source = ../../../scripts/${name};
      }) scripts
    );

    home.sessionPath = [ "$HOME/.config/bin" ];

    # Opcional: avisa após build
    home.activation.reportHalScripts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "🧠 Scripts HAL ativados: ${toString scripts}"
    '';
  };
}
