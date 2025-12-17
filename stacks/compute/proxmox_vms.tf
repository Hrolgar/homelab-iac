# Get template VM ID
data "proxmox_virtual_environment_vms" "template" {
  node_name = var.proxmox_node

  filter {
    name   = "template"
    values = [true]
  }

  filter {
    name   = "name"
    values = [var.proxmox_template]
  }
}

locals {
  template_id = data.proxmox_virtual_environment_vms.template.vms[0].vm_id
}

# Create VMs
module "proxmox_vms" {
  source   = "../../modules/proxmox-vm"
  for_each = var.vms

  vm_name     = each.key
  description = each.value.description
  node        = coalesce(each.value.node, var.proxmox_node)
  template_id = local.template_id

  cores     = each.value.cores
  sockets  = each.value.sockets
  cpu_type = each.value.cpu_type

  memory    = each.value.memory
  disk_size = tonumber(replace(each.value.disk_size, "G", ""))
  storage   = each.value.storage

  ip         = each.value.ip
  gateway    = each.value.gateway
  nameserver = each.value.nameserver
  vlan       = each.value.vlan

  onboot  = each.value.onboot
  started = each.value.started
  tags    = each.value.tags
  pool    = each.value.pool

  ci_user     = var.proxmox_ci_user
  ci_password = var.proxmox_ci_password
  ci_ssh_keys = try(split(",", var.proxmox_ci_ssh_keys), [])

}
