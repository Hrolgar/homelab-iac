variable "b2_backup_bucket_key_id" {
  description = "Backblaze B2 Key ID for the backup bucket"
  type        = string
}

variable "b2_backup_bucket_application_key" {
  description = "Backblaze B2 Application Key for the backup bucket"
  type        = string
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
