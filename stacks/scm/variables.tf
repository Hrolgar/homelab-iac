/// INFISCAL VARIABLES ///

variable "infisical_host" {
  type = string
}

variable "infisical_project_id" {
  type = string
}

variable "infisical_client_id" {
  type      = string
  sensitive = true
}

variable "infisical_client_secret" {
  type      = string
  sensitive = true
}

variable "infisical_folders" {
  type = set(string)
}


// GITLAB VARIABLES //
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

    issues_enabled                  = optional(bool, true)
    merge_requests_enabled          = optional(bool, true)
    wiki_enabled                    = optional(bool, false)
    snippets_enabled                = optional(bool, false)
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
  type = map(object({
    group            = string
    infisical_path   = optional(string)
    infisical_key    = optional(string)

    value            = optional(string)
    content_lines    = optional(list(object({
      key            = string
      value          = optional(string)
      infisical_path = optional(string)
      infisical_key  = optional(string)
    })))
    variable_type     = optional(string, "env_var")
    protected         = optional(bool, true)
    masked            = optional(bool, false)
    environment_scope = optional(string, "*")
    description       = optional(string, null)
  }))
  default = {}
}

variable "gitlab_project_secrets" {
  type = map(object({
    project          = string
    infisical_path   = optional(string)
    infisical_key    = optional(string)

    value            = optional(string)
    content_lines    = optional(list(object({
      key            = string
      value          = optional(string)
      infisical_path = optional(string)
      infisical_key  = optional(string)
    })))
    variable_type     = optional(string, "env_var")
    protected         = optional(bool, true)
    masked            = optional(bool, false)
    environment_scope = optional(string, "*")
    description       = optional(string, null)
  }))
  default = {}
}


// GITHUB VARIABLES //
variable "github_owner" {
  description = "GitHub username or organization"
  type        = string
}


variable "github_repos" {
  description = "Map of GitHub repositories to manage"
  type = map(object({
    description            = optional(string, "")
    visibility             = optional(string, "private")
    default_branch         = optional(string, "main")
    has_issues             = optional(bool, true)
    has_wiki               = optional(bool, false)
    has_projects           = optional(bool, false)
    has_discussions        = optional(bool, false)
    allow_merge_commit     = optional(bool, true)
    allow_squash_merge     = optional(bool, true)
    allow_rebase_merge     = optional(bool, true)
    delete_branch_on_merge = optional(bool, true)
    auto_init              = optional(bool, false)
    gitignore_template     = optional(string, null)
    license_template       = optional(string, null)
    archived               = optional(bool, false)
    topics                 = optional(list(string), [])

    # Collaborators
    collaborators = optional(map(string), {})

    # Repository secrets
    secrets = optional(map(string), {})

    # Branch protection
    protect_default_branch     = optional(bool, false)
    required_reviews           = optional(number, 0)
    require_code_owner_reviews = optional(bool, false)
    dismiss_stale_reviews      = optional(bool, true)
    require_signed_commits     = optional(bool, false)
    enforce_admins             = optional(bool, false)
  }))
  default = {}
}
