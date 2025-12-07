terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}

resource "github_repository" "this" {
  name        = var.repo_name
  description = var.description
  visibility  = var.visibility

  has_issues      = var.has_issues
  has_wiki        = var.has_wiki
  has_projects    = var.has_projects
  has_discussions = var.has_discussions

  allow_merge_commit     = var.allow_merge_commit
  allow_squash_merge     = var.allow_squash_merge
  allow_rebase_merge     = var.allow_rebase_merge
  delete_branch_on_merge = var.delete_branch_on_merge

  auto_init          = var.auto_init
  gitignore_template = var.gitignore_template
  license_template   = var.license_template

  archived = var.archived
  topics   = var.topics

  lifecycle {
    ignore_changes = [
      auto_init,
      gitignore_template,
      license_template,
    ]
  }
}

resource "github_branch_default" "this" {
  repository = github_repository.this.name
  branch     = var.default_branch
}

resource "github_branch_protection" "this" {
  count = var.protect_default_branch ? 1 : 0

  repository_id = github_repository.this.node_id
  pattern       = var.default_branch

  enforce_admins         = var.enforce_admins
  require_signed_commits = var.require_signed_commits

  dynamic "required_pull_request_reviews" {
    for_each = var.required_reviews > 0 ? [1] : []
    content {
      required_approving_review_count = var.required_reviews
      dismiss_stale_reviews           = var.dismiss_stale_reviews
      require_code_owner_reviews      = var.require_code_owner_reviews
    }
  }
}

resource "github_repository_collaborator" "this" {
  for_each = var.collaborators

  repository = github_repository.this.name
  username   = each.key
  permission = each.value
}

resource "github_actions_secret" "this" {
  for_each = var.secrets

  repository      = github_repository.this.name
  secret_name     = each.key
  plaintext_value = sensitive(var.secrets[each.key])
  }