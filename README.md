# Homelab Infrastructure as Code

OpenTofu configuration for managing homelab infrastructure using a stack-based architecture.

## Architecture

This repository uses a **stack-based layout** to organize infrastructure by domain:

- **[`stacks/foundation`](stacks/foundation/README.md)** - Core services (Infisical secrets, B2 storage, Proxmox pools)
- **[`stacks/identity`](stacks/identity/README.md)** - Identity & authentication (Authentik SSO, proxy providers, groups, policy bindings)
- **[`stacks/network`](stacks/network/README.md)** - Network infrastructure (Cloudflare tunnels, DNS, Zero Trust)
- **[`stacks/compute`](stacks/compute/README.md)** - Compute resources (Proxmox VMs)
- **[`stacks/scm`](stacks/scm/README.md)** - Source control management (GitHub repos, GitLab projects/groups with CI/CD secrets)
- **`stacks/_shared`** - Shared configuration (Infisical credentials)

Each stack is independently deployable with its own state file, allowing granular control and reducing blast radius. See each stack's README for detailed configuration options.

## Providers

- **Infisical** - Secrets management (foundation for all stacks)
- **Authentik** - Identity provider for SSO and forward authentication
- **Backblaze B2** - Object storage buckets
- **Proxmox** - VM provisioning and resource pools
- **Cloudflare** - Tunnels, DNS, Zero Trust Access
- **GitHub** - Repository management
- **GitLab** - Project/group management with CI/CD variables

## Prerequisites

