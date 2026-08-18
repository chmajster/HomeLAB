# ============================================================
# Ubuntu Cloud Image
# ============================================================

resource "proxmox_download_file" "ubuntu_cloud_image" {
  content_type = "import"
  datastore_id = "local"
  node_name    = var.virtual_environment_node_name

  url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"

  file_name = "jammy-server-cloudimg-amd64.qcow2"
  # Overwirte if file exist and is not manage by Teraform
  overwrite_unmanaged = true
}


# ============================================================
# Cloud-init
# ============================================================

resource "proxmox_virtual_environment_file" "cloud_init_ubuntu" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.virtual_environment_node_name

  source_raw {
    data      = file("${path.module}/cloud_inits/cloud_init_ubuntu.cfg")
    file_name = "cloud_init_ubuntu.cfg"
  }
}


# ============================================================
# TEMPLATE - Ubuntu
# ============================================================

resource "proxmox_virtual_environment_vm" "ubuntu_template" {
  name      = "ubuntu-template"
  node_name = var.virtual_environment_node_name
  vm_id     = 9000

  template = true
  started  = false

  machine     = "q35"
  bios        = "ovmf"
  description = "Managed by Terraform"

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 2048
  }

  efi_disk {
    datastore_id = var.datastore_id
    type         = "4m"
  }

  # SYSTEMOWY DYSK UBUNTU
  disk {
    datastore_id = var.datastore_id
    import_from  = proxmox_download_file.ubuntu_cloud_image.id

    interface = "virtio0"
    iothread  = true
    discard   = "on"
    size      = 20
  }

  # CLOUD-INIT
  initialization {
    datastore_id = var.datastore_id

    user_data_file_id = proxmox_virtual_environment_file.cloud_init_ubuntu.id

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }
}


# ============================================================
# POJEDYNCZA VM - ubuntu01
# ============================================================

resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name      = "ubuntu01"
  node_name = var.virtual_environment_node_name
  #vm_id - nie musi byc podawane
  #vm_id     = 101

  started = true

  clone {
    vm_id        = proxmox_virtual_environment_vm.ubuntu_template.vm_id
    full         = true
    datastore_id = var.datastore_id

    retries = 3
  }

  agent {
    enabled = true # wymaga qemu-guest-agent w template
  }

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 2048
  }

  initialization {
    datastore_id = var.datastore_id

    user_data_file_id = proxmox_virtual_environment_file.cloud_init_ubuntu.id

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }
}

