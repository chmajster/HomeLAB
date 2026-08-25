# ============================================================
# Ubuntu 26.04 LTS Cloud-init
# ============================================================


resource "proxmox_virtual_environment_vm" "cloudportal" {
  name      = "cloudportal"
  node_name = var.virtual_environment_node_name
  #vm_id - nie musi byc podawane
  #vm_id     = 101

  started         = true
  stop_on_destroy = true

  bios        = "ovmf"
  description = "Managed by Terraform Ubuntu1"

  # clone {
  #   import_from  = proxmox_virtual_environment_vm.ubuntu26_template.vm_id
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
    user_data_file_id = proxmox_virtual_environment_file.cloudportal.id

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }
}