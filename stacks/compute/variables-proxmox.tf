variable "proxmox_host" {
  description = "Proxmox host URL (e.g., https://10.69.1.5:8006)"
  type        = string
}

variable "proxmox_node" {
  description = "Default Proxmox node name"
  type        = string
  default     = "ullr"
}

variable "proxmox_template" {
  description = "Default VM template to clone"
  type        = string
  default     = "debian-template"
}


variable "proxmox_ci_user" {
  description = "Cloud-Init user for VMs"
  type        = string
}


variable "vms" {
  description = "Map of VMs to create"
  type = map(object({
    cores       = optional(number, 2)
    sockets     = optional(number, 1)
    cpu_type    = optional(string, "host")
    memory      = optional(number, 2048)
    disk_size   = optional(string, "20G")
    storage     = optional(string, "local-lvm")
    ip          = string
    gateway     = optional(string, "10.69.1.1")
    nameserver  = optional(string, "10.69.1.4")
    template    = optional(string, null)
    node        = optional(string, null)
    vlan        = optional(number, null)
    onboot      = optional(bool, true)
    started     = optional(bool, true)
    description = optional(string, "")
    tags        = optional(list(string), [])
    pool        = optional(string, null)
  }))
  default = {}
}
