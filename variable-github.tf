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
    protect_default_branch        = optional(bool, false)
    required_reviews              = optional(number, 0)
    require_code_owner_reviews    = optional(bool, false)
    dismiss_stale_reviews         = optional(bool, true)
    require_signed_commits        = optional(bool, false)
    enforce_admins                = optional(bool, false)
  }))
  default = {}
}