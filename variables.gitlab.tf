variable "gitlab_host" {
  description = "GitLab instance URL"
  type        = string
}

variable "gitlab_groups" {
  type = map(object({
    name        = optional(string)
    path        = optional(string)
    description = optional(string, "")
    parent_id   = optional(number, null)

    visibility_level                  = optional(string, "private")
    project_creation_level            = optional(string, "maintainer")
    subgroup_creation_level           = optional(string, "owner")
    require_two_factor_authentication = optional(bool, false)
    auto_devops_enabled               = optional(bool, false)
    request_access_enabled            = optional(bool, true)

    ci_variables = optional(map(object({
      value             = string
      protected         = optional(bool, false)
      masked            = optional(bool, false)
      raw               = optional(bool, false)
      variable_type     = optional(string, "env_var")
      environment_scope = optional(string, "*")
      description       = optional(string, null)
    })), {})
  }))
  default = {}
}

variable "gitlab_projects" {
  type = map(object({
    name         = optional(string)
    description  = optional(string, "")
    path         = optional(string, null)
    namespace_id = optional(number, null)
    group_ref    = optional(string, null)

    visibility_level = optional(string, "public")
    default_branch   = optional(string, "main")

    issues_enabled             = optional(bool, true)
    merge_requests_enabled     = optional(bool, true)
    wiki_enabled               = optional(bool, false)
    snippets_enabled           = optional(bool, false)
    container_registry_access_level = optional(string, "enabled")

    merge_method                                     = optional(string, "merge")
    squash_option                                    = optional(string, "default_off")
    only_allow_merge_if_pipeline_succeeds            = optional(bool, false)
    only_allow_merge_if_all_discussions_are_resolved = optional(bool, false)
    remove_source_branch_after_merge                 = optional(bool, true)

    initialize_with_readme = optional(bool, false)
    archived               = optional(bool, false)
    topics                 = optional(list(string), [])
    shared_runners_enabled = optional(bool, true)

    ci_variables = optional(map(object({
      value             = string
      protected         = optional(bool, false)
      masked            = optional(bool, false)
      raw               = optional(bool, false)
      variable_type     = optional(string, "env_var")
      environment_scope = optional(string, "*")
      description       = optional(string, null)
    })), {})

    protect_default_branch = optional(bool, false)
    push_access_level      = optional(string, "maintainer")
    merge_access_level     = optional(string, "maintainer")
    allow_force_push       = optional(bool, false)
  }))
  default = {}
}

variable "gitlab_group_secrets" {
  description = "Map of group secrets to pull from Infisical"
  type = map(map(object({
    infisical_path   = string
    infisical_key    = string
    protected        = optional(bool, true)
    masked           = optional(bool, false)
    variable_type    = optional(string, "env_var")
    environment_scope = optional(string, "*")
  })))
  default = {}
}

variable "gitlab_project_secrets" {
  description = "Map of project secrets to pull from Infisical"
  type = map(map(object({
    infisical_path    = string
    infisical_key     = string
    protected         = optional(bool, true)
    masked            = optional(bool, false)
    variable_type     = optional(string, "env_var")
    environment_scope = optional(string, "*")
  })))
  default = {}
}