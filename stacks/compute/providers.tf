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
#   api_token = "${data.infisical_secrets.proxmox.secrets["api_token_id"].value}=${data.infisical_secrets.proxmox.secrets["api_token_secret"].value}"
  insecure  = true
}