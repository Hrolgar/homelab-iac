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
  }
}

provider "infisical" {
  host = "http://10.69.1.4:81"
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

provider "b2" {
  application_key_id = data.infisical_secrets.b2.secrets["b2_application_key_id"].value
  application_key    = data.infisical_secrets.b2.secrets["b2_application_key"].value
}