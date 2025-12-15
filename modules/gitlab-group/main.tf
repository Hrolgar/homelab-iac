terraform {
  required_providers {
    gitlab = {
      source = "opentofu/gitlab"
    }
  }
}

resource "gitlab_group" "this" {
  name        = var.group_name
  path        = var.path
  description = var.description
  parent_id   = var.parent_id

  visibility_level           = var.visibility_level
  project_creation_level     = var.project_creation_level
  subgroup_creation_level    = var.subgroup_creation_level
  require_two_factor_authentication = var.require_two_factor_authentication
  auto_devops_enabled        = var.auto_devops_enabled
  request_access_enabled     = var.request_access_enabled
}

resource "gitlab_group_variable" "this" {
  for_each = var.ci_variables

  group             = gitlab_group.this.id
  key               = each.key
  value             = each.value.value
  protected         = try(each.value.protected, false)
  masked            = try(each.value.masked, false)
  raw               = try(each.value.raw, false)
  variable_type     = try(each.value.variable_type, "env_var")
  environment_scope = try(each.value.environment_scope, "*")
  description       = try(each.value.description, null)
}