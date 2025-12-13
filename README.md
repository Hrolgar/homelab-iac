# Homelab Infrastructure as Code

OpenTofu configuration for managing homelab infrastructure.

## Providers

- **Cloudflare** - Tunnels, DNS, Zero Trust Access
- **Backblaze B2** - Object storage buckets
- **Infisical** - Secrets management
- **GitHub** - Repository management
- **Proxmox** - VM provisioning

## Prerequisites

- [OpenTofu](https://opentofu.org/) >= 1.6.0
- Infisical instance with machine identity configured
- Cloudflare account with API token
- Backblaze B2 account with application key
- GitHub personal access token
- Proxmox API token

## Setup

1. Clone the repo
2. Copy `terraform.tfvars.example` to `terraform.tfvars` and fill in your values
3. Add secrets to Infisical:
   - `/b2/b2_application_key_id`
   - `/b2/b2_application_key`
   - `/cloudflare/api_token`
   - `/cloudflare/account_id`
   - `/cloudflare/github_idp_id`
   - `/github/token`
   - `/proxmox/api_token_id`
   - `/proxmox/api_token_secret`
   - `/proxmox/vm_password`
   - `/proxmox/ssh_public_keys`
4. Initialize and apply:
```bash
tofu init
tofu plan
tofu apply
```

## Modules

| Module | Description |
|--------|-------------|
| `b2-bucket` | Creates B2 buckets with application keys |
| `cloudflare-tunnel` | Creates Cloudflare tunnels with DNS records |
| `cloudflare-access` | Configures Zero Trust Access applications |
| `infisical-secrets` | Stores secrets in Infisical |
| `github-repo` | Manages GitHub repositories |
| `proxmox-vm` | Creates Proxmox VMs from template |
| `proxmox-pool` | Manages Proxmox resource pools |

## Adding Resources

### New Tunnel Route
```hcl
tunnels = {
  "my-tunnel" = {
    routes = {
      "app" = {
        domain        = "example.com"
        service       = "http://192.168.1.10:8080"
        no_tls_verify = false
      }
    }
  }
}
```

### New Access App
```hcl
access_apps = {
  "My App" = {
    domain        = "example.com"
    subdomain     = "app"
    allowed_email = "you@example.com"
  }
}
```

### New Proxmox VM
```hcl
vms = {
  "my-server" = {
    cores     = 4
    memory    = 4096
    disk_size = "50G"
    ip        = "10.69.1.100"
    pool      = "infrastructure"
    tags      = ["docker", "tofu-managed"]
  }
}
```

### New Proxmox Pool
```hcl
proxmox_pools = {
  "infrastructure" = {
    comment = "Core infrastructure services"
  }
}
```

### New GitHub Repo
```hcl
github_repos = {
  "my-project" = {
    description = "My project"
    visibility  = "private"
    topics      = ["homelab"]
  }
}
```

## State Backend

To store state in Backblaze B2:

1. Copy `backend.tf.example` to `backend.tf`
2. Fill in your B2 bucket name and credentials
3. Run `tofu init -migrate-state`

## Repository Mirroring

This repo is mirrored to both GitHub and GitLab:

```bash
# Push to both remotes
git remote set-url --add --push origin git@github.com:USER/homelab-iac.git
git remote set-url --add --push origin ssh://git@GITLAB:2222/GROUP/homelab-iac.git
```