resource "proxmox_network_linux_bridge" "vmbr0" {
  node_name = var.node_name
  name      = "vmbr0"
}

resource "proxmox_network_linux_bridge" "vmbr1" {
  node_name = var.node_name
  name      = "vmbr1"
}

resource "proxmox_network_linux_bridge" "vmbr2" {
  node_name = var.node_name
  name      = "vmbr2"
}

