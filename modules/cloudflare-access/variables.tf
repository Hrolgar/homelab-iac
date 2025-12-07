variable "account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "domain" {
  description = "Domain name (e.g., hrolgar.com)"
  type        = string
}

variable "subdomain" {
  description = "Subdomain for the application (e.g., px1)"
  type        = string
}

variable "app_name" {
  description = "Display name for the Access application"
  type        = string
}

variable "github_idp_id" {
  description = "GitHub Identity Provider ID from Cloudflare"
  type        = string
}

variable "session_duration" {
  description = "Session duration (e.g., 24h, 168h)"
  type        = string
  default     = "24h"
}

variable "auto_redirect_to_identity" {
  description = "Auto-redirect to GitHub login instead of showing provider selection"
  type        = bool
  default     = true
}

variable "skip_interstitial" {
  description = "Skip the Cloudflare Access interstitial page"
  type        = bool
  default     = true
}
