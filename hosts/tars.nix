{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./shared/common.nix
  ];

  boot.loader = {
    grub = {
      enable = true;
      useOSProber = true;
      device = "nodev";
      efiSupport = true;
    };
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    hostName = "Endurance";
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

  nixpkgs.config.allowUnsupportedSystem = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
