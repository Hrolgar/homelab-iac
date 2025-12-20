data "infisical_secrets" "cloudflare" {
  env_slug     = "dev"
  workspace_id = var.infisical_project_id
  folder_path  = "/cloudflare"
}

# Locals to extract specific secrets
locals {
  cloudflare_api_token     = data.infisical_secrets.cloudflare.secrets["api_token"].value
  cloudflare_account_id    = data.infisical_secrets.cloudflare.secrets["account_id"].value
  cloudflare_github_idp_id = data.infisical_secrets.cloudflare.secrets["github_idp_id"].value
}
