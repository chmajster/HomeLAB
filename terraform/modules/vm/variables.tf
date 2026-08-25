variable "name" {
  description = "VM name"
  type        = string
}

variable "node_name" {
  description = "Proxmox node name"
  type        = string
}

variable "template_id" {
  description = "Source template VM ID"
  type        = number
}

variable "datastore_id_vms" {
  description = "Target datastore for the full clone"
  type        = string
}

variable "vm_id" {
  description = "Optional VM ID. Null lets Proxmox/Terraform select it."
  type        = number
  default     = null
  nullable    = true
}

variable "description" {
  type    = string
  default = "Managed by Terraform"
}

variable "started" {
  type    = bool
  default = true
}

variable "cpu_cores" {
  type    = number
  default = 2
}

variable "cpu_type" {
  type    = string
  default = "host"
}

variable "memory_mb" {
  type    = number
  default = 2048
}

variable "bridge" {
  type    = string
  default = "vmbr0"
}

variable "ipv4_address" {
  description = "IPv4 address in CIDR notation or dhcp"
  type        = string
  default     = "dhcp"
}

variable "ipv4_gateway" {
  description = "Optional IPv4 gateway"
  type        = string
  default     = null
  nullable    = true
}
