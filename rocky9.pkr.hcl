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

source "proxmox-iso" "tpl-rocky-9" {
  insecure_skip_tls_verify = true
  proxmox_url              = var.proxmox_url
  username                 = var.proxmox_token_id
  token                    = var.proxmox_token_secret

  node = "ns33672748"

  vm_name              = "tpl-rocky-9"
  template_description = "RockyLinux 9 Cloud Init template"
  os                   = "l26"
  sockets              = 1
  cores                = 2
  cpu_type             = "Nehalem"
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


  http_directory   = "autoinstall/rocky9"
  iso_file         = "local:iso/Rocky-9.5-x86_64-dvd.iso"
  iso_storage_pool = "local"
  iso_checksum     = "sha256:ba60c3653640b5747610ddfb4d09520529bef2d1d83c1feb86b0c84dff31e04e"

  boot_wait    = "10s"
  boot_command = ["<tab><bs><bs><bs><bs><bs>inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"]

  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout  = "60m"
}


build {
  sources = ["proxmox-iso.tpl-rocky-9"]
  provisioner "shell" {
    script       = "provisionners/postinstall-rocky.sh"
    pause_before = "10s"
    timeout      = "10s"
  }
}

