{ pkgs }:

with pkgs;
[
  gnome-extension-manager
  gnome-tweaks
  gnome-applets
  gnome-nettool

  # Extensões
  gnomeExtensions.open-bar
  gnomeExtensions.window-on-top
  gnomeExtensions.vitals
  gnomeExtensions.toggle-alacritty
  gnomeExtensions.extension-list
  gnomeExtensions.dash-to-dock
  gnomeExtensions.arcmenu
]
