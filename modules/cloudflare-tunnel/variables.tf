variable "account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "tunnel_id" {
  description = "Cloudflare tunnel ID"
  type        = string
}

variable "tunnel_name" {
  description = "Name of the tunnel (for comments/documentation)"
  type        = string
}

variable "zone_ids" {
  description = "Map of domain names to zone IDs"
  type        = map(string)
}

variable "routes" {
  description = "Map of routes for this tunnel"
  type = map(object({
    domain         = string
    service        = string
    origin_request = optional(object({
      no_tls_verify = optional(bool, false)
      http2_origin  = optional(bool, false)
    }), {})
  }))
}

variable "catch_all_service" {
  description = "Service for catch-all rule (unmatched requests)"
  type        = string
  default     = "http_status:404"
}