- [OpenTofu](https://opentofu.org/) >= 1.6.0
- Infisical instance with machine identity configured
- Cloudflare account with API token
- Backblaze B2 account with application key
- GitHub personal access token
- GitLab instance with API token
- Proxmox API token

## Setup

### 1. Configure Infisical Credentials

Create `stacks/_shared/infisical.auto.tfvars` with your Infisical credentials:
```hcl
infisical_host          = "https://your-infisical-instance.com"
infisical_project_id    = "your-project-id"
infisical_client_id     = "your-client-id"
infisical_client_secret = "your-client-secret"
```

This file is **symlinked** into each stack directory. When creating a new stack, add a symlink:
```bash
cd stacks/new-stack
ln -s ../_shared/infisical.auto.tfvars infisical.auto.tfvars
```

### 2. Add Secrets to Infisical

Organize secrets in Infisical folders:
```
/auth/
  - AUTHENTIK_TOKEN
/auth/admin-users/
  - admin_password
  - [service_account]_password
/b2/
  - b2_application_key_id
  - b2_application_key
/cloudflare/
  - api_token
  - account_id
  - github_idp_id
/cloudflare/tunnels/
  - <tunnel_name>_tunnel_token
/github/
  - token
/gitlab/
  - token
/proxmox/
  - api_token_id
  - api_token_secret
  - vm_password
  - ssh_public_keys
/monitoring/
  - DISCORD_ALERT_WEBHOOK_URL
```

### 3. Configure Backend (Remote State)

Copy the example file and configure your B2 credentials:
```bash
cp stacks/_shared/backend.tfvars.example stacks/_shared/backend.tfvars
# Edit backend.tfvars with your B2 application key credentials
```

This enables remote state storage in B2 bucket `ullr-backups`:
- `opentofu/stacks/foundation/foundation.tfstate`
- `opentofu/stacks/identity/identity.tfstate`
- `opentofu/stacks/network/network.tfstate`
- `opentofu/stacks/compute/compute.tfstate`
- `opentofu/stacks/scm/scm.tfstate`

### 4. Deploy Stacks

#### Using Helper Scripts (Recommended)

Use the provided wrapper scripts for simplified stack management:

```bash
# Check status of all stacks
./scripts/status

# Work with individual stacks
./scripts/stack foundation init    # Initialize a stack
./scripts/stack foundation plan    # Plan changes
./scripts/stack foundation apply   # Apply changes
./scripts/stack foundation backup  # Backup tfvars to B2

# Deploy all stacks in order (foundation → identity → network → compute → scm)
./scripts/deploy-all plan   # Plan all stacks
./scripts/deploy-all apply  # Apply all stacks

# Other useful commands
./scripts/stack compute state list      # List resources
./scripts/stack network output          # Show outputs
./scripts/stack scm validate           # Validate configuration
```

#### Manual Deployment

You can also deploy stacks manually:

```bash
# Deploy foundation first (required by other stacks)
cd stacks/foundation
tofu init -backend-config=../_shared/backend.tfvars
tofu plan
tofu apply

# Deploy other stacks in order
cd ../identity
tofu init -backend-config=../_shared/backend.tfvars && tofu apply

cd ../network
tofu init -backend-config=../_shared/backend.tfvars && tofu apply

cd ../compute
tofu init -backend-config=../_shared/backend.tfvars && tofu apply

cd ../scm
tofu init -backend-config=../_shared/backend.tfvars && tofu apply
```

### 5. Backup Configuration

Backup your tfvars files to B2 from within each stack directory:
```bash
cd stacks/<stack-name>
../../scripts/backup-stack.sh
```

This uploads all .tfvars files to: `s3://ullr-backups/opentofu/stacks/<stack-name>/tfvars/`

## Helper Scripts

The repository includes convenient wrapper scripts to simplify common operations:

### `./scripts/stack`

Main wrapper for stack operations. Automatically handles backend configuration and provides a consistent interface.

```bash
./scripts/stack <stack-name> <command> [args]
```

**Available commands:**
- `init` - Initialize the stack
- `plan` - Show execution plan
- `apply` - Apply changes
- `destroy` - Destroy resources
- `refresh` - Refresh state
- `output` - Show outputs
- `validate` - Validate configuration
- `fmt` - Format configuration files
- `backup` - Backup tfvars to B2
- `state <args>` - Run state commands (list, show, mv, rm)

**Examples:**
```bash
./scripts/stack foundation init
./scripts/stack network plan
./scripts/stack compute apply
./scripts/stack scm state list
./scripts/stack foundation backup
```

### `./scripts/deploy-all`

Deploy all stacks in the correct dependency order (foundation → identity → network → compute → scm).

```bash
./scripts/deploy-all plan   # Plan all stacks
./scripts/deploy-all apply  # Apply all stacks
```

### `./scripts/status`

Show quick overview of all stack statuses including initialization state, backend type, and resource counts.

```bash
./scripts/status
```

Output example:
```
STACK           INITIALIZED  BACKEND     RESOURCES
────────────────────────────────────────────────────────────
foundation      ✓            remote      10
identity        ✓            remote      8
network         ✓            remote      51
compute         ✓            remote      1
scm             ✓            remote      25
```

### `./scripts/backup-stack.sh`

Backup all tfvars from the current stack directory to B2. Must be run from within a stack directory.

```bash
cd stacks/compute
../../scripts/backup-stack.sh
```

## Modules

| Module | Description |
|--------|-------------|
| `authentik/group` | Manages Authentik groups for user organization |
| `authentik/policy` | Manages policy bindings for application access control |
| `authentik/proxy` | Creates proxy providers for forward authentication |
| `authentik/role` | Manages RBAC roles for Authentik administration |
| `authentik/user` | Manages admin and service account users |
| `b2-bucket` | Creates B2 buckets with application keys |
| `cloudflare-tunnel` | Creates Cloudflare tunnels with DNS records |
| `cloudflare-access` | Configures Zero Trust Access applications |
| `infisical-secrets` | Stores secrets in Infisical |
| `github-repo` | Manages GitHub repositories with branch protection |
| `gitlab-group` | Manages GitLab groups with CI/CD variables |
| `gitlab-project` | Manages GitLab projects with CI/CD variables |
| `proxmox-vm` | Creates Proxmox VMs from template |
| `proxmox-pool` | Manages Proxmox resource pools |

## Stack Configuration Examples

### Foundation Stack

**Backblaze B2 Buckets:**
```hcl
# stacks/foundation/terraform.tfvars
b2_buckets = {
  "homelab-backups" = {
    bucket_type = "allPrivate"
  }
}
```

**Proxmox Pools:**
```hcl
proxmox_pools = {
  "infrastructure" = {
    comment = "Core infrastructure services"
  }
}
```

### Identity Stack

**Authentik Proxy Providers:**
```hcl
# stacks/identity/vars.authentik.auto.tfvars
authentik_proxies = {
  "traefik" = {
    name              = "Traefik Dashboard"
    external_host     = "https://traefik.example.com"
    internal_host     = "http://traefik:8080"
    application_group = "infrastructure"
    mode              = "forward_single"
  }
}
```

**Groups and Users:**
```hcl
authentik_groups = {
  "admins" = {
    name         = "Homelab Admins"
    is_superuser = true
    user_keys    = ["admin"]
  }
}

authentik_users = {
  "admin" = {
    username            = "admin"
    name                = "Admin User"
    email               = "admin@example.com"
    password_secret_key = "admin_password"  # From Infisical
  }
}
```

**Policy Bindings:**
```hcl
authentik_policy_bindings = {
  "traefik-admins-only" = {
    target_type = "application"
    target_key  = "traefik"
    group_key   = "admins"
  }
}
```

### Network Stack

**Cloudflare Tunnels:**
```hcl
# stacks/network/terraform.tfvars
tunnels = {
  "homelab-tunnel" = {
    routes = {
      "app" = {
        domain        = "example.com"
        service       = "http://10.69.1.100:8080"
        no_tls_verify = false
      }
    }
  }
}
```

**Cloudflare Zero Trust Access:**
```hcl
access_apps = {
  "My App" = {
    domain        = "example.com"
    subdomain     = "app"
    allowed_email = "you@example.com"
  }
}
```

### Compute Stack

**Proxmox VMs:**
```hcl
# stacks/compute/terraform.tfvars
vms = {
  "docker-host" = {
    cores     = 4
    memory    = 8192
    disk_size = "100G"
    ip        = "10.69.1.100"
    pool      = "infrastructure"
    tags      = ["docker", "tofu-managed"]
  }
}
```

### SCM Stack

**GitHub Repositories:**
```hcl
# stacks/scm/terraform.tfvars
github_owner = "your-username"

github_repos = {
  "my-project" = {
    description = "My awesome project"
    visibility  = "public"
    topics      = ["homelab", "iac"]
  }
}
```

**GitLab Projects and Groups:**
```hcl
gitlab_groups = {
  "homelab" = {
    description      = "Homelab projects"
    visibility_level = "public"
  }
}

gitlab_projects = {
  "homelab-stacks" = {
    description      = "Docker compose stacks"
    visibility_level = "public"
    topics           = ["docker", "homelab"]
  }
}
```

**GitLab CI/CD Secrets:**

The SCM stack supports dynamic GitLab CI/CD variables that can mix plaintext values with secrets from Infisical:

```hcl
# Group-level secrets
gitlab_group_secrets = {
  SSH_PUBLIC_KEY = {
    group             = "homelab"
    infisical_path    = "proxmox"
    infisical_key     = "ssh_public_keys"
    variable_type     = "env_var"
    protected         = true
    masked            = false
    description       = "SSH public key for deployments"
  }
}

# Project-level secrets with mixed sources
gitlab_project_secrets = {
  # Dynamic file mixing plaintext and Infisical secrets
  APP_ENV_FILE = {
    project       = "homelab-stacks"
    description   = "Application environment configuration"
    variable_type = "file"
    protected     = true
    masked        = false
    content_lines = [
      { key = "SMTP_HOST", value = "smtp.gmail.com" },
      { key = "SMTP_PORT", value = "587" },
      { key = "SMTP_USER", infisical_path = "monitoring", infisical_key = "smtp_user" },
      { key = "SMTP_PASSWORD", infisical_path = "monitoring", infisical_key = "smtp_password" },
    ]
  }

  # Entire secret from Infisical
  TUNNEL_TOKEN = {
    project        = "homelab-stacks"
    description    = "Cloudflare tunnel token"
    infisical_path = "cloudflare/tunnels"
    infisical_key  = "my_tunnel_token"
    variable_type  = "file"
    protected      = true
    masked         = true
  }
}
```

**Key Features:**
- **`content_lines`** - Build dynamic files mixing plaintext and Infisical secrets
- **`infisical_path` / `infisical_key`** - Pull entire secrets from Infisical
- **`value`** - Use static plaintext values
- **`variable_type`** - `env_var` or `file`
- **`protected`** - Restrict to protected branches
- **`masked`** - Mask values in CI/CD logs
- **`description`** - Document the variable's purpose

## State Management

Each stack maintains its own remote state file in Backblaze B2:
- `s3://ullr-backups/opentofu/stacks/foundation/foundation.tfstate`
- `s3://ullr-backups/opentofu/stacks/identity/identity.tfstate`
- `s3://ullr-backups/opentofu/stacks/network/network.tfstate`
- `s3://ullr-backups/opentofu/stacks/compute/compute.tfstate`
- `s3://ullr-backups/opentofu/stacks/scm/scm.tfstate`

Backend configuration is defined in each stack's `backend.tf` file. Credentials are provided via `stacks/_shared/backend.tfvars` at init time.

### Migrating from Local State

If you have existing local state files, migrate them to remote backend:

```bash
cd stacks/<stack-name>
tofu init -backend-config=../_shared/backend.tfvars -migrate-state
```

## Importing Existing Resources

If you have existing GitLab CI/CD variables, import them into Terraform state:

```bash
cd stacks/scm

# Import group variable
tofu import 'gitlab_group_variable.secrets["VARIABLE_NAME"]' '<group_id>:<VARIABLE_NAME>'

# Import project variable
tofu import 'gitlab_project_variable.secrets["VARIABLE_NAME"]' '<project_id>:<VARIABLE_NAME>'
```

**Note:** The variable must be defined in `terraform.tfvars` before importing.

## Disaster Recovery

### Restoring State from B2 Backup

If you need to restore state from B2 backup (e.g., corrupted local cache, B2 connectivity issues):

#### Method 1: Re-initialize (Recommended)

Simply re-run init to fetch fresh state from B2:

```bash
cd stacks/<stack-name>
rm -rf .terraform  # Clear local cache
tofu init -backend-config=../_shared/backend.tfvars
```

OpenTofu will automatically download the latest state from B2.

#### Method 2: Manual State Recovery

If B2 is unavailable or corrupted, manually restore from backup:

1. **Download state from B2:**
```bash
b2 file download ullr-backups opentofu/stacks/<stack-name>/<stack-name>.tfstate <stack-name>.tfstate
```

2. **Temporarily switch to local backend** (edit `backend.tf`):
```hcl
terraform {
  backend "local" {
    path = "<stack>.tfstate"
  }
}
```

3. **Re-initialize with local state:**
```bash
tofu init -migrate-state
```

4. **After recovery, switch back to B2:**
   - Revert `backend.tf` to S3 configuration
   - Run `tofu init -backend-config=../_shared/backend.tfvars -migrate-state`

### Restoring Configuration Files

Restore tfvars from B2 backup:

```bash
# Restore specific stack (downloads all tfvars files from that stack)
cd stacks/scm
b2 file download-by-name ullr-backups opentofu/stacks/scm/tfvars/terraform.tfvars terraform.tfvars

# Or download all tfvars for a stack
for file in $(b2 ls ullr-backups opentofu/stacks/scm/tfvars/ | awk '{print $NF}'); do
  b2 file download-by-name ullr-backups "opentofu/stacks/scm/tfvars/$file" "$file"
done

# Restore shared Infisical config
cd ../../stacks/_shared
b2 file download-by-name ullr-backups opentofu/stacks/_shared/tfvars/infisical.auto.tfvars infisical.auto.tfvars
```

### Backup Locations

Each stack's state is automatically stored in B2:
- Foundation: `s3://ullr-backups/opentofu/stacks/foundation/foundation.tfstate`
- Identity: `s3://ullr-backups/opentofu/stacks/identity/identity.tfstate`
- Network: `s3://ullr-backups/opentofu/stacks/network/network.tfstate`
- Compute: `s3://ullr-backups/opentofu/stacks/compute/compute.tfstate`
- SCM: `s3://ullr-backups/opentofu/stacks/scm/scm.tfstate`

Configuration backups (created by `../../scripts/backup-stack.sh`):
- `s3://ullr-backups/opentofu/stacks/<stack-name>/tfvars/*.tfvars`

B2 versioning is recommended for the bucket to maintain state history.

## Repository Management

This infrastructure code itself can be managed by the SCM stack, enabling GitOps workflows where infrastructure changes are tracked through GitLab/GitHub repositories with automated CI/CD pipelines.