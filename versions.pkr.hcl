packer {
  required_version = ">= 1.11.0"
  required_plugins {
    proxmox = {
      version = ">= v1.1.8"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

