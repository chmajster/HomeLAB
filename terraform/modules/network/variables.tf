variable "node_name" {
  description = "Proxmox node name"
  type        = string
}

variable "networks" {
  description = "Linux bridges to manage"
  type = map(object({
    bridge  = string
    address = optional(string)
    comment = optional(string)
  }))
  default = {}
}
