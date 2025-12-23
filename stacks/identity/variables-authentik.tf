variable "authentik_url" {
  description = "URL for the Authentik instance"
  type        = string
}

# variable "authentik_token" {
#   description = "API token for Authentik"
#   type        = string
#   sensitive   = true
# }

variable "authentik_default_authorization_flow_slug" {
  description = "Default authorization flow slug for Authentik proxy providers"
  type        = string
  default     = "default-provider-authorization-implicit-consent"
}

variable "authentik_default_invalidation_flow_slug" {
  description = "Default invalidation flow slug for Authentik proxy providers"
  type        = string
  default     = "default-provider-invalidation-flow"
}

variable "authentik_default_outpost_name" {
  description = "Name of the default outpost to use for proxy providers"
  type        = string
  default     = "authentik Embedded Outpost"
}

variable "authentik_proxies" {
  description = "Map of Authentik proxy providers to create"
  type = map(object({
    name              = string
    external_host     = string
    internal_host     = string
    application_group = optional(string, "internal")
    mode              = optional(string, "forward_single")
    outpost_name      = optional(string, null) # Use outpost name instead of ID
  }))
  default = {}
}

variable "authentik_outposts" {
  description = "Map of Authentik outposts to create"
  type = map(object({
    name               = string
    type               = string # "proxy" or "ldap"
    service_connection = optional(string, null)
    insecure           = optional(bool, false)
    log_level          = optional(string, "info")
  }))
  default = {}
}

variable "authentik_outposts_existing" {
  description = "Map of existing outpost names to use (data source)"
  type        = map(string)
  default     = {}
}

variable "authentik_roles" {
  description = "Map of Authentik RBAC roles to create"
  type = map(object({
    name = string
  }))
  default = {}
}

variable "authentik_groups" {
  description = "Map of Authentik groups to create"
  type = map(object({
    name            = string
    is_superuser    = optional(bool, false)
    parent_group_id = optional(string, null)
    user_ids        = optional(list(number), [])        # Direct user IDs (not recommended)
    user_keys       = optional(list(string), [])        # References keys from authentik_users (recommended)
    role_keys       = optional(list(string), [])        # References keys from authentik_roles
  }))
  default = {}
}

variable "authentik_users" {
  description = "Map of Authentik users to create"
  type = map(object({
    username            = string
    name                = optional(string, null)
    email               = optional(string, null)
    password            = optional(string, null)        # Direct password (not recommended)
    password_secret_key = optional(string, null)        # Key in Infisical secrets (recommended)
    is_active           = optional(bool, true)
    type                = optional(string, "internal")  # internal, external, service_account, internal_service_account
    path                = optional(string, "users")
    group_keys          = optional(list(string), [])    # References keys from authentik_groups
    attributes          = optional(map(any), null)
  }))
  default = {}
  # Note: Cannot mark as sensitive when used in for_each
  # The password field itself is marked sensitive in the module
}

variable "authentik_policy_bindings" {
  description = "Map of Authentik policy bindings to create"
  type = map(object({
    target_type = string                      # "application" or raw UUID
    target_key  = optional(string, null)      # Key from authentik_proxies (if target_type is "application")
    target_id   = optional(string, null)      # Raw UUID (if not using target_key)
    group_key   = optional(string, null)      # Key from authentik_groups
    group_id    = optional(string, null)      # Raw group UUID (if not using group_key)
    user_id     = optional(string, null)      # User ID for user-specific bindings
    order       = optional(number, 0)
    enabled     = optional(bool, true)
    timeout     = optional(number, 30)
  }))
  default = {}
}