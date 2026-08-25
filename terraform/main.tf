module "network" {
  source = "./modules/network"

  node_name = var.virtual_environment_node_name
  networks  = var.networks
}

module "templates" {
  source = "./modules/templates"

  node_name        = var.virtual_environment_node_name
  datastore_id_iso = var.datastore_id_iso
  datastore_id_vms = var.datastore_id_vms
  bridge           = var.vm_bridge

  ubuntu22_template_id = 9000
  ubuntu24_template_id = 9001
  ubuntu26_template_id = 9002

  depends_on = [module.network]
}

module "servers" {
  source = "./servers"

  node_name        = var.virtual_environment_node_name
  datastore_id_vms = var.datastore_id_vms
  bridge           = var.vm_bridge

  ubuntu22_template_id = module.templates.ubuntu22_template_id
  ubuntu24_template_id = module.templates.ubuntu24_template_id
  ubuntu26_template_id = module.templates.ubuntu26_template_id
}
