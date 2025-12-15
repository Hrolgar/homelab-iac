variable "project_name" {
  type = string
}

variable "description" {
  type    = string
  default = ""
}

variable "namespace_id" {
  type = number
}

variable "path" {
  type    = string
  default = null
}

variable "visibility_level" {
  type    = string
  default = "private"
}

variable "default_branch" {
  type    = string
  default = "main"
}

variable "issues_enabled" {
  type    = bool
  default = true
}

variable "merge_requests_enabled" {
  type    = bool
  default = true
}

variable "wiki_enabled" {
  type    = bool
  default = false
}

variable "snippets_enabled" {
  type    = bool
  default = false
}

variable "container_registry_access_level" {
  description = "Container registry access level (disabled, private, enabled)"
  type        = string
  default     = "enabled"
}

variable "merge_method" {
  type    = string
  default = "merge"
}

variable "squash_option" {
  type    = string
  default = "default_off"
}

variable "only_allow_merge_if_pipeline_succeeds" {
  type    = bool
  default = false
}

variable "only_allow_merge_if_all_discussions_are_resolved" {
  type    = bool
  default = false
}

variable "remove_source_branch_after_merge" {
  type    = bool
  default = true
}

variable "initialize_with_readme" {
  type    = bool
  default = false
}

variable "archived" {
  type    = bool
  default = false
}

variable "topics" {
  type    = list(string)
  default = []
}

variable "shared_runners_enabled" {
  type    = bool
  default = true
}

variable "ci_variables" {
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

variable "protect_default_branch" {
  type    = bool
  default = false
}

variable "push_access_level" {
  type    = string
  default = "maintainer"
}

variable "merge_access_level" {
  type    = string
  default = "maintainer"
}

variable "allow_force_push" {
  type    = bool
  default = false
}