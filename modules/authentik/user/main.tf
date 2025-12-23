terraform {
  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "~> 2025.10.0"
    }
  }
}

# User definition
resource "authentik_user" "this" {
  username   = var.username
  name       = var.name
  email      = var.email
  password   = var.password
  is_active  = var.is_active
  type       = var.type
  path       = var.path
  groups     = var.group_ids
  attributes = var.attributes != null ? jsonencode(var.attributes) : "{}"

  lifecycle {
    # Ignore password changes after creation
    # This allows users/admins to change passwords in Authentik without Terraform trying to reset them
    # Password is only set during initial user creation
    ignore_changes = [password, groups]
  }
}
