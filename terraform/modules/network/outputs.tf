output "bridges" {
  description = "Managed Linux bridge names"
  value       = { for key, bridge in proxmox_network_linux_bridge.this : key => bridge.name }
}
