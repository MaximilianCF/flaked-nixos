{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../modules/postgres.nix
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

  time.timeZone = "America/Sao_Paulo";

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "libsoup-2.74.3"
    ];
  };

  fonts = {
    enableDefaultPackages = true;

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [
          "Open Sans"
          "Ubuntu"
        ];
        serif = [ "Ubuntu" ];
      };
    };

    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.ubuntu
      open-sans
      nerd-fonts.space-mono
      nerd-fonts.fira-code
      google-fonts
    ];
  };

  i18n = {
    defaultLocale = "pt_BR.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };
  };

  console.keyMap = "br-abnt2";

  services = {
    xserver = {
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

    printing.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    pulseaudio.enable = false;

    openssh.enable = true;
  };

  security = {
    rtkit.enable = true;
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  nixpkgs.config.allowUnsupportedSystem = true;

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  xdg.portal = {
    enable = true;
    # Para GNOME:
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  environment.systemPackages = with inputs.browser-previews.packages.${pkgs.system}; [
    pkgs.qgnomeplatform-qt6
    (pkgs.rWrapper.override {
      packages = with pkgs.rPackages; [
        ggplot2
        tidyverse
        dplyr
        devtools
        Rcpp
      ];
    })
    google-chrome-dev
    pkgs.rstudioWrapper
    pkgs.megasync
  ];

  users.users.max = {
    packages = with pkgs; [
      flatpak
      gnome-software
    ];
    isNormalUser = true;
    description = "Maximilian";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "docker"
      "video"
    ];
    shell = pkgs.zsh;
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  home-manager.backupFileExtension = "backup";

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
    };
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  my.postgres = {
    enable = true;
    version = "15";
    database = "mydatabase";
    user = "max";
    authMethod = "trust";
    listenLocalhost = true;
    openFirewall = false;
  };

  virtualisation.docker = {
    enable = true;
  };

  nixpkgs.config.allowBroken = true;

  programs.ssh.extraConfig = ''
    Host eu.nixbuild.net
    PubkeyAcceptedKeyTypes ssh-ed25519
    ServerAliveInterval 60
    IPQoS throughput
    IdentityFile /home/max/.ssh/my-nixbuild-key
  '';

  programs.ssh.knownHosts = {
    nixbuild = {
      hostNames = [ "eu.nixbuild.net" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAekjki0mgMAzN8/qMixizRHBwDVc+nY7OjibU9vcz8F my-key-comment";
    };
  };

  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "eu.nixbuild.net";
        system = "x86_64-linux";
        maxJobs = 100;
        supportedFeatures = [
          "benchmark"
          "big-parallel"
        ];
      }
    ];
  };

  services.gnome.gnome-keyring.enable = lib.mkForce false;

  system.stateVersion = "25.05";
}
