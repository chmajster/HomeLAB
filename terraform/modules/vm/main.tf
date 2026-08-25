resource "proxmox_virtual_environment_vm" "this" {
  name      = var.name
  node_name = var.node_name
  vm_id     = var.vm_id

  started         = var.started
  stop_on_destroy = true
  description     = var.description

  clone {
    vm_id        = var.template_id
    full         = true
    datastore_id = var.datastore_id_vms
    retries      = 3
  }

  cpu {
    cores = var.cpu_cores
    type  = var.cpu_type
  }

  memory {
    dedicated = var.memory_mb
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = var.bridge
    model  = "virtio"
  }

  initialization {
    datastore_id = var.datastore_id_vms
    upgrade      = false

    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.ipv4_gateway
      }
    }
  }
}
