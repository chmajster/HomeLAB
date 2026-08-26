
variable "networks" {
  description = "Proxmox internal networks"

  type = map(object({
    bridge  = string
    address = string
    comment = string
  }))
}

variable "node_name" {
  description = "Proxmox node name"
  type        = string
}

