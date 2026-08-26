# =============================================================
# Create a Network module with two bridges: vmbr0 , vmbr1 , vmbr2
# =============================================================

module "network" {
  source = "./modules/network"
  node_name = var.virtual_environment_node_name

  networks = {
    dev = {
      bridge  = var.dev_network_device
      address = var.dev_network_address
      comment = "DEV network"
    }

    nonprod = {
      bridge  = var.nonprod_network_device
      address = var.nonprod_network_address
      comment = "NONPROD network"
    }

    prod = {
      bridge  = var.prod_network_device
      address = var.prod_network_address
      comment = "PROD network"
    }
  }
 
}


module "ubuntu22-template" {
  source = "./modules/ubuntu22-template"

  node_name        = var.virtual_environment_node_name
  datastore_id_iso = var.datastore_id_iso
  datastore_id_vms = var.datastore_id_vms
  virtual_environment_node_name = var.virtual_environment_node_name
  
  ubuntu22_vm_id = 9000

}

module "ubuntu24-template" {
  source = "./modules/ubuntu24-template"

  node_name        = var.virtual_environment_node_name
  datastore_id_iso = var.datastore_id_iso
  datastore_id_vms = var.datastore_id_vms
  virtual_environment_node_name = var.virtual_environment_node_name
  
  ubuntu24_vm_id = 9001
}

module "ubuntu26-template" {
  source = "./modules/ubuntu26-template"

  node_name        = var.virtual_environment_node_name
  datastore_id_iso = var.datastore_id_iso
  datastore_id_vms = var.datastore_id_vms
  virtual_environment_node_name = var.virtual_environment_node_name
  
  ubuntu26_vm_id = 9002
}

module "CloudPortal" {
  source = "./modules/CloudPortal"

  node_name                     = var.virtual_environment_node_name
  virtual_environment_node_name = var.virtual_environment_node_name

  datastore_id_iso = var.datastore_id_iso
  datastore_id_vms = var.datastore_id_vms

  template_id = module.ubuntu26-template.ubuntu26_template_id
}


# resource "proxmox_virtual_environment_vm" "ubuntu22_vm" {
#   name      = "ubuntu22"
#   node_name = var.virtual_environment_node_name

#   clone {
#     vm_id        = module.ubuntu22-template.ubuntu22_template_id
#     full         = true
#     datastore_id = var.datastore_id_vms
#     retries      = 3
#   }

#   started = true
# }

# resource "proxmox_virtual_environment_vm" "ubuntu24_vm" {
#   name      = "ubuntu24"
#   node_name = var.virtual_environment_node_name

#   clone {
#     vm_id        = module.ubuntu24-template.ubuntu24_template_id
#     full         = true
#     datastore_id = var.datastore_id_vms
#     retries      = 3
#   }

#   started = true
# }

# resource "proxmox_virtual_environment_vm" "ubuntu26_vm" {
#   name      = "ubuntu26"
#   node_name = var.virtual_environment_node_name

#   clone {
#     vm_id        = module.ubuntu26-template.ubuntu26_template_id
#     full         = true
#     datastore_id = var.datastore_id_vms
#     retries      = 3
#   }

#   started = true
# }


resource "proxmox_virtual_environment_vm" "cloudportal_vm" {
  name      = "CloudPortal"
  node_name = var.virtual_environment_node_name

  clone {
    vm_id        = module.CloudPortal.cloudportal_id
    full         = true
    datastore_id = var.datastore_id_vms
    retries      = 3
  }

  started = true
}