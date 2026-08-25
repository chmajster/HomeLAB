variable "virtual_environment_endpoint" {
  description = "Proxmox API endpoint, e.g. https://10.0.0.10:8006/"
  type        = string
  sensitive   = true
}

variable "virtual_environment_username" {
  description = "Proxmox API username"
  type        = string
}

variable "virtual_environment_password" {
  description = "Proxmox API password"
  type        = string
  sensitive   = true
}

variable "virtual_environment_node_name" {
  description = "Proxmox node name"
  type        = string
}

variable "datastore_id_vms" {
  description = "Datastore used for VM disks"
  type        = string
}

variable "datastore_id_iso" {
  description = "Datastore used for cloud image imports"
  type        = string
}

variable "vm_bridge" {
  description = "Default bridge used by templates and servers"
  type        = string
  default     = "vmbr0"
}

variable "networks" {
  description = "Optional Linux bridges managed by Terraform"
  type = map(object({
    bridge  = string
    address = optional(string)
    comment = optional(string)
  }))
  default = {}
}
