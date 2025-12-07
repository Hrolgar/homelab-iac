
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

variable "access_apps" {
  description = "Map of Cloudflare Access applications for Zero Trust protection"
  type = map(object({
    domain            = string
    subdomain         = string
    allowed_email     = string
    session_duration  = optional(string, "24h")
    auto_redirect     = optional(bool, true)
    skip_interstitial = optional(bool, true)
  }))
  default = {}
}
