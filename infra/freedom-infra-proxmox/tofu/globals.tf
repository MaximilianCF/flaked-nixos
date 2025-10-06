locals {
  ssh_keys_dir  = "${path.root}/../admins/ssh-keys/"
  ssh_key_files = fileset(local.ssh_keys_dir, "*.pub")
  ssh_public_keys = [
    for filename in local.ssh_key_files :
    trimspace(file("${local.ssh_keys_dir}/${filename}"))
  ]
}

data "sops_file" "secrets" {
  source_file = "${path.root}/../secrets/secrets.yaml"
}

provider "proxmox" {
  endpoint  = data.sops_file.secrets.data["proxmox.endpoint"]
  username  = data.sops_file.secrets.data["proxmox.username"]
  password  = data.sops_file.secrets.data["proxmox.password"]
  api_token = data.sops_file.secrets.data["proxmox.api_token"]
  insecure  = true
}
