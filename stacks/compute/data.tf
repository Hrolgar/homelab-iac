data "infisical_secrets" "proxmox" {
  env_slug     = "dev"
  workspace_id = var.infisical_project_id
  folder_path  = "/proxmox"
}

# Locals to extract specific secrets
locals {
  proxmox_api_token_id     = data.infisical_secrets.proxmox.secrets["api_token_id"].value
  proxmox_api_token_secret = data.infisical_secrets.proxmox.secrets["api_token_secret"].value
  proxmox_api_token        = "${local.proxmox_api_token_id}=${local.proxmox_api_token_secret}"

  # Cloud-Init credentials
  proxmox_ci_password  = data.infisical_secrets.proxmox.secrets["vm_password"].value
  proxmox_ci_ssh_keys  = data.infisical_secrets.proxmox.secrets["ssh_public_keys"].value
}
