terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
    infisical = {
      source  = "infisical/infisical"
      version = "~> 0.15.52"
    }
  }
}