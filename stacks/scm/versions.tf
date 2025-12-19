terraform {
  backend "local" {
    path = "terraform.tfstate"
  }  
  required_version = ">= 1.6.0"   
  required_providers {
    infisical = {
      source  = "infisical/infisical"
      version = "~> 0.15.52"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    gitlab = {
      source  = "opentofu/gitlab"
      version = "~> 17.2"
    }
  }
}
