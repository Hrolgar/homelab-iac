terraform {
  required_providers {
    gitlab = {
      source = "opentofu/gitlab"
    }
  }
}

resource "gitlab_project" "this" {
  name         = var.project_name
  description  = var.description
  namespace_id = var.namespace_id
  path         = var.path

  visibility_level = var.visibility_level
  default_branch   = var.default_branch

  issues_enabled           = var.issues_enabled
  merge_requests_enabled   = var.merge_requests_enabled
  wiki_enabled             = var.wiki_enabled
  snippets_enabled         = var.snippets_enabled
  container_registry_access_level = var.container_registry_access_level
  
  merge_method                                     = var.merge_method
  squash_option                                    = var.squash_option
  only_allow_merge_if_pipeline_succeeds            = var.only_allow_merge_if_pipeline_succeeds
  only_allow_merge_if_all_discussions_are_resolved = var.only_allow_merge_if_all_discussions_are_resolved
  remove_source_branch_after_merge                 = var.remove_source_branch_after_merge

  initialize_with_readme = var.initialize_with_readme
  archived               = var.archived
  topics                 = var.topics

  shared_runners_enabled = var.shared_runners_enabled

  lifecycle {
    ignore_changes = [initialize_with_readme]
  }
}

resource "gitlab_project_variable" "this" {
  for_each = var.ci_variables

  project           = gitlab_project.this.id
  key               = each.key
  value             = each.value.value
  protected         = try(each.value.protected, false)
  masked            = try(each.value.masked, false)
  raw               = try(each.value.raw, false)
  variable_type     = try(each.value.variable_type, "env_var")
  environment_scope = try(each.value.environment_scope, "*")
  description       = try(each.value.description, null)
}

resource "gitlab_branch_protection" "this" {
  count = var.protect_default_branch ? 1 : 0

  project                      = gitlab_project.this.id
  branch                       = var.default_branch
  push_access_level            = var.push_access_level
  merge_access_level           = var.merge_access_level
  allow_force_push             = var.allow_force_push
}