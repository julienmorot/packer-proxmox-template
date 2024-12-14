packer {
  required_version = ">= 1.11.2"
  required_plugins {
    proxmox = {
      version = ">= v1.2.2"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

