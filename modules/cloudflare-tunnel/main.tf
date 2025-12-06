
terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

# Configure the tunnel's ingress rules
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "this" {
  account_id = var.account_id
  tunnel_id  = var.tunnel_id

  config = {
    ingress = concat(
      [for hostname, route in var.routes : {
        hostname = "${hostname}.${route.domain}"
        service  = route.service
        origin_request = route.origin_request
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
  content = "${var.tunnel_id}.cfargotunnel.com"
  proxied = true
  ttl     = 1  # Auto TTL when proxied
  comment = "Managed by OpenTofu - ${var.tunnel_name} tunnel"
}
