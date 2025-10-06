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
    inputs.harmonia.nixosModules.harmonia
    (modulesPath + "/profiles/qemu-guest.nix")
    ./harmonia.nix
    ./remote-builder.nix
    ../../modules/network.nix
    ../../modules/partitioning.nix
    ../../modules/users.nix
  ];

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

  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.KbdInteractiveAuthentication = false;

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
      ];
    };
    hostName = "proxmox-infra-server";
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
