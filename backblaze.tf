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

module "b2_buckets" {
  source = "./modules/b2-bucket"

  for_each = var.buckets

  bucket_name               = each.key
  public                    = each.value.public
  days_to_keep_old_versions = each.value.days_to_keep_old_versions
  region                    = each.value.region
  tags                      = each.value.tags
}