{ pkgs }:

with pkgs;
[
  gnome-extension-manager
  gnome-tweaks
  gnome-applets
  gnome-nettool

  # Extensões
  gnomeExtensions.open-bar
  gnomeExtensions.vitals
  gnomeExtensions.extension-list
  gnomeExtensions.dash-to-dock
  gnomeExtensions.arcmenu
  gnomeExtensions.weekly-commits
  gnomeExtensions.screenshort-cut
]
