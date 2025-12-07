terraform {
  required_version = ">= 1.6.0"
  required_providers {
    b2 = {
        source  = "Backblaze/b2"
        version = "~> 0.11"
    }
    infisical = {
      source  = "infisical/infisical"
      version = "~> 0.15.52"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "infisical" {
  host = var.infisical_host
  auth = {
    universal = {
      client_id     = var.infisical_client_id
      client_secret = var.infisical_client_secret
    }
  }
}


# Fetch secrets from Infisical
data "infisical_secrets" "b2" {
  env_slug     = "dev"
  workspace_id = var.infisical_project_id
  folder_path  = "/b2"
}

data "infisical_secrets" "cloudflare" {
  env_slug     = "dev"
  workspace_id = var.infisical_project_id
  folder_path  = "/cloudflare"
}

data "infisical_secrets" "cloudflare_tunnels" {
  env_slug     = "dev"
  workspace_id = var.infisical_project_id
  folder_path  = "/cloudflare/tunnels"
}

data "infisical_secrets" "github" {
  env_slug     = "dev"
  workspace_id = var.infisical_project_id
  folder_path  = "/github"
}

# Configure Providers with secrets from Infisical

provider "b2" {
  application_key_id = data.infisical_secrets.b2.secrets["b2_application_key_id"].value
  application_key    = data.infisical_secrets.b2.secrets["b2_application_key"].value
}


provider "cloudflare" {
  api_token = data.infisical_secrets.cloudflare.secrets["api_token"].value
}

provider "github" {
  token = data.infisical_secrets.github.secrets["token"].value
  owner = var.github_owner
}