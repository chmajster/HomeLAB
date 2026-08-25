module "cloudportal" {
  source = "../modules/vm"

  name             = "cloudportal"
  node_name        = var.node_name
  template_id      = var.ubuntu24_template_id
  datastore_id_vms = var.datastore_id_vms
  bridge           = var.bridge

  cpu_cores = 2
  memory_mb = 4096

  description = "HomeLAB Cloud Portal server - managed by Terraform"
}
