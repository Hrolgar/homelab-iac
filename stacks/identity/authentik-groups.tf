# Authentik Groups
module "authentik_groups" {
  source   = "../../modules/authentik/group"
  for_each = var.authentik_groups

  name            = each.value.name
  is_superuser    = try(each.value.is_superuser, false)
  parent_group_id = try(each.value.parent_group_id, null)
  # Merge direct user_ids and referenced user_keys
  user_ids        = concat(
    try(each.value.user_ids, []),
    try(each.value.user_keys != null ? [for k in each.value.user_keys : tonumber(module.authentik_users[k].id)] : [], [])
  )
  role_ids        = try(each.value.role_keys != null ? [for k in each.value.role_keys : module.authentik_roles[k].id] : [], [])
}
