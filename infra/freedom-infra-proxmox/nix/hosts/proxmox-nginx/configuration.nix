{
  flake,
  inputs,
  perSystem,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.disko.nixosModules.disko
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../modules/network.nix
    ../../modules/partitioning.nix
    ../../modules/users.nix
  ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."cache.infra.freedom.ind.br" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://192.168.150.11:8080";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "freedom@freedom.ind.br";
  };

  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.KbdInteractiveAuthentication = false;

  nixpkgs.hostPlatform = "x86_64-linux";

  system.stateVersion = "25.11";

  boot.loader.grub = {
    enable = true;
    efiSupport = false;
  };

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age = {
      sshKeyPaths = [ "/etc/ssh/maxn5" ];
      keyFile = "/var/lib/sops-nix/key.txt";
    };
  };

  boot.growPartition = true;

  boot.initrd.network.ssh.enable = true;

  services = {
    openssh = {
      enable = true;
    };
    qemuGuest = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    nano
  ];

  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        443
        8080
      ];
    };
    hostName = "proxmox-nginx";
  };

  programs.ssh.startAgent = true;

  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
      "freedom"
    ];
    experimental-features = [
      "nix-command"
      "flakes "
    ];
  };
}
