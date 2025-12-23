terraform {
  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "~> 2025.10.0"
    }
  }
}

# Proxy provider definition
resource "authentik_provider_proxy" "this" {
  name               = var.proxy_name
  authorization_flow = var.authorization_flow
  invalidation_flow  = var.invalidation_flow
  external_host      = var.external_host
  internal_host      = var.internal_host
  mode               = var.mode
}

# Corresponding application
resource "authentik_application" "this" {
  name               = var.proxy_name
  slug               = lower(replace(var.proxy_name, " ", "-"))
  group              = var.application_group
  protocol_provider  = authentik_provider_proxy.this.id
  policy_engine_mode = "any"
}

# Attach provider to outpost if specified
resource "authentik_outpost_provider_attachment" "this" {
  count = var.outpost_id != null ? 1 : 0

  outpost           = var.outpost_id
  protocol_provider = authentik_provider_proxy.this.id
}

