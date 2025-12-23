# Identity Stack - Authentik SSO/Authentication

This stack manages the identity and authentication infrastructure using [Authentik](https://goauthentik.io/), an open-source Identity Provider (IdP) for SSO, LDAP, SAML, OAuth2, and forward authentication.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Initial Setup](#initial-setup)
- [Managing Resources](#managing-resources)
  - [Admin Users & Service Accounts](#admin-users--service-accounts)
  - [Regular Users](#regular-users)
  - [Groups](#groups)
  - [Roles](#roles)
  - [Applications (Proxy Providers)](#applications-proxy-providers)
  - [Policy Bindings](#policy-bindings)
- [Secrets Management](#secrets-management)
- [Common Tasks](#common-tasks)
- [Troubleshooting](#troubleshooting)
- [File Structure](#file-structure)

---

## Overview

**What this stack manages:**
- ✅ **Proxy Providers**: Forward authentication for applications (Traefik, Grafana, etc.)
- ✅ **Groups**: User organization and permission management
- ✅ **Roles**: RBAC for Authentik administration
- ✅ **Admin/Service Account Users**: Infrastructure accounts managed via IaC
- ✅ **Policy Bindings**: Application access control
- ✅ **Outposts**: Authentication endpoints

**What this stack does NOT manage:**
- ❌ **Regular Users**: The human users are created manually in Authentik UI
- ❌ **Flows & Stages**: Authentication workflows (use Authentik UI or blueprints)

---

## Architecture

### Authentication Flow

```
User Request → Traefik (ForwardAuth) → Authentik Outpost → Application
                                             ↓
                                        Policy Check
                                             ↓
                                        Group Membership
```

### IaC vs Manual Management

| Resource | Managed By | Why |
|----------|------------|-----|
| Admin users | IaC (this stack) | Automation, password from Infisical |
| Service accounts | IaC (this stack) | Automation, password from Infisical |
| Regular users | Authentik UI | Too dynamic, users manage own passwords |
| Groups | IaC (this stack) | Infrastructure, rarely changes |
| Roles | IaC (this stack) | Infrastructure, rarely changes |
| Applications | IaC (this stack) | Infrastructure, version controlled |
| Policy bindings | IaC (this stack) | Access control, version controlled |

---

## Prerequisites

1. **Authentik Instance Running**
   - URL: `https://auth.admin.com`
   - API token with admin access

2. **Infisical Setup**
   - Universal Auth credentials configured
   - Project ID and environment (dev/prod)

3. **Backend Storage**
   - B2/S3 bucket for Terraform state: `your-bucket-name`

4. **Dependencies**
   - OpenTofu >= 1.6
   - Authentik provider ~> 2025.10.0
   - Infisical provider >= 0.15.56

---

## Initial Setup

### 1. Configure Infisical Variables

Create `vars.infisical.auto.tfvars` (or use environment variables):

```hcl
infisical_host          = "https://app.infisical.com"
infisical_project_id    = "your-project-id"
infisical_client_id     = "your-client-id"
infisical_client_secret = "your-client-secret"
infisical_env_slug      = "prod"  # or "dev"
```

### 2. Set Up Secrets in Infisical

**Required folders and secrets:**

```
/auth/
  └── AUTHENTIK_TOKEN = "your-authentik-api-token"

/auth/admin-users/
  └── admin_password = "your-secure-admin-password"
  └── [service-account]_password = "service-account-password"  # As needed
```

### 3. Initialize and Apply

```bash
tofu init
tofu plan
tofu apply
```

---

## Managing Resources

### Admin Users & Service Accounts

**File**: `vars.authentik.auto.tfvars`

#### Add an Admin User

```hcl
authentik_users = {
  "admin" = {
    username            = "admin"
    name                = "Admin Admin"
    email               = "admin@admin.com"
    password_secret_key = "admin_password"  # From Infisical: /auth/admin-users/
    # Note: Do NOT set group_keys here - managed from group side
  }
}
```

**Then add to admin group:**

```hcl
authentik_groups = {
  "admins" = {
    name         = "Homelab Admins"
    is_superuser = true
    user_keys    = ["admin"]  # Reference the user key
  }
}
```

#### Add a Service Account

```hcl
authentik_users = {
  "grafana-svc" = {
    username            = "svc-grafana"
    name                = "Grafana Service Account"
    type                = "service_account"
    password_secret_key = "grafana_svc_password"
  }
}

# Add to a service account group
authentik_groups = {
  "service-accounts" = {
    name      = "Service Accounts"
    user_keys = ["grafana-svc"]
  }
}
```

**Important Notes:**
- ✅ Passwords stored in Infisical under `/auth/admin-users/[password_secret_key]`
- ✅ Users can change passwords in Authentik - Terraform won't reset them
- ✅ Groups managed from the group side using `user_keys` (scalable!)
- ❌ Never use `group_keys` in user definitions (causes circular dependencies)

---

### Regular Users

**Regular users (alice, bob, charlie, etc.) are NOT managed in IaC.**

#### To Create a Regular User:

1. **In Authentik UI**: Go to **Directory** → **Users** → **Create**
2. Fill in: username, name, email
3. **DO NOT set a password** - use recovery flow instead
4. Click **Reset Password** → **Send recovery link**
5. User receives email and sets their own password
6. Assign to groups manually or via policy bindings

**Why not in IaC?**
- Regular users are highly dynamic (23+ people)
- Password management is simpler via UI/recovery flows
- IaC focused on infrastructure, not people

---

### Groups

**File**: `vars.authentik.auto.tfvars`

```hcl
authentik_groups = {
  "admins" = {
    name         = "Homelab Admins"
    is_superuser = true                          # Full Authentik admin access
    role_keys    = ["user-manager", "app-manager"]  # Optional RBAC roles
    user_keys    = ["admin", "friend"]         # Admin users
  }

  "users" = {
    name = "Homelab Users"
    # Regular users added manually in Authentik UI
  }

  "developers" = {
    name      = "Developers"
    user_keys = ["alice-dev", "bob-dev"]  # If managed in IaC
  }
}
```

**Available Fields:**
- `name` (required): Display name
- `is_superuser` (optional): Full admin access (default: false)
- `parent_group_id` (optional): UUID of parent group for nested hierarchies
- `user_ids` (optional): Direct user IDs (not recommended)
- `user_keys` (optional): References to `authentik_users` keys (recommended)
- `role_keys` (optional): References to `authentik_roles` keys

---

### Roles

**File**: `vars.authentik.auto.tfvars`

Roles control what users can do **within Authentik** (manage users, apps, flows, etc.).

```hcl
authentik_roles = {
  "user-manager" = {
    name = "User Manager"
  }

  "app-manager" = {
    name = "Application Manager"
  }

  "flow-manager" = {
    name = "Flow Manager"
  }
}
```

**Note**: Role names are created, but **permissions must be assigned via Authentik UI** or additional IaC resources (`authentik_rbac_permission_role`).

**For homelab**: Using `is_superuser = true` on the admins group is simpler than managing granular role permissions.

---

### Applications (Proxy Providers)

**File**: `vars.authentik.auto.tfvars`

Applications create forward authentication providers for services behind Traefik.

```hcl
authentik_proxies = {
  "traefik" = {
    name              = "Traefik Dashboard"
    external_host     = "https://traefik.admin.com"
    internal_host     = "http://traefik:8080"
    application_group = "infrastructure"
    mode              = "forward_single"
  }

  "grafana" = {
    name              = "Grafana"
    external_host     = "https://grafana.admin.com"
    internal_host     = "http://grafana:3000"
    application_group = "monitoring"
  }
}
```

**Available Fields:**
- `name` (required): Display name in Authentik
- `external_host` (required): Public URL (https://service.example.com)
- `internal_host` (required): Internal service URL (http://service:port)
- `application_group` (optional): Group in Authentik UI (default: "internal")
- `mode` (optional): forward_single, forward_domain, or proxy (default: "forward_single")
- `outpost_name` (optional): Custom outpost (default: "authentik Embedded Outpost")

**Important**: This only creates the Authentik configuration. You must configure Traefik ForwardAuth middleware separately:

```yaml
# In Traefik middleware
middlewares:
  authentik:
    forwardAuth:
      address: https://auth.admin.com/outpost.goauthentik.io/auth/traefik
```

---

### Policy Bindings

**File**: `vars.authentik.auto.tfvars`

Policy bindings control **who can access which applications**.

```hcl
authentik_policy_bindings = {
  "traefik-admins-only" = {
    target_type = "application"
    target_key  = "traefik"    # References authentik_proxies["traefik"]
    group_key   = "admins"      # References authentik_groups["admins"]
    order       = 0
  }

  "grafana-developers" = {
    target_type = "application"
    target_key  = "grafana"
    group_key   = "developers"
    order       = 0
  }
}
```

**Available Fields:**
- `target_type` (required): "application" or raw UUID
- `target_key` (optional): Key from `authentik_proxies`
- `target_id` (optional): Raw application UUID
- `group_key` (optional): Key from `authentik_groups`
- `group_id` (optional): Raw group UUID
- `user_id` (optional): Specific user ID
- `order` (optional): Binding priority (default: 0)

---

## Secrets Management

### Infisical Folder Structure

```
/auth/
  ├── AUTHENTIK_TOKEN                 # Authentik API token
  └── admin-users/
      ├── admin_password           # Admin user passwords
      ├── friend_password
      └── grafana_svc_password       # Service account passwords
```

### Adding a New Secret

1. **In Infisical**: Navigate to your project → `/auth/admin-users/`
2. Click **Add Secret**
3. Key: `username_password` (e.g., `alice_password`)
4. Value: Secure password
5. **In IaC**: Reference via `password_secret_key = "alice_password"`

### Password Lifecycle

- **On user creation**: Password set from Infisical
- **User changes password in Authentik**: ✅ No problem! Terraform ignores password changes
- **Updating password in Infisical**: Won't affect existing users (lifecycle ignore_changes)
- **To reset a password**: Must be done manually in Authentik UI or via recovery flow

---

## Common Tasks

### Add a New Admin User

1. **Add secret to Infisical**: `/auth/admin-users/newuser_password`
2. **Edit `vars.authentik.auto.tfvars`**:
   ```hcl
   authentik_users = {
     # ... existing users ...
     "newuser" = {
       username            = "newuser"
       name                = "New User Name"
       email               = "newuser@admin.com"
       password_secret_key = "newuser_password"
     }
   }

   authentik_groups = {
     "admins" = {
       # ... existing config ...
       user_keys = ["admin", "newuser"]  # Add to list
     }
   }
   ```
3. **Apply**: `tofu apply`

### Add a New Application

1. **Edit `vars.authentik.auto.tfvars`**:
   ```hcl
   authentik_proxies = {
     # ... existing ...
     "new-app" = {
       name          = "New Application"
       external_host = "https://newapp.admin.com"
       internal_host = "http://newapp:8000"
     }
   }
   ```
2. **Apply**: `tofu apply`
3. **Configure Traefik ForwardAuth** in your application's docker-compose/config

### Restrict Application to Specific Group

```hcl
authentik_policy_bindings = {
  "newapp-developers-only" = {
    target_type = "application"
    target_key  = "new-app"
    group_key   = "developers"
  }
}
```

### Remove a User

1. **Remove from `user_keys` in groups**
2. **Remove from `authentik_users`**
3. **Apply**: `tofu apply`

---

## Troubleshooting

### Issue: User not appearing in group

**Problem**: Added `user_keys` to group but user not showing up.

**Solution**:
- Check user was created: `tofu state show 'module.authentik_users["username"].authentik_user.this'`
- Verify user_keys reference is correct
- Run `tofu plan` to see if update is pending

### Issue: Circular dependency error

**Problem**: `Error: Cycle: module.authentik_users ... module.authentik_groups`

**Solution**:
- ✅ Use `user_keys` in groups (not `group_keys` in users)
- ✅ Ensure `group_ids = []` in `authentik-users.tf`
- ✅ Verify lifecycle ignore_changes includes `groups`

### Issue: Password changes on every apply

**Problem**: Terraform wants to reset user passwords.

**Solution**:
- Verify `lifecycle { ignore_changes = [password, groups] }` in user module
- Check password is fetched from Infisical correctly
- Passwords should only be set on user creation

### Issue: Authentik token error

**Problem**: `Error: Unable to Create Authentik API Client`

**Solution**:
- Check Infisical secret exists: `/auth/AUTHENTIK_TOKEN`
- Verify Infisical credentials are correct
- Test: `tofu state show 'data.infisical_secrets.authentik'`

### Issue: No changes but drift detected

**Problem**: `tofu plan` shows changes on every run.

**Solution**: This was fixed by:
- Adding lifecycle ignore_changes for groups
- Managing groups from group side only
- If still occurs, check for bidirectional relationships

---

## File Structure

```
stacks/identity/
├── README.md                          # This file
├── backend.tf                         # S3/B2 backend configuration
├── providers.tf                       # Authentik & Infisical provider config
├── versions.tf                        # Provider version constraints
├── variables-authentik.tf             # Variable definitions for Authentik resources
├── variables-infisical.tf             # Variable definitions for Infisical
├── vars.authentik.auto.tfvars         # Authentik resource configurations
├── vars.infisical.auto.tfvars.example # Infisical config template
├── data.tf                            # Infisical data sources
├── authentik-data.tf                  # Authentik data sources (flows)
├── authentik-locals.tf                # Local variables (outpost resolution, password injection)
├── authentik-infrastructure.tf        # Infrastructure resources (roles, outposts)
├── authentik-groups.tf                # Group module calls
├── authentik-users.tf                 # User module calls
├── authentik-proxies.tf               # Proxy provider module calls
└── authentik-policies.tf              # Policy binding module calls
```

### Module Structure

```
modules/authentik/
├── proxy/                             # Proxy provider module
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── group/                             # Group module
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── user/                              # User module
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── role/                              # Role module
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── policy/                            # Policy binding module
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

---

## Security Best Practices

1. ✅ **Secrets in Infisical**: Never commit passwords to Git
2. ✅ **`.gitignore`**: Ensure `*.auto.tfvars` is ignored
3. ✅ **State encryption**: Backend storage encrypted at rest
4. ✅ **Token rotation**: Rotate Authentik API token periodically
5. ✅ **MFA**: Enable MFA for admin accounts in Authentik UI
6. ✅ **Audit logs**: Review Authentik audit logs regularly

---

## Resources

- [Authentik Documentation](https://docs.goauthentik.io/)
- [Authentik Terraform Provider](https://registry.terraform.io/providers/goauthentik/authentik/latest/docs)
- [Infisical Documentation](https://infisical.com/docs)
- [Traefik ForwardAuth](https://doc.traefik.io/traefik/middlewares/http/forwardauth/)

---

## Support

For issues or questions:
1. Check [Troubleshooting](#troubleshooting) section
2. Review Authentik logs: `docker logs authentik-server`
3. Check Terraform/OpenTofu output for detailed errors
4. Consult Authentik documentation for specific features
