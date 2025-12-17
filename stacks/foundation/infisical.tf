module "infisical_secrets" {
  source   = "../../modules/infisical-secrets"
  for_each = var.infisical_secrets

  project_id  = var.infisical_project_id
  env_slug    = each.value.env_slug
  folder_path = each.value.folder_path
  secrets     = each.value.secrets
}

locals {
  buckets_to_store = { for k, v in var.buckets : k => v if v.store_keys_in_infisical }
}

module "bucket_keys_to_infisical" {
  source   = "../../modules/infisical-secrets"
  for_each = local.buckets_to_store

  project_id  = var.infisical_project_id
  env_slug    = "dev"
  folder_path = "/b2/buckets"
  secrets = {
    "${each.key}_key_id" = module.b2_buckets[each.key].key_id
    "${each.key}_key"    = module.b2_buckets[each.key].application_key
  }
}