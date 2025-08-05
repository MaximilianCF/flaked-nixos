{ pkgs, ... }:

{
  services.flatpak.enable = true;

  systemd.services.flatpak-repo = {
    description = "Add Flathub repository if not present";
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo";
    };
  };
}
