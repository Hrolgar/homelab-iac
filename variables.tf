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

variable "cloudflare_domains" {
  description = "List of Cloudflare domains to manage"
  type        = list(string)
  default     = ["ullrmedia.com", "hrolgar.com"]
}

variable "tunnels" {
  description = "Map of Cloudflare tunnels and their routes"
  type = map(object({
    routes = map(object({
      domain         = string
      service        = string
      origin_request = optional(object({
        no_tls_verify = optional(bool, false)
        http2_origin  = optional(bool, false)
      }), {})
    }))
  }))
  default = {}
}
