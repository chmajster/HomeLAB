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


resource "proxmox_virtual_environment_vm" "ubuntu22_vm" {
  name      = "ubuntu22"
  node_name = var.virtual_environment_node_name

  clone {
    vm_id        = module.ubuntu22-template.ubuntu22_template_id
    full         = true
    datastore_id = var.datastore_id_vms
    retries      = 3
  }

  started = true
}

resource "proxmox_virtual_environment_vm" "ubuntu24_vm" {
  name      = "ubuntu24"
  node_name = var.virtual_environment_node_name

  clone {
    vm_id        = module.ubuntu24-template.ubuntu24_template_id
    full         = true
    datastore_id = var.datastore_id_vms
    retries      = 3
  }

  started = true
}

resource "proxmox_virtual_environment_vm" "ubuntu26_vm" {
  name      = "ubuntu26"
  node_name = var.virtual_environment_node_name

  clone {
    vm_id        = module.ubuntu26-template.ubuntu26_template_id
    full         = true
    datastore_id = var.datastore_id_vms
    retries      = 3
  }

  started = true
}