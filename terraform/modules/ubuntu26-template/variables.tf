variable "node_name" {
  description = "Proxmox node name"
  type        = string
}

variable "datastore_id_iso" {
  description = "Datastore used for downloaded cloud images"
  type        = string
  default     = "local"
}

variable "datastore_id_vms" {
  description = "Datastore used for VM disks"
  type        = string
  default     = "local-lvm"
}

variable "ubuntu22_vm_id" {
  type    = number
  default = 9000
}

variable "ubuntu24_vm_id" {
  type    = number
  default = 9001
}

variable "ubuntu26_vm_id" {
  type    = number
  default = 9002
}
variable "virtual_environment_node_name" {
  description = "Proxmox node name"
  type        = string
}