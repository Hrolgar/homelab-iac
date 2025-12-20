variable "proxmox_pools" {
  description = "Map of Proxmox pools to create"
  type = map(object({
    comment = optional(string, "")
  }))
  default = {}
}

variable "proxmox_host" {
  description = "Proxmox VE API endpoint"
  type        = string
}