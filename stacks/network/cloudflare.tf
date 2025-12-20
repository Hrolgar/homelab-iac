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
}



module "cloudflare_tunnels" {
  source   = "../../modules/cloudflare-tunnel"
  for_each = var.tunnels

  account_id  = local.cloudflare_account_id
  tunnel_name = each.key
  zone_ids    = local.zone_ids
  routes      = each.value.routes

  # Infisical integration
  store_in_infisical     = true
  infisical_folder_path  = "/cloudflare/tunnels"
  infisical_env_slug     = "dev"
  infisical_workspace_id = var.infisical_project_id
}


# Access Applications (Zero Trust)
module "cloudflare_access" {
  source   = "../../modules/cloudflare-access"
  for_each = var.access_apps

  account_id    = local.cloudflare_account_id
  domain        = each.value.domain
  subdomain     = each.value.subdomain
  app_name      = each.key
  github_idp_id = local.cloudflare_github_idp_id
  allowed_email = each.value.allowed_email

  session_duration          = try(each.value.session_duration, "24h")
  auto_redirect_to_identity = try(each.value.auto_redirect, true)
  skip_interstitial         = try(each.value.skip_interstitial, true)
}