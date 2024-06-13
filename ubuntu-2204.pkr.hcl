variable "ssh_username" {
  type = string
}

variable "ssh_password" {
  type      = string
  sensitive = true
}

variable "proxmox_url" {
  type    = string
  default = "https://localhost:8006/api2/json"
}

variable "proxmox_token_id" {
  type = string
}

variable "proxmox_token_secret" {
  type      = string
  sensitive = true
}

source "proxmox-iso" "tpl-ubuntu-2204" {
  insecure_skip_tls_verify = true
  proxmox_url              = var.proxmox_url
  username                 = var.proxmox_token_id
  token                    = var.proxmox_token_secret

  node = "ns33672748"

  vm_name              = "tpl-ubuntu-2204"
  template_description = "Ubuntu 22.04 Cloud Init template"
  os                   = "l26"
  sockets              = 1
  cores                = 2
  memory               = 2048

  bios                    = "seabios"
  qemu_agent              = true
  cloud_init              = true
  cloud_init_storage_pool = "local"
  unmount_iso             = true

  vga {
    type = "virtio"
  }

  scsi_controller = "virtio-scsi-pci"
  disks {
    disk_size    = "30G"
    format       = "raw"
    storage_pool = "local"
    type         = "virtio"
  }

  network_adapters {
    model    = "virtio"
    bridge   = "vmbr1"
    firewall = "false"
  }


  http_directory = "autoinstall/ubuntu2204"
  #iso_url          = "/var/lib/vz/template/iso/ubuntu-22.04.4-live-server-amd64.iso"
  iso_file         = "local:iso/ubuntu-22.04.4-live-server-amd64.iso"
  iso_storage_pool = "local"
  iso_checksum     = "sha256:45F873DE9F8CB637345D6E66A583762730BBEA30277EF7B32C9C3BD6700A32B2"

  boot_wait = "10s"
  boot_command = [
    "<spacebar><wait><spacebar><wait><spacebar><wait><spacebar><wait><spacebar><wait>",
    "e<wait>",
    "<down><down><down><end>",
    " autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
    "<f10>"
  ]

  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout  = "60m"
}


build {
  sources = ["proxmox-iso.tpl-ubuntu-2204"]
  provisioner "shell" {
    script       = "provisionners/postinstall-ubuntu.sh"
    pause_before = "10s"
    timeout      = "10s"
  }
}

