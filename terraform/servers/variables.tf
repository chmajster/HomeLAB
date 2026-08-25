variable "node_name" {
  type = string
}

variable "datastore_id_vms" {
  type = string
}

variable "bridge" {
  type    = string
  default = "vmbr0"
}

variable "ubuntu22_template_id" {
  type = number
}

variable "ubuntu24_template_id" {
  type = number
}

variable "ubuntu26_template_id" {
  type = number
}
