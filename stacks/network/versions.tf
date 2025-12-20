terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
    infisical = {
      source  = "infisical/infisical"
      version = "~> 0.15.52"
    }
  }
}
