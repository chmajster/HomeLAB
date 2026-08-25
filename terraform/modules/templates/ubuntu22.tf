resource "proxmox_download_file" "ubuntu22_cloud_image" {
  content_type = "import"
  datastore_id = var.datastore_id_iso
  node_name    = var.node_name

  url       = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  file_name = "jammy-server-cloudimg-amd64.qcow2"

  overwrite_unmanaged = true
  overwrite           = false
  verify              = false
}

resource "proxmox_virtual_environment_vm" "ubuntu22_template" {
  name      = "ubuntu22-template"
  node_name = var.node_name
  vm_id     = var.ubuntu22_template_id

  template    = true
  started     = false
  machine     = "q35"
  bios        = "ovmf"
  description = "Ubuntu 22.04 LTS template managed by Terraform"

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
    import_from  = proxmox_download_file.ubuntu22_cloud_image.id
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
