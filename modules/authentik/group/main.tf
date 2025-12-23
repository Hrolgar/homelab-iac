terraform {
  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "~> 2025.10.0"
    }
  }
}

# Group definition
resource "authentik_group" "this" {
  name         = var.name
  is_superuser = var.is_superuser
  parent       = var.parent_group_id
  users        = var.user_ids
  roles        = var.role_ids
}
