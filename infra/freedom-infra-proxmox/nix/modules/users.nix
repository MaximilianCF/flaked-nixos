{ lib, config, ... }:

let
  sshDir = ../admins/ssh-keys;
  allFiles = builtins.readDir sshDir;
  pubKeys = lib.filterAttrs (name: _: lib.hasSuffix ".pub" name) allFiles;
  keyMap = lib.mapAttrs' (n: _: {
    name = lib.removeSuffix ".pub" n;
    value = builtins.readFile (sshDir + "/${n}");
  }) pubKeys;
  allowedUsers = {
    "proxmox-infra-server" = [ ]; # só freedom + remotebuild
    "proxmox-nginx" = [ ]; # só freedom
  };
  myUsers = lib.attrByPath [ config.networking.hostName ] [ ] allowedUsers;
  sshUsers = lib.genAttrs (lib.filter (u: keyMap ? u) myUsers) (uname: {
    isNormalUser = true;
    createHome = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    openssh.authorizedKeys.keys = [ keyMap.${uname} ];
  });
  freedomUser = lib.mkIf (keyMap ? freedom) {
    freedom = {
      isNormalUser = true;
      createHome = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      openssh.authorizedKeys.keys = [ keyMap.freedom ];
    };
  };
in
{
  users.users = lib.mkMerge [
    freedomUser
    sshUsers
    (lib.mkIf (config.networking.hostName == "proxmox-infra-server") {
      remotebuild = {
        isNormalUser = true;
        createHome = false;
        extraGroups = [ "remotebuild" ];
      };
    })
  ];
}
