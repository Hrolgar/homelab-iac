output "vm_id" {
  description = "The VM ID"
  value       = proxmox_virtual_environment_vm.this.vm_id
}

output "vm_name" {
  description = "The VM name"
  value       = proxmox_virtual_environment_vm.this.name
}

output "ip_address" {
  description = "The VM IP address"
  value       = var.ip
}

output "mac_address" {
  description = "The VM MAC address"
  value       = proxmox_virtual_environment_vm.this.network_device[0].mac_address
}
