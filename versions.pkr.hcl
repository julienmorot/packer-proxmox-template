packer {
  required_version = ">= 1.11.0"
  required_plugins {
    vmware = {
      version = ">= v1.1.8"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

