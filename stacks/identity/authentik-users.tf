# Authentik users (passwords injected from Infisical via locals)
# Note: Groups are managed FROM the group side using user_keys to avoid circular dependencies
module "authentik_users" {
  source   = "../../modules/authentik/user"
  for_each = local.users_with_passwords

  username   = each.value.username
  name       = try(each.value.name, each.value.username)
  email      = try(each.value.email, null)
  password   = try(each.value.password, null)
  is_active  = try(each.value.is_active, true)
  type       = try(each.value.type, "internal")
  path       = try(each.value.path, "users")
  group_ids  = []  # Groups managed from group side - lifecycle ignore_changes handles this
  attributes = try(each.value.attributes, null)
}
