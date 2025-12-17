variable "cloudflare_account_id" {
  type      = string
  sensitive = true
}

variable "cloudflare_github_idp_id" {
  type      = string
  sensitive = true
}

variable "infisical_project_id" {
  type = string
}

variable "cloudflare_domains" {
  type = set(string)
}

variable "tunnels" {
  type = map(any)
}

variable "access_apps" {
  type = map(any)
}
