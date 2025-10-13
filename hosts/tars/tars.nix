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
    ../../modules/postgres.nix
    ../../modules/distributed-builds.nix
  ];

  nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://numtide.cachix.org"
      ];

      # Caches in trusted-substituters can be used by unprivileged users i.e. in
      # flakes but are not enabled by default.
      trusted-substituters = config.nix.settings.substituters;

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      ];
    };
  };

  boot.loader = {
    grub = {
      enable = true;
      useOSProber = true;
      device = "nodev";
      efiSupport = true;
    };
    systemd-boot = {
      enable = false;
      configurationLimit = lib.mkDefault 2;
      consoleMode = lib.mkDefault "max";
    };
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
    desktopManager.gnome.enable = true;
    displayManager = {
      gdm.enable = true;
      autoLogin = {
        enable = true;
        user = "max";
      };
    };
    xserver = {
      enable = true;
      xkb.layout = "br";

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
    pki.certificateFiles = [ ../../harmonia.crt ];
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
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  environment.systemPackages =
    (with inputs.browser-previews.packages.${pkgs.system}; [
      google-chrome-dev
    ])
    ++ (with inputs.nix-ai-tools.packages.${pkgs.system}; [
      claude-code
      opencode
      gemini-cli
      qwen-code
      codex
    ])
    ++ (with pkgs; [
      direnv
      (pkgs.rWrapper.override {
        packages = with pkgs.rPackages; [
          ggplot2
          tidyverse
          dplyr
          devtools
          Rcpp
        ];
      })
      pkgs.rstudioWrapper
      megasync
      cachix
    ]);

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
      #substituters = [ "https://192.168.150.10" ];
      #trusted-public-keys = [ "cache.192.168.150.10.tld-1:Tw0JRN9jnhck/ieDcxc3wQEUGIfBwrAN/HrHmhpBB1w=" ];
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

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  system.stateVersion = "25.11";
}
