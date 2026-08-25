resource "proxmox_network_linux_bridge" "this" {
  for_each = var.networks

  node_name = var.node_name
  name      = each.value.bridge
  address   = try(each.value.address, null)
  comment   = try(each.value.comment, null)
}
