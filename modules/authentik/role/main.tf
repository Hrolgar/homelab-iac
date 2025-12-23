terraform {
  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "~> 2025.10.0"
    }
  }
}

# Role definition
resource "authentik_rbac_role" "this" {
  name = var.name
}
