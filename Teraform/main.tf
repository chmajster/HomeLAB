# =============================================================
# Create a Network module with two bridges: vmbr0 , vmbr1 , vmbr2
# =============================================================
# module "network" {
#   source = "./modules/network"
#   node_name = var.virtual_environment_node_name

#   networks = {
#     dev = {
#       bridge  = "vmbr10"
#       address = "10.0.10.1/24"
#       comment = "DEV network"
#     }

#     nonprod = {
#       bridge  = "vmbr20"
#       address = "10.0.20.1/24"
#       comment = "NONPROD network"
#     }

#     prod = {
#       bridge  = "vmbr30"
#       address = "10.0.30.1/24"
#       comment = "PROD network"
#     }
#   }

# }



# ============================================================
# Ubuntu Cloud Image
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

resource "proxmox_download_file" "ubuntu24_cloud_image_download" {
  content_type = "import"
  datastore_id = var.datastore_id_iso
  node_name    = var.virtual_environment_node_name

  url = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"

  file_name = "noble-server-cloudimg-amd64.qcow2"

  # Overwirte if file exist and is not manage by Teraform
  overwrite_unmanaged = true

  # Nie pobieraj ponownie obrazu, jeśli plik już istnieje.
  overwrite = false
  
  # Check SSL certificate, set to false if using self-signed certificate
  verify = false

}


resource "proxmox_download_file" "ubuntu26_cloud_image_download" {
  content_type = "import"
  datastore_id = var.datastore_id_iso
  node_name    = var.virtual_environment_node_name

  url = "https://cloud-images.ubuntu.com/resolute/current/resolute-server-cloudimg-amd64.img"

  file_name = "resolute-server-cloudimg-amd64.qcow2"

  # Overwirte if file exist and is not manage by Teraform
  overwrite_unmanaged = true

  # Nie pobieraj ponownie obrazu, jeśli plik już istnieje.
  overwrite = false
  
  # Check SSL certificate, set to false if using self-signed certificate
  verify = false

}

# ============================================================
# Cloud-init
# ============================================================

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


resource "proxmox_virtual_environment_file" "cloud_init_ubuntu24" {
  content_type = "snippets"
  datastore_id = var.datastore_id_iso
  node_name    = var.virtual_environment_node_name

  source_raw {
    data      = file("${path.module}/cloud_inits/cloud_init_ubuntu_24.cfg")
    file_name = "cloud_init_ubuntu_24.yaml"
  }

  depends_on = [
      proxmox_download_file.ubuntu24_cloud_image_download
  ]


}

resource "proxmox_virtual_environment_file" "cloud_init_ubuntu26" {
  content_type = "snippets"
  datastore_id = var.datastore_id_iso
  node_name    = var.virtual_environment_node_name

  source_raw {
    data      = file("${path.module}/cloud_inits/cloud_init_ubuntu_26.cfg")
    file_name = "cloud_init_ubuntu_26.yaml"
  }

  depends_on = [
      proxmox_download_file.ubuntu26_cloud_image_download
  ]


}


# ============================================================
# TEMPLATE - Ubuntu
# ============================================================

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

resource "proxmox_virtual_environment_vm" "ubuntu24_template" {
  name      = "ubuntu24-template"
  node_name = var.virtual_environment_node_name
  vm_id     = 9002

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
    import_from  = proxmox_download_file.ubuntu24_cloud_image_download.id

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


resource "proxmox_virtual_environment_vm" "ubuntu26_template" {
  name      = "ubuntu26-template"
  node_name = var.virtual_environment_node_name
  vm_id     = 9003

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
    import_from  = proxmox_download_file.ubuntu26_cloud_image_download.id

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

# ============================================================
# POJEDYNCZA VM - ubuntu01
# ============================================================

resource "proxmox_virtual_environment_vm" "ubuntu24" {
  name      = "ubuntu24"
  node_name = var.virtual_environment_node_name
  #vm_id - nie musi byc podawane
  #vm_id     = 101

  started         = true
  stop_on_destroy = true

  bios        = "ovmf"
  description = "Managed by Terraform Ubuntu1"

  # clone {
  #   import_from  = proxmox_virtual_environment_vm.ubuntu_template.vm_id
  #   full         = true
  #   datastore_id = var.datastore_id_vms
  #   retries = 3
  # }
  clone {
    vm_id = proxmox_virtual_environment_vm.ubuntu24_template.vm_id
    full = true
    datastore_id = var.datastore_id_vms
    retries = 3
  }
  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  network_device {
    bridge = "vmbr0"
  }

  agent {
    enabled = true
  }
  initialization {
    datastore_id = var.datastore_id_vms
    upgrade = false
    user_data_file_id = proxmox_virtual_environment_file.cloud_init_ubuntu24.id

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }


}


resource "proxmox_virtual_environment_vm" "ubuntu26" {
  name      = "ubuntu26"
  node_name = var.virtual_environment_node_name
  #vm_id - nie musi byc podawane
  #vm_id     = 101

  started         = true
  stop_on_destroy = true

  bios        = "ovmf"
  description = "Managed by Terraform Ubuntu1"

  # clone {
  #   import_from  = proxmox_virtual_environment_vm.ubuntu_template.vm_id
  #   full         = true
  #   datastore_id = var.datastore_id_vms
  #   retries = 3
  # }
  clone {
    vm_id = proxmox_virtual_environment_vm.ubuntu26_template.vm_id
    full = true
    datastore_id = var.datastore_id_vms
    retries = 3
  }
  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  network_device {
    bridge = "vmbr0"
  }

  agent {
    enabled = true
  }
  initialization {
    datastore_id = var.datastore_id_vms
    upgrade = false
    user_data_file_id = proxmox_virtual_environment_file.cloud_init_ubuntu26.id

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }


}

