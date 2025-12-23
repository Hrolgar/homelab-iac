variable "proxy_name" {
  description = "Name of the proxy provider and application"
  type        = string
}

variable "external_host" {
  description = "External host URL (e.g., https://app.example.com)"
  type        = string
}

variable "internal_host" {
  description = "Internal host URL (e.g., http://internal-service:8080)"
  type        = string
}

variable "application_group" {
  description = "Application group name in Authentik"
  type        = string
  default     = "internal"
}

variable "authorization_flow" {
  description = "Authorization flow UUID or slug"
  type        = string
}

variable "invalidation_flow" {
  description = "Invalidation flow UUID or slug"
  type        = string
}

variable "mode" {
  description = "Proxy mode: forward_single, forward_domain, or proxy"
  type        = string
  default     = "forward_single"
}

variable "outpost_id" {
  description = "ID of the outpost to attach this provider to (optional)"
  type        = string
  default     = null
}