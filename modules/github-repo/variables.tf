variable "repo_name" {
  description = "Repository name"
  type        = string
}

variable "description" {
  description = "Repository description"
  type        = string
  default     = ""
}

variable "visibility" {
  description = "Repository visibility (public, private)"
  type        = string
  default     = "private"
}

variable "default_branch" {
  description = "Default branch name"
  type        = string
  default     = "main"
}

variable "has_issues" {
  description = "Enable issues"
  type        = bool
  default     = true
}

variable "has_wiki" {
  description = "Enable wiki"
  type        = bool
  default     = false
}

variable "has_projects" {
  description = "Enable projects"
  type        = bool
  default     = false
}

variable "has_discussions" {
  description = "Enable discussions"
  type        = bool
  default     = false
}

variable "allow_merge_commit" {
  description = "Allow merge commits"
  type        = bool
  default     = true
}

variable "allow_squash_merge" {
  description = "Allow squash merging"
  type        = bool
  default     = true
}

variable "allow_rebase_merge" {
  description = "Allow rebase merging"
  type        = bool
  default     = true
}

variable "delete_branch_on_merge" {
  description = "Delete branch after merge"
  type        = bool
  default     = true
}

variable "auto_init" {
  description = "Initialize with README (only for new repos)"
  type        = bool
  default     = false
}

variable "gitignore_template" {
  description = "Gitignore template (only for new repos)"
  type        = string
  default     = null
}

variable "license_template" {
  description = "License template (only for new repos)"
  type        = string
  default     = null
}

variable "archived" {
  description = "Archive the repository"
  type        = bool
  default     = false
}

variable "topics" {
  description = "Repository topics"
  type        = list(string)
  default     = []
}

# Branch protection
variable "protect_default_branch" {
  description = "Enable branch protection on default branch"
  type        = bool
  default     = false
}

variable "required_reviews" {
  description = "Number of required reviews (0 to disable)"
  type        = number
  default     = 0
}

variable "require_code_owner_reviews" {
  description = "Require code owner reviews"
  type        = bool
  default     = false
}

variable "dismiss_stale_reviews" {
  description = "Dismiss stale reviews on new commits"
  type        = bool
  default     = true
}

variable "require_signed_commits" {
  description = "Require signed commits"
  type        = bool
  default     = false
}

variable "enforce_admins" {
  description = "Enforce rules for admins too"
  type        = bool
  default     = false
}

variable "collaborators" {
  description = "Map of collaborators and their permission level"
  type        = map(string)  # username => permission (pull, push, admin, maintain, triage)
  default     = {}
}

variable "secrets" {
  description = "GitHub Actions secrets to create"
  type        = map(string)
  default     = {}
}