terraform {
  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "~> 2025.10.0"
    }
  }
}

# Policy binding to application
resource "authentik_policy_binding" "this" {
  target  = var.target_id
  group   = var.group_id
  user    = var.user_id
  order   = var.order
  enabled = var.enabled
  timeout = var.timeout
}
