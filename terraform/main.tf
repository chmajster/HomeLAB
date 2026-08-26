# =============================================================
# Create a Network module with two bridges: vmbr0 , vmbr1 , vmbr2
# =============================================================
# module "network" {
#   source = "./modules/network"
#   node_name = var.virtual_environment_node_name
#
#   networks = {
#     dev = {
#       bridge  = "vmbr10"
#       address = "10.0.10.1/24"
#       comment = "DEV network"
#     }
#
#     nonprod = {
#       bridge  = "vmbr20"
#       address = "10.0.20.1/24"
#       comment = "NONPROD network"
#     }
#
#     prod = {
#       bridge  = "vmbr30"
#       address = "10.0.30.1/24"
#       comment = "PROD network"
#     }
#   }
#
# }

module "ubuntu22-template" {
  source = "./modules/ubuntu22-template"

  node_name                     = var.virtual_environment_node_name
  datastore_id_iso              = var.datastore_id_iso
  datastore_id_vms              = var.datastore_id_vms
  virtual_environment_node_name = var.virtual_environment_node_name

  ubuntu22_vm_id = 9000
}

module "ubuntu24-template" {
  source = "./modules/ubuntu24-template"

  node_name                     = var.virtual_environment_node_name
  datastore_id_iso              = var.datastore_id_iso
  datastore_id_vms              = var.datastore_id_vms
  virtual_environment_node_name = var.virtual_environment_node_name

  ubuntu24_vm_id = 9001
}

module "ubuntu26-template" {
  source = "./modules/ubuntu26-template"

  node_name                     = var.virtual_environment_node_name
  datastore_id_iso              = var.datastore_id_iso
  datastore_id_vms              = var.datastore_id_vms
  virtual_environment_node_name = var.virtual_environment_node_name

  ubuntu26_vm_id = 9002
}

module "CloudPortal" {
  source = "./modules/CloudPortal"

  node_name                     = var.virtual_environment_node_name
  datastore_id_iso              = var.datastore_id_iso
  datastore_id_vms              = var.datastore_id_vms
  virtual_environment_node_name = var.virtual_environment_node_name
  ubuntu26_vm_id                = 9003
}

# ============================================================
# Virtual machines
# ============================================================

resource "proxmox_virtual_environment_vm" "ubuntu22_vm" {
  name      = "ubuntu22"
  node_name = var.virtual_environment_node_name

  clone {
    vm_id        = module.ubuntu22-template.ubuntu22_template_id
    full         = true
    datastore_id = var.datastore_id_vms
    retries      = 3
  }

  agent {
    enabled = true

    wait_for_ip {
      ipv4 = true
    }
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

  agent {
    enabled = true

    wait_for_ip {
      ipv4 = true
    }
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

  agent {
    enabled = true

    wait_for_ip {
      ipv4 = true
    }
  }

  started = true
}

resource "proxmox_virtual_environment_vm" "cloudportal_vm" {
  name      = "CloudPortal"
  node_name = var.virtual_environment_node_name

  clone {
    vm_id        = module.CloudPortal.cloudportal_template_id
    full         = true
    datastore_id = var.datastore_id_vms
    retries      = 3
  }

  agent {
    enabled = true

    wait_for_ip {
      ipv4 = true
    }
  }

  started = true
}

# ============================================================
# Ansible
#
# Przykład terraform.tfvars:
# ansible_playbooks = {
#   ubuntu22    = "../ansible/playbooks/base.yml"
#   cloudportal = "../ansible/playbooks/cloudportal.yml"
# }
#
# Brak VM w mapie = Ansible nie jest dla niej uruchamiany.
# ============================================================

locals {
  ansible_targets = {
    ubuntu22 = {
      vm_id = proxmox_virtual_environment_vm.ubuntu22_vm.vm_id
      ip = try([
        for ip in flatten(proxmox_virtual_environment_vm.ubuntu22_vm.ipv4_addresses) : ip
        if !startswith(ip, "127.")
      ][0], "")
    }

    ubuntu24 = {
      vm_id = proxmox_virtual_environment_vm.ubuntu24_vm.vm_id
      ip = try([
        for ip in flatten(proxmox_virtual_environment_vm.ubuntu24_vm.ipv4_addresses) : ip
        if !startswith(ip, "127.")
      ][0], "")
    }

    ubuntu26 = {
      vm_id = proxmox_virtual_environment_vm.ubuntu26_vm.vm_id
      ip = try([
        for ip in flatten(proxmox_virtual_environment_vm.ubuntu26_vm.ipv4_addresses) : ip
        if !startswith(ip, "127.")
      ][0], "")
    }

    cloudportal = {
      vm_id = proxmox_virtual_environment_vm.cloudportal_vm.vm_id
      ip = try([
        for ip in flatten(proxmox_virtual_environment_vm.cloudportal_vm.ipv4_addresses) : ip
        if !startswith(ip, "127.")
      ][0], "")
    }
  }
}

resource "terraform_data" "ansible_playbook" {
  for_each = var.ansible_playbooks

  triggers_replace = [
    local.ansible_targets[each.key].vm_id,
    local.ansible_targets[each.key].ip,
    each.value
  ]

  lifecycle {
    precondition {
      condition     = local.ansible_targets[each.key].ip != ""
      error_message = "Nie udało się pobrać IPv4 dla VM ${each.key}. Sprawdź qemu-guest-agent oraz konfigurację sieci."
    }
  }

  provisioner "local-exec" {
    command = join(" ", compact([
      var.ansible_command,
      "-i",
      "\"${local.ansible_targets[each.key].ip},\"",
      "-u",
      "\"${var.ansible_user}\"",
      var.ansible_private_key_file != null ? "--private-key \"${var.ansible_private_key_file}\"" : "",
      var.ansible_extra_args,
      "\"${each.value}\""
    ]))
  }
}
