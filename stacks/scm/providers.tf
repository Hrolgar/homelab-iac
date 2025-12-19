provider "infisical" {
  host = var.infisical_host
  auth = {
    universal = {
      client_id     = var.infisical_client_id
      client_secret = var.infisical_client_secret
    }
  }
}

provider "github" {
  token = data.infisical_secrets.folders["github"].secrets["token"].value
  owner = var.github_owner
}

provider "gitlab" {
  token    = data.infisical_secrets.folders["gitlab"].secrets["token"].value
  base_url = var.gitlab_host
}
