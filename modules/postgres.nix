{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.postgres;
in
{
  options.my.postgres = {
    enable = lib.mkEnableOption "PostgreSQL server";

    version = lib.mkOption {
      type = lib.types.enum [
        "15"
        "16"
      ];
      default = "15";
    };

    database = lib.mkOption {
      type = lib.types.str;
      default = "mydatabase";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "max";
    };

    authMethod = lib.mkOption {
      type = lib.types.enum [
        "trust"
        "md5"
        "scram-sha-256"
      ];
      default = "trust";
    };

    listenLocalhost = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      package = if cfg.version == "16" then pkgs.postgresql_16 else pkgs.postgresql_15;
      dataDir = "/var/lib/postgresql/${cfg.version}";
      settings = lib.mkIf cfg.listenLocalhost {
        "listen_addresses" = lib.mkForce "localhost";
      };

      ensureDatabases = [
        cfg.database
        cfg.user
      ];
      ensureUsers = [
        {
          name = cfg.user;
          ensureDBOwnership = true;
        }
        {
          name = cfg.database;
          ensureDBOwnership = true;
        }
      ];

      authentication = lib.mkOverride 10 ''
        local   all       all                    ${cfg.authMethod}
        host    all       all   127.0.0.1/32     ${cfg.authMethod}
        host    all       all   ::1/128          ${cfg.authMethod}
      '';
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ 5432 ];
  };
}
