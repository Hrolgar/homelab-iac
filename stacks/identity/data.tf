data "infisical_secrets" "authentik" {
  env_slug     = "dev"
  workspace_id = var.infisical_project_id
  folder_path  = "/auth"
}

# Infisical secrets for admin user passwords
# Store admin passwords in Infisical at: /auth/admin-users/
data "infisical_secrets" "admin_passwords" {
  env_slug    = var.infisical_env_slug
  workspace_id = var.infisical_project_id
  folder_path = "/auth/admin-users"
}

# Data sources for Authentik flows
data "authentik_flow" "default_authorization" {
  slug = var.authentik_default_authorization_flow_slug
}

data "authentik_flow" "default_invalidation" {
  slug = var.authentik_default_invalidation_flow_slug
}

# Locals to extract specific secrets
locals {
  authentik_secrets = data.infisical_secrets.authentik.secrets
  authentik_token   = try(
    local.authentik_secrets["AUTHENTIK_TOKEN"].value,
    null
  )
}