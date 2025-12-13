terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

resource "proxmox_virtual_environment_pool" "this" {
  pool_id = var.pool_id
  comment = var.comment
}