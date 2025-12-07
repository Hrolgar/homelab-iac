module "github_repos" {
  source   = "./modules/github-repo"
  for_each = var.github_repos

  repo_name   = each.key
  description = each.value.description
  visibility  = each.value.visibility

  default_branch  = each.value.default_branch
  has_issues      = each.value.has_issues
  has_wiki        = each.value.has_wiki
  has_projects    = each.value.has_projects
  has_discussions = each.value.has_discussions

  collaborators = each.value.collaborators
  secrets = each.value.secrets

  allow_merge_commit     = each.value.allow_merge_commit
  allow_squash_merge     = each.value.allow_squash_merge
  allow_rebase_merge     = each.value.allow_rebase_merge
  delete_branch_on_merge = each.value.delete_branch_on_merge

  auto_init          = each.value.auto_init
  gitignore_template = each.value.gitignore_template
  license_template   = each.value.license_template

  archived = each.value.archived
  topics   = each.value.topics

  protect_default_branch     = each.value.protect_default_branch
  required_reviews           = each.value.required_reviews
  require_code_owner_reviews = each.value.require_code_owner_reviews
  dismiss_stale_reviews      = each.value.dismiss_stale_reviews
  require_signed_commits     = each.value.require_signed_commits
  enforce_admins             = each.value.enforce_admins
}