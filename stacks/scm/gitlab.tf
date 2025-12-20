# locals {
#   infisical_sources = {
#     gitlab     = data.infisical_secrets.gitlab.secrets
#     proxmox    = data.infisical_secrets.proxmox.secrets
#     b2         = data.infisical_secrets.b2.secrets
#     cloudflare = data.infisical_secrets.cloudflare.secrets
#   }
# }
locals {
  infisical_sources = {
    for path, ds in data.infisical_secrets.folders :
    path => ds.secrets
  }
}


resource "gitlab_group_variable" "secrets" {
  for_each = var.gitlab_group_secrets

  group = module.gitlab_groups[each.value.group].group_id
  key   = each.key

  value = (
    each.value.content_lines != null
    ? join("\n", [
      for line in each.value.content_lines :
      "${line.key}=${line.value != null ? line.value : local.infisical_sources[line.infisical_path][line.infisical_key].value}"
    ])
    : each.value.value != null
    ? each.value.value
    : local.infisical_sources[each.value.infisical_path][each.value.infisical_key].value
  )

  variable_type     = each.value.variable_type
  protected         = each.value.protected
  masked            = each.value.masked
  environment_scope = each.value.environment_scope
  description       = each.value.description
}


resource "gitlab_project_variable" "secrets" {
  for_each = var.gitlab_project_secrets

  project = module.gitlab_projects[each.value.project].project_id
  key     = each.key

  value = (
    each.value.content_lines != null
    ? join("\n", [
      for line in each.value.content_lines :
      "${line.key}=${line.value != null ? line.value : local.infisical_sources[line.infisical_path][line.infisical_key].value}"
    ])
    : each.value.value != null
    ? each.value.value
    : local.infisical_sources[each.value.infisical_path][each.value.infisical_key].value
  )

  variable_type     = each.value.variable_type
  protected         = each.value.protected
  masked            = each.value.masked
  environment_scope = each.value.environment_scope
  description       = each.value.description
}

module "gitlab_groups" {
  source   = "../../modules/gitlab-group"
  for_each = var.gitlab_groups

  group_name  = coalesce(each.value.name, each.key)
  path        = coalesce(each.value.path, each.key)
  description = each.value.description
  parent_id   = each.value.parent_id

  visibility_level                  = each.value.visibility_level
  project_creation_level            = each.value.project_creation_level
  subgroup_creation_level           = each.value.subgroup_creation_level
  require_two_factor_authentication = each.value.require_two_factor_authentication
  auto_devops_enabled               = each.value.auto_devops_enabled
  request_access_enabled            = each.value.request_access_enabled

  ci_variables = each.value.ci_variables
}

module "gitlab_projects" {
  source   = "../../modules/gitlab-project"
  for_each = var.gitlab_projects

  project_name = coalesce(each.value.name, each.key)
  description  = each.value.description
  path         = each.value.path

  namespace_id = (
    each.value.group_ref != null
    ? module.gitlab_groups[each.value.group_ref].group_id
    : each.value.namespace_id
  )

  visibility_level = each.value.visibility_level
  default_branch   = each.value.default_branch

  issues_enabled             = each.value.issues_enabled
  merge_requests_enabled     = each.value.merge_requests_enabled
  wiki_enabled               = each.value.wiki_enabled
  snippets_enabled           = each.value.snippets_enabled
  container_registry_access_level = each.value.container_registry_access_level

  merge_method                                     = each.value.merge_method
  squash_option                                    = each.value.squash_option
  only_allow_merge_if_pipeline_succeeds            = each.value.only_allow_merge_if_pipeline_succeeds
  only_allow_merge_if_all_discussions_are_resolved = each.value.only_allow_merge_if_all_discussions_are_resolved
  remove_source_branch_after_merge                 = each.value.remove_source_branch_after_merge

  initialize_with_readme = each.value.initialize_with_readme
  archived               = each.value.archived
  topics                 = each.value.topics
  shared_runners_enabled = each.value.shared_runners_enabled

  ci_variables = each.value.ci_variables

  protect_default_branch = each.value.protect_default_branch
  push_access_level      = each.value.push_access_level
  merge_access_level     = each.value.merge_access_level
  allow_force_push       = each.value.allow_force_push

  depends_on = [module.gitlab_groups]
}



