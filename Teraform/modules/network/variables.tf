
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

variable "dns_server" {
  description = "Adres serwera DNS"
  type        = string
}
variable "dev_network_address" {
  description = "Adres DEV sieci"
  type        = string
}
variable "dev_gateway" {
  description = "Adres dev bramy domyślnej"
  type        = string
}
variable "nonprod_network_address" {
  description = "Adres NONPROD sieci"
  type        = string
}
variable "nonprod_gateway" {
  description = "Adres nonprod bramy domyślnej"
  type        = string
}
variable "prod_network_address" {
  description = "Adres PROD sieci"
  type        = string
}
variable "prod_gateway" {
  description = "Adres prod bramy domyślnej"
  type        = string
}