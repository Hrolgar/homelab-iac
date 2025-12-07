// Variables for Infisical integration
variable "infisical_host" {
  description = "Infisical host URL"
  type        = string
  default     = "http://10.69.1.4:81"
}

variable "infisical_client_id" {
  description = "Infisical client ID for authentication"
  type        = string
  sensitive   = true
}
variable "infisical_client_secret" {
  description = "Infisical client secret for authentication"
  type        = string
  sensitive   = true
}

variable "infisical_project_id" {
  description = "Infisical project ID"
  type        = string
  sensitive   = true
}

variable "infisical_secrets" {
  description = "Map of secret groups to create in Infisical"
  type = map(object({
    env_slug    = string
    folder_path = string
    secrets     = map(string)
  }))
  default = {}
}

// Variables for Cloudflare management

variable "cloudflare_domains" {
  description = "List of Cloudflare domains to manage"
  type        = list(string)
  default     = []
}

variable "tunnels" {
  description = "Map of Cloudflare tunnels and their routes"
  type = map(object({
    routes = map(object({
      domain        = string
      service       = string
      no_tls_verify = optional(bool, false)
      http2_origin  = optional(bool, false)
    }))
  }))
  default = {}
}


// New variable for Cloudflare Access applications

variable "access_apps" {
  description = "Map of Cloudflare Access applications for Zero Trust protection"
  type = map(object({
    domain            = string
    subdomain         = string
    session_duration  = optional(string, "24h")
    auto_redirect     = optional(bool, true)
    skip_interstitial = optional(bool, true)
  }))
  default = {}
}

