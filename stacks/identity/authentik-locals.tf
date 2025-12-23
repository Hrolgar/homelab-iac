# Local variables for Authentik resource configuration

locals {
  # === Outpost ID Resolution ===
  # Create a map of outpost names to IDs from all sources
  all_outposts = merge(
    # Default outpost
    {
      (var.authentik_default_outpost_name) = data.authentik_outpost.default.id
    },
    # Existing outposts from data sources
    {
      for k, v in data.authentik_outpost.existing : v.name => v.id
    },
    # Newly created outposts
    {
      for k, v in authentik_outpost.this : v.name => v.id
    }
  )

  # Prepare proxy configurations with resolved outpost IDs
  proxies_with_outpost_ids = {
    for k, v in var.authentik_proxies : k => merge(v, {
      outpost_id = v.outpost_name != null ? local.all_outposts[v.outpost_name] : data.authentik_outpost.default.id
    })
  }

  # === Password Injection from Infisical ===
  # Merge user configurations with passwords from Infisical
  users_with_passwords = {
    for key, user in var.authentik_users : key => merge(user, {
      # If password_secret_key is specified, fetch from Infisical
      # Otherwise use the password from tfvars (or null)
      password = try(
        user.password_secret_key != null ? data.infisical_secrets.admin_passwords.secrets[user.password_secret_key].value : user.password,
        null
      )
    })
  }
}
