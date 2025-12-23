provider "authentik" {
  url   = var.authentik_url
  token = local.authentik_token
}

provider "infisical" {
  host          = var.infisical_host
  client_id     = var.infisical_client_id
  client_secret = var.infisical_client_secret
}
