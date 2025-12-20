# SCM Stack

Source Control Management - GitHub repositories and GitLab projects/groups with CI/CD secrets.

## Resources

- **GitHub Repositories** - Repository management with branch protection
- **GitLab Groups** - Organization-level groups with CI/CD variables
- **GitLab Projects** - Project repositories with CI/CD variables
- **GitLab Group Variables** - Group-level CI/CD secrets
- **GitLab Project Variables** - Project-level CI/CD secrets

## Dependencies

- **foundation** - Requires GitHub and GitLab tokens from Infisical

## Secrets Required

Create these secrets in Infisical before deploying:

```
/github/
  - token
/gitlab/
  - token
/monitoring/
  - DISCORD_ALERT_WEBHOOK_URL
  - smtp_user
  - smtp_password
/cloudflare/tunnels/
  - <tunnel_name>_tunnel_token
```

## Configuration

Edit `terraform.tfvars`:

### GitHub Repositories

```hcl
github_owner = "your-username"

github_repos = {
  "homelab-iac" = {
    description = "Infrastructure as Code for homelab"
    visibility  = "public"
    topics      = ["opentofu", "homelab", "infrastructure-as-code"]
  }
}
```

### GitLab Groups and Projects

```hcl
gitlab_host = "https://gitlab.example.com"

gitlab_groups = {
  "homelab" = {
    description      = "Homelab main group"
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

### GitLab CI/CD Secrets

The SCM stack supports three ways to define GitLab CI/CD variables:

#### 1. Dynamic Files (Mix Plaintext and Infisical)

Build environment files mixing plaintext configuration with secrets from Infisical:

```hcl
gitlab_project_secrets = {
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
}
```

#### 2. Entire Secret from Infisical

Pull complete secrets directly from Infisical:

```hcl
gitlab_project_secrets = {
  TUNNEL_TOKEN = {
    project        = "homelab-stacks"
    description    = "Cloudflare tunnel token"
    infisical_path = "cloudflare/tunnels"
    infisical_key  = "homelab_tunnel_token"
    variable_type  = "file"
    protected      = true
    masked         = true
  }
}
```

#### 3. Static Plaintext Values

Define static configuration directly:

```hcl
gitlab_project_secrets = {
  STATIC_CONFIG = {
    project       = "homelab-stacks"
    description   = "Static configuration file"
    variable_type = "file"
    value         = <<-EOF
      ENVIRONMENT=production
      DEBUG=false
      TIMEOUT=30
    EOF
  }
}
```

### Variable Options

All GitLab secrets support these options:

- **`variable_type`** - `"env_var"` or `"file"` (default: `"env_var"`)
- **`protected`** - Restrict to protected branches (default: `true`)
- **`masked`** - Mask value in CI/CD logs (default: `false`)
- **`environment_scope`** - Environment scope, e.g., `"*"`, `"production"` (default: `"*"`)
- **`description`** - Description of the variable (default: `null`)

## Importing Existing Variables

If you have existing GitLab CI/CD variables, import them:

```bash
# Find your group/project ID
tofu state show 'module.gitlab_groups["homelab"].gitlab_group.this'
tofu state show 'module.gitlab_projects["homelab-stacks"].gitlab_project.this'

# Import group variable
tofu import 'gitlab_group_variable.secrets["SSH_PUBLIC_KEY"]' '<group_id>:SSH_PUBLIC_KEY'

# Import project variable
tofu import 'gitlab_project_variable.secrets["MONITORING_ENV_FILE"]' '<project_id>:MONITORING_ENV_FILE'
```

**Important:** Define the variable in `terraform.tfvars` before importing!

## Backend Configuration

This stack uses remote state stored in Backblaze B2.

### Setup Backend

1. Create `stacks/_shared/backend.tfvars` with your B2 credentials:
```hcl
access_key = "your-b2-key-id"
secret_key = "your-b2-application-key"
```

2. Initialize with backend configuration:
```bash
tofu init -backend-config=../_shared/backend.tfvars
```

The state will be stored at: `s3://ullr-backups/opentofu/stacks/scm/scm.tfstate`

### Migrate Existing State

If you have local state, migrate it to the backend:
```bash
tofu init -backend-config=../_shared/backend.tfvars -migrate-state
```

## Deploy

```bash
tofu init -backend-config=../_shared/backend.tfvars
tofu plan
tofu apply
```

## Backup Configuration

To backup your tfvars to B2:
```bash
# From within the stack directory
../../scripts/backup-stack.sh
```

This uploads all .tfvars files in the current stack to: `s3://ullr-backups/opentofu/stacks/<stack-name>/tfvars/`

## Notes

- Infisical folders used in secrets must be added to `infisical_folders` variable
- The `_shared/infisical.auto.tfvars` symlink provides Infisical credentials
- GitLab variables can be scoped to specific environments
- Protected variables only work in protected branches/tags
- Masked variables hide values in job logs (has format restrictions)
