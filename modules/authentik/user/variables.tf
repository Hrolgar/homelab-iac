variable "username" {
  description = "Username for the user (required, unique)"
  type        = string
}

variable "name" {
  description = "Full name of the user"
  type        = string
  default     = ""
}

variable "email" {
  description = "Email address of the user"
  type        = string
  default     = null
}

variable "password" {
  description = "Password for the user (optional, sensitive)"
  type        = string
  default     = null
  sensitive   = true
}

variable "is_active" {
  description = "Whether the user account is active"
  type        = bool
  default     = true
}

variable "type" {
  description = "User type: internal, external, service_account, or internal_service_account"
  type        = string
  default     = "internal"

  validation {
    condition     = contains(["internal", "external", "service_account", "internal_service_account"], var.type)
    error_message = "Type must be one of: internal, external, service_account, internal_service_account"
  }
}

variable "path" {
  description = "Path for organizing users"
  type        = string
  default     = "users"
}

variable "group_ids" {
  description = "List of group UUIDs to add the user to"
  type        = list(string)
  default     = []
}

variable "attributes" {
  description = "Custom attributes for the user (will be JSON encoded)"
  type        = map(any)
  default     = null
}
