{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration-hal9000.nix
    ./shared/common.nix
  ];

  boot.loader = {
    grub = {
      enable = true;
      useOSProber = true;
      device = "nodev";
      efiSupport = false;
    };
    systemd-boot.enable = false;
  };
  fileSystems."/" = {
    device = lib.mkForce "UUID=37d58026-bd15-4dca-b235-c11273de6745";
    fsType = "ext4";
  };
  swapDevices = [
    {
      device = lib.mkForce "/dev/disk/by-uuid/0c563728-b694-4c69-bfb6-188e31a7240a";
    }
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    hostName = "HAL-9000";
    networkmanager.enable = true;
  };

  services.xserver = {
    enable = true;
    xkb.layout = "br";
    desktopManager.gnome.enable = true;
    displayManager = {
      gdm.enable = true;
      autoLogin = {
        enable = true;
        user = "max";
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  environment.systemPackages = [
    pkgs.qgnomeplatform-qt6
    (pkgs.rWrapper.override {
      packages = with pkgs.rPackages; [
        ggplot2
        tidyverse
        dplyr
        devtools
      ];
    })
    pkgs.rstudioWrapper
  ];

  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.config.allowBroken = true;
}
