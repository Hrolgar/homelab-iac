variable "account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "tunnel_name" {
  description = "Name for the tunnel"
  type        = string
}

variable "zone_ids" {
  description = "Map of domain names to zone IDs"
  type        = map(string)
}

variable "routes" {
  description = "Map of routes for this tunnel"
  type = map(object({
    domain        = string
    service       = string
    no_tls_verify = optional(bool, false)
    http2_origin  = optional(bool, false)
  }))
}

variable "catch_all_service" {
  description = "Service for catch-all rule (unmatched requests)"
  type        = string
  default     = "http_status:404"
}

# Infisical integration
variable "store_in_infisical" {
  description = "Whether to store tunnel_id and token in Infisical"
  type        = bool
  default     = true
}

variable "infisical_folder_path" {
  description = "Infisical folder path for storing secrets"
  type        = string
  default     = "/cloudflare/tunnels"
}

variable "infisical_env_slug" {
  description = "Infisical environment slug"
  type        = string
  default     = "dev"
}

variable "infisical_workspace_id" {
  description = "Infisical workspace/project ID"
  type        = string
  default     = ""
}
