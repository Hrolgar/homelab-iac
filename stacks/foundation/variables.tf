variable "infisical_secrets" {
  type = map(any)
}

variable "infisical_project_id" {
  type = string
}

variable "proxmox_pools" {
  type = map(any)
}

variable "buckets" {
  description = "Map of B2 buckets to create"
  type = map(object({
    region                  = string
    public                  = optional(bool, false)
    days_to_keep_old_versions = optional(number, null)
    store_keys_in_infisical = optional(bool, false)
    tags                    = optional(map(string), {})
  }))
  default = {}
}
