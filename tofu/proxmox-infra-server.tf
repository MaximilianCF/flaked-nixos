resource "proxmox_virtual_environment_vm" "proxmox-infra-server" {
  name            = "proxmox-infra-server"
  description     = "VM servidor cache binário e builder NixOS"
  node_name       = "n5"
  stop_on_destroy = true

  clone {
    vm_id = 9000
  }
  agent {
    enabled = false
  }
  memory {
    dedicated = 16384
  }
  cpu {
    cores = 2
  }
  disk {
    size         = 100
    datastore_id = "local"
    interface    = "scsi0"
  }
  network_device {
    model    = "virtio"
    bridge   = "vmbr1"
    enabled  = true
    firewall = false
  }
  initialization {
    datastore_id = "local"
    ip_config {
      ipv4 {
        address = "192.168.150.10/24"
        gateway = "192.168.150.1"
      }
    }

    user_account {
      username = "max"
      keys     = local.ssh_public_keys
    }
  }
}

module "nix-anywhere" {
  source                 = "github.com/nix-community/nixos-anywhere//terraform/all-in-one"
  nixos_system_attr      = ".#nixosConfigurations.proxmox-infra-server.config.system.build.toplevel"
  nixos_partitioner_attr = ".#nixosConfigurations.proxmox-infra-server.config.system.build.diskoScriptNoDeps"
  target_host            = "192.168.150.10"
  target_user            = "max"
  install_ssh_key        = data.sops_file.secrets.data["ssh_private_keys.install"]
  deployment_ssh_key     = data.sops_file.secrets.data["ssh_private_keys.deploy"]
  debug_logging          = true
  phases                 = ["kexec", "disko", "install", "reboot"]
  extra_environment = {
    "NIX_SSHOPTS" = "-o ServerAliveInterval=60 -o ServerAliveCountMax=3"
  }
}
