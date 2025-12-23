# Policy bindings for applications
module "authentik_policy_bindings" {
  source   = "../../modules/authentik/policy"
  for_each = var.authentik_policy_bindings

  target_id = each.value.target_type == "application" ? module.authentik_proxies[each.value.target_key].application_uuid : each.value.target_id
  group_id  = try(each.value.group_key != null ? module.authentik_groups[each.value.group_key].id : null, null)
  user_id   = try(each.value.user_id, null)
  order     = try(each.value.order, 0)
  enabled   = try(each.value.enabled, true)
  timeout   = try(each.value.timeout, 30)
}
