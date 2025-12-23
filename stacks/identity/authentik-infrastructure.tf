# Infrastructure-level Authentik resources (roles, outposts)
# These are typically set-and-forget resources for the Authentik instance

# === Data Sources ===

# Default outpost (usually "authentik Embedded Outpost")
data "authentik_outpost" "default" {
  name = var.authentik_default_outpost_name
}

# Other existing outposts (if any)
data "authentik_outpost" "existing" {
  for_each = var.authentik_outposts_existing
  name     = each.value
}

# === RBAC Roles ===

# Roles for Authentik administration
# Note: Role permissions must be assigned separately via authentik_rbac_permission_role
module "authentik_roles" {
  source   = "../../modules/authentik/role"
  for_each = var.authentik_roles

  name = each.value.name
}

# === Outposts ===

# Create new outposts for distributed authentication
resource "authentik_outpost" "this" {
  for_each = var.authentik_outposts

  name               = each.value.name
  type               = each.value.type
  protocol_providers = []

  service_connection = try(each.value.service_connection, null)

  config = jsonencode({
    authentik_host          = var.authentik_url
    authentik_host_insecure = try(each.value.insecure, false)
    log_level               = try(each.value.log_level, "info")
  })
}
