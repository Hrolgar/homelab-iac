module "proxmox_pools" {
  source   = "../../modules/proxmox-pool"
  for_each = var.proxmox_pools

  pool_id = each.key
  comment = each.value.comment
}