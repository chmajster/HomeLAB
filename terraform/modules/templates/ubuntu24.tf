resource "proxmox_download_file" "ubuntu24_cloud_image" {
  content_type = "import"
  datastore_id = var.datastore_id_iso
  node_name    = var.node_name

  url       = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  file_name = "noble-server-cloudimg-amd64.qcow2"

  overwrite_unmanaged = true
  overwrite           = false
  verify              = false
}

resource "proxmox_virtual_environment_vm" "ubuntu24_template" {
  name      = "ubuntu24-template"
  node_name = var.node_name
  vm_id     = var.ubuntu24_template_id

  template    = true
  started     = false
  machine     = "q35"
  bios        = "ovmf"
  description = "Ubuntu 24.04 LTS template managed by Terraform"

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 2048
  }

  agent {
    enabled = true
  }

  efi_disk {
    datastore_id = var.datastore_id_vms
    type         = "4m"
  }

  disk {
    datastore_id = var.datastore_id_vms
    import_from  = proxmox_download_file.ubuntu24_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 40
  }

  initialization {
    datastore_id = var.datastore_id_vms

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_device {
    bridge = var.bridge
    model  = "virtio"
  }

  operating_system {
    type = "l26"
  }
}
