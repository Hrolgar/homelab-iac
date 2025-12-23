module "authentik_proxies" {
  source   = "../../modules/authentik/proxy"
  for_each = local.proxies_with_outpost_ids

  proxy_name         = each.value.name
  external_host      = each.value.external_host
  internal_host      = each.value.internal_host
  application_group  = each.value.application_group
  mode               = each.value.mode
  authorization_flow = data.authentik_flow.default_authorization.id
  invalidation_flow  = data.authentik_flow.default_invalidation.id
  outpost_id         = each.value.outpost_id
}
