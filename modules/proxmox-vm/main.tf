terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  name        = var.vm_name
  description = var.description
  tags = var.tags
  pool_id     = var.pool
  node_name   = var.node
  on_boot     = var.onboot
  started     = var.started

  clone {
    vm_id = var.template_id
    full  = true
  }

  cpu {
    cores   = var.cores
    sockets = var.sockets
    type    = var.cpu_type
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.storage
    interface    = "scsi0"
    size         = var.disk_size
    file_format  = "raw"
  }

  network_device {
    bridge  = "vmbr0"
    model   = "virtio"
    vlan_id = var.vlan
  }

  agent {
    enabled = true
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${var.ip}/24"
        gateway = var.gateway
      }
    }
    dns {
      servers = [var.nameserver]
    }
    user_account {
      username = var.ci_user
      password = var.ci_password
      keys     = var.ci_ssh_keys
    }
  }

  lifecycle {
    ignore_changes = [
      initialization,
    ]
  }
}
