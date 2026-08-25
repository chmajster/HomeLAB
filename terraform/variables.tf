variable "virtual_environment_endpoint" {
  description = "proxmox endpoint"
  type        = string
  sensitive   = true
}
variable "virtual_environment_username" {
  description = "Nazwa użytkownika do Proxmox"
  type        = string
}
variable "virtual_environment_password" {
  description = "Hasło do Proxmox"
  type        = string
  sensitive   = true
}

variable "virtual_environment_node_name" {
  description = "Nazwa clustra"
  type        = string
}

variable "datastore_id_vms" {
  description = "datastore_id_vms"
  type        = string
}

variable "datastore_id_iso" {
  description = "Datastore dla obrazów ISO/import"
  type        = string
}

variable "datastore_id_files" {
  description = "Datastore dla obrazów ISO/import"
  type        = string
}

variable "datastore_id_vms_hdd" {
  description = "Datastore dla obrazów ISO/import"
  type        = string
}

