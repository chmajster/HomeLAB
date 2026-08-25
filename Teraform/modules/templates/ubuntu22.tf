# ============================================================
# Ubuntu 22.04 LTS Cloud Image
# ============================================================

resource "proxmox_download_file" "ubuntu22_cloud_image_download" {
  content_type = "import"
  datastore_id = var.datastore_id_iso
  node_name    = var.virtual_environment_node_name

  url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"

  file_name = "jammy-server-cloudimg-amd64.qcow2"

  # Overwirte if file exist and is not manage by Teraform
  overwrite_unmanaged = true

  # Nie pobieraj ponownie obrazu, jeśli plik już istnieje.
  overwrite = false
  
  # Check SSL certificate, set to false if using self-signed certificate
  verify = false

}

resource "proxmox_virtual_environment_file" "cloud_init_ubuntu22" {
  content_type = "snippets"
  datastore_id = var.datastore_id_iso
  node_name    = var.virtual_environment_node_name

  source_raw {
    data      = file("${path.module}/cloud_inits/cloud_init_ubuntu_22.cfg")
    file_name = "cloud_init_ubuntu_22.yaml"
  }

  depends_on = [
      proxmox_download_file.ubuntu22_cloud_image_download
  ]

}

resource "proxmox_virtual_environment_vm" "ubuntu22_template" {
  name      = "ubuntu22-template"
  node_name = var.virtual_environment_node_name
  vm_id     = 9001

  template = true
  started  = false

  machine     = "q35"
  bios        = "ovmf"
  description = "Managed by Terraform"

  cpu {
    cores = 2
    type  = "host"
  }

  agent {
    enabled = true # wymaga qemu-guest-agent w template
  }

  memory {
    dedicated = 2048
  }

  efi_disk {
    datastore_id = var.datastore_id_vms
    type         = "4m"
  }

  # SYSTEMOWY DYSK UBUNTU
  disk {
    datastore_id = var.datastore_id_vms
    import_from  = proxmox_download_file.ubuntu22_cloud_image_download.id

    interface = "virtio0"
    iothread  = true
    discard   = "on"
    size      = 40
  }

  # CLOUD-INIT
  initialization {
    datastore_id = var.datastore_id_vms

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  operating_system {
    type = "l26"
  }

}