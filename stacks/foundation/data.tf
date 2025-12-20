data "infisical_secrets" "proxmox" {
  env_slug     = "dev"
  workspace_id = var.infisical_project_id
  folder_path  = "/proxmox"
}

data "infisical_secrets" "b2" {
  env_slug     = "dev"
  workspace_id = var.infisical_project_id
  folder_path  = "/b2"
}

# Locals to extract specific secrets
locals {
  # Proxmox Secrets
  proxmox_api_token_id     = data.infisical_secrets.proxmox.secrets["api_token_id"].value
  proxmox_api_token_secret = data.infisical_secrets.proxmox.secrets["api_token_secret"].value
  proxmox_api_token        = "${local.proxmox_api_token_id}=${local.proxmox_api_token_secret}"

  # Backblaze B2 Secrets
  b2_application_key_id = data.infisical_secrets.b2.secrets["b2_application_key_id"].value
  b2_application_key    = data.infisical_secrets.b2.secrets["b2_application_key"].value
}
