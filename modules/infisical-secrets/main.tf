terraform {
  required_providers {
    infisical = {
      source = "infisical/infisical"
    }
  }
}

resource "infisical_secret" "this" {
  for_each = var.secrets

  name         = each.key
  value        = each.value
  env_slug     = var.env_slug
  workspace_id = var.project_id
  folder_path  = var.folder_path
}