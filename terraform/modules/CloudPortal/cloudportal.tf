# ============================================================
# Cloud-init dla CloudPortal
# ============================================================



resource "proxmox_virtual_environment_file" "CloudPortal" {
  content_type = "snippets"
  datastore_id = var.datastore_id_iso
  node_name    = var.virtual_environment_node_name

  source_raw {
    data      = file("${path.module}/cloud_inits/cloud_init_portal.cfg")
    file_name = "cloud_init_portal.yaml"
  }
}


# ============================================================
# CloudPortal VM
# ============================================================

resource "proxmox_virtual_environment_vm" "CloudPortal" {
  name      = "CloudPortal"
  node_name = var.virtual_environment_node_name

  started         = true
  stop_on_destroy = true

  bios        = "ovmf"
  description = "HomeLAB Cloud Portal - Managed by Terraform"

  clone {
    vm_id        = var.template_id
    full         = true
    datastore_id = var.datastore_id_vms
    retries      = 3
  }

  cpu {
    cores = 4
  }

  memory {
    dedicated = 4096
  }

  network_device {
    bridge = "vmbr0"
  }

  agent {
    enabled = true
  }

  initialization {
    datastore_id = var.datastore_id_vms
    upgrade       = false

    user_data_file_id = proxmox_virtual_environment_file.CloudPortal.id

    # ip_config {
    #   ipv4 {
    #     address = "dhcp"
    #   }

    ip_config {
      ipv4 {
        address = "10.0.0.11/24"
        gateway = "10.0.0.1"
      }

    }
  }
}