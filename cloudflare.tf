# Cloudflare Zone Data Sources
data "cloudflare_zone" "zones" {
  for_each = toset(var.cloudflare_domains)
  
  filter = {
    name = each.value
  }
}

locals {
  # Map domain names to zone IDs for easy lookup
  zone_ids = {
    for domain in var.cloudflare_domains : domain => data.cloudflare_zone.zones[domain].zone_id
  }
  
  # Map tunnel names to their IDs from Infisical
  tunnel_ids = {
    homeassistant  = data.infisical_secrets.cloudflare_tunnels.secrets["homeassistant_tunnel_id"].value
    ullrmedia      = data.infisical_secrets.cloudflare_tunnels.secrets["ullrmedia_tunnel_id"].value
    ullraudio      = data.infisical_secrets.cloudflare_tunnels.secrets["ullraudio_tunnel_id"].value
    ullrservarr    = data.infisical_secrets.cloudflare_tunnels.secrets["ullrservarr_tunnel_id"].value
    ullrutillities = data.infisical_secrets.cloudflare_tunnels.secrets["ullrutillities_tunnel_id"].value
  }
}

module "cloudflare_tunnels" {
  source   = "./modules/cloudflare-tunnel"
  for_each = var.tunnels

  account_id  = data.infisical_secrets.cloudflare.secrets["account_id"].value
  tunnel_id   = local.tunnel_ids[each.key]
  tunnel_name = each.key
  zone_ids    = local.zone_ids
  routes      = each.value.routes
}
