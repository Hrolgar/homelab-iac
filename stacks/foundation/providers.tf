provider "infisical" {
  host = var.infisical_host
  auth = {
    universal = {
      client_id     = var.infisical_client_id
      client_secret = var.infisical_client_secret
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_host
  api_token = local.proxmox_api_token
  insecure  = true
}


provider "b2" {
  application_key_id = local.b2_application_key_id
  application_key    = local.b2_application_key
}