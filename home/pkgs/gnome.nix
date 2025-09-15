{ pkgs }:

with pkgs;
[
  gnome-extension-manager
  gnome-tweaks
  gnome-applets
  gnome-nettool
  gnome-keyring

  # Extensões
  gnomeExtensions.open-bar
  gnomeExtensions.vitals
  gnomeExtensions.extension-list
  gnomeExtensions.dash-to-dock
  gnomeExtensions.arcmenu
  gnomeExtensions.screenshort-cut
]
