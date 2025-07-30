{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader = {
    grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
      efiSupport = false;
    };
    systemd-boot.enable = false;
  };

  home.username = "maximiliancfdev";
  home.homeDirectory = "/home/maximiliancfdev";

  networking.hostName = "LedZeppelin";
  time.timeZone = "America/Sao_Paulo";

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "libsoup-2.74.3" ];
  };

  i18n.defaultLocale = "pt_BR.UTF-8";
  console.keyMap = "br-abnt2";

  services = {
    xserver.enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    printing.enable = true;
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  users.users.max = {
    isNormalUser = true;
    packages = with pkgs; [
      flatpak
      gnome-software
    ];
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
    ];
    shell = pkgs.bash;
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  system.stateVersion = "25.05";
}
