terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    infisical = {
      source = "infisical/infisical"
    }
  }
}

# Create the tunnel (remotely managed via Cloudflare dashboard/API)
resource "cloudflare_zero_trust_tunnel_cloudflared" "this" {
  account_id = var.account_id
  name       = var.tunnel_name
  config_src = "cloudflare"
}

# Fetch the tunnel token
data "cloudflare_zero_trust_tunnel_cloudflared_token" "this" {
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.this.id
}

# Configure the tunnel's ingress rules
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "this" {
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.this.id

  config = {
    ingress = concat(
      [for hostname, route in var.routes : {
        hostname = "${hostname}.${route.domain}"
        service  = route.service
        origin_request = {
          no_tls_verify = route.no_tls_verify
          http2_origin  = route.http2_origin
        }
      }],
      # Catch-all rule (required by Cloudflare)
      [{
        service = var.catch_all_service
      }]
    )
  }
}

# Create DNS CNAME records pointing to the tunnel
resource "cloudflare_dns_record" "tunnel_routes" {
  for_each = var.routes

  zone_id = var.zone_ids[each.value.domain]
  name    = each.key
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.this.id}.cfargotunnel.com"
  proxied = true
  ttl     = 1
  comment = "Managed by OpenTofu - ${var.tunnel_name} tunnel"
}

# Store tunnel_id in Infisical
resource "infisical_secret" "tunnel_id" {
  count = var.store_in_infisical ? 1 : 0

  folder_path  = var.infisical_folder_path
  env_slug     = var.infisical_env_slug
  workspace_id = var.infisical_workspace_id
  name         = "${var.tunnel_name}_tunnel_id"
  value        = cloudflare_zero_trust_tunnel_cloudflared.this.id
}

# Store tunnel_token in Infisical
resource "infisical_secret" "tunnel_token" {
  count = var.store_in_infisical ? 1 : 0

  folder_path  = var.infisical_folder_path
  env_slug     = var.infisical_env_slug
  workspace_id = var.infisical_workspace_id
  name         = "${var.tunnel_name}_tunnel_token"
  value        = data.cloudflare_zero_trust_tunnel_cloudflared_token.this.token
}
