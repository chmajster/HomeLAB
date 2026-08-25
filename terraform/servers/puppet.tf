module "puppet" {
  source = "../modules/vm"

  name             = "puppet"
  node_name        = var.node_name
  template_id      = var.ubuntu24_template_id
  datastore_id_vms = var.datastore_id_vms
  bridge           = var.bridge

  cpu_cores = 2
  memory_mb = 4096

  description = "HomeLAB Puppet server - managed by Terraform"
}
