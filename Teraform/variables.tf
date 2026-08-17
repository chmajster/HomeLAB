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
  description = "Nazwa węzła"
  type        = string
}

variable "datastore_id" {
  description = "datastore_id"
  type        = string
}



