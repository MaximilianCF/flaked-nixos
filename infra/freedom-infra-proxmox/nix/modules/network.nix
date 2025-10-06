{ lib, config, ... }:

let
  ipMap = {
    "proxmox-infra-server" = "195.168.150.10";
    "proxmox-nginx" = "192.168.150.11";
  };
  myIP = lib.attrByPath [ config.networking.hostName ] null ipMap;
in
{
  networking = {
    useDHCP = false;
    interfaces.enp1s0 = lib.mkIf (myIP != null) {
      ipv4.addresses = [
        {
          address = myIP;
          prefixLength = 24;
        }
      ];
      defaultGateway = "192.168.150.1";
      nameservers = [
        "8.8.8.8"
        "8.8.4.4"
        "1.1.1.1"
      ];
    };
  };
}
