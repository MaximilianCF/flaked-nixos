{ pkgs, ... }:

{
  users.users.max = {
    isNormalUser = true;
    description = "Maximilian";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      flatpak
      gnome-software
    ];
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };
}
