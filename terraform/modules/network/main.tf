resource "proxmox_network_linux_bridge" "networks" {
  for_each = var.networks

  node_name = var.node_name

  name      = each.value.bridge
  address   = each.value.address
  comment   = each.value.comment
  autostart = true
}