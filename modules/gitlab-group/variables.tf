variable "group_name" {
  description = "The name of the group"
  type        = string
}

variable "path" {
  description = "The path of the group (URL path)"
  type        = string
}

variable "description" {
  description = "The description of the group"
  type        = string
  default     = ""
}

variable "parent_id" {
  description = "ID of the parent group (for subgroups)"
  type        = number
  default     = null
}

variable "visibility_level" {
  description = "Visibility level (private, internal, public)"
  type        = string
  default     = "public"
}

variable "project_creation_level" {
  description = "Who can create projects (noone, maintainer, developer)"
  type        = string
  default     = "maintainer"
}

variable "subgroup_creation_level" {
  description = "Who can create subgroups (owner, maintainer)"
  type        = string
  default     = "owner"
}

variable "require_two_factor_authentication" {
  description = "Require 2FA for group members"
  type        = bool
  default     = false
}

variable "auto_devops_enabled" {
  description = "Enable Auto DevOps"
  type        = bool
  default     = false
}

variable "request_access_enabled" {
  description = "Allow users to request access"
  type        = bool
  default     = true
}

variable "ci_variables" {
  description = "Map of CI/CD variables for the group"
  type = map(object({
    value             = string
    protected         = optional(bool, false)
    masked            = optional(bool, false)
    raw               = optional(bool, false)
    variable_type     = optional(string, "env_var")
    environment_scope = optional(string, "*")
    description       = optional(string, null)
  }))
  default = {}
}