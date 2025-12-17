variable "proxmox_node" {
  type = string
}

variable "proxmox_template" {
  type = string
}

variable "vms" {
  type = map(any)
}


variable "proxmox_ci_user" {
  description = "Cloud-Init user for VMs"
  type        = string
}

variable "proxmox_ci_password" {
  type      = string
  sensitive = true
}

variable "proxmox_ci_ssh_keys" {
  type      = string
  sensitive = true
}
