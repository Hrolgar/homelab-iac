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
    gitlab = {
      source  = "opentofu/gitlab"
      version = "~> 17.2"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.89"
    }
  }
}

module "foundation" {
  source = "./stacks/foundation"

  infisical_secrets     = var.infisical_secrets
  infisical_project_id = var.infisical_project_id
  proxmox_pools        = var.proxmox_pools
  buckets               = var.buckets
}

module "compute" {
  source = "./stacks/compute"

  proxmox_node        = var.proxmox_node
  proxmox_template    = var.proxmox_template
  proxmox_ci_user     = var.proxmox_ci_user
  proxmox_ci_password = module.foundation.proxmox_ci_password
  proxmox_ci_ssh_keys = module.foundation.proxmox_ci_ssh_keys
  vms                 = var.vms
}

module "network" {
  source = "./stacks/network"

  cloudflare_domains        = var.cloudflare_domains
  tunnels                   = var.tunnels
  access_apps               = var.access_apps
  cloudflare_account_id     = data.infisical_secrets.cloudflare.secrets["account_id"].value
  cloudflare_github_idp_id  = module.foundation.cloudflare_github_idp_id
  infisical_project_id      = var.infisical_project_id
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

data "infisical_secrets" "proxmox" {
  env_slug     = "dev"
  workspace_id = var.infisical_project_id
  folder_path  = "/proxmox"
}

data "infisical_secrets" "gitlab" {
  env_slug     = "dev"
  workspace_id = var.infisical_project_id
  folder_path  = "/gitlab"
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

provider "gitlab" {
  token = data.infisical_secrets.gitlab.secrets["token"].value
  base_url = var.gitlab_host
}

provider "proxmox" {
  endpoint  = var.proxmox_host
  api_token = "${data.infisical_secrets.proxmox.secrets["api_token_id"].value}=${data.infisical_secrets.proxmox.secrets["api_token_secret"].value}"
  insecure  = true
}