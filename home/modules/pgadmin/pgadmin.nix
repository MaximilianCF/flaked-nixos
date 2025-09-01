{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.my.pgadmin4.enable = lib.mkEnableOption "pgAdmin4 desktop mode";

  config = lib.mkIf config.my.pgadmin4.enable {
    # Garante pasta de dados
    home.file.".local/share/pgadmin/.keep".text = "";

    # Config local para rodar no modo desktop
    xdg.configFile."pgadmin/config_local.py".text = ''
      import os
      home = os.path.expanduser("~")
      data_dir = os.path.join(home, ".local", "share", "pgadmin")

      SERVER_MODE = False
      DATA_DIR = data_dir
      SQLITE_PATH = os.path.join(data_dir, "pgadmin4.db")
      LOG_FILE = os.path.join(data_dir, "pgadmin4.log")
      SESSION_DB_PATH = os.path.join(data_dir, "sessions")
      STORAGE_DIR = os.path.join(data_dir, "storage")

      MASTER_PASSWORD_REQUIRED = False
      ALLOW_SAVE_PASSWORD = True
    '';

    # Wrapper para garantir uso do config_local.py
    home.file.".local/bin/pgadmin4" = {
      text = ''
        #!${pkgs.bash}/bin/bash
        export PGADMIN_CONFIG_FILE="$HOME/.config/pgadmin/config_local.py"
        exec ${pkgs.pgadmin4}/bin/pgadmin4 "$@"
      '';
      executable = true;
    };

    # Atalho no menu
    xdg.desktopEntries.pgadmin4 = {
      name = "pgAdmin 4";
      comment = "PostgreSQL Administration";
      exec = ''${config.home.homeDirectory}/.local/bin/pgadmin4'';
      terminal = false;
      categories = [
        "Development"
        "Database"
        "Network"
      ];
    };
  };
}
