variable "node_name" {
  description = "Proxmox node name"
  type        = string
}

variable "datastore_id_iso" {
  description = "Datastore used for downloaded cloud images"
  type        = string
}

variable "datastore_id_vms" {
  description = "Datastore used for template disks"
  type        = string
}

variable "bridge" {
  description = "Bridge attached to templates"
  type        = string
  default     = "vmbr0"
}

variable "ubuntu22_template_id" {
  type    = number
  default = 9000
}

variable "ubuntu24_template_id" {
  type    = number
  default = 9001
}

variable "ubuntu26_template_id" {
  type    = number
  default = 9002
}
