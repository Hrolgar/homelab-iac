# Foundation Stack

Core infrastructure services that other stacks depend on.

## Resources

- **Infisical Secrets** - Fetches secrets from Infisical for use by other stacks
- **Backblaze B2 Buckets** - Object storage for backups and artifacts
- **Proxmox Resource Pools** - Logical grouping of Proxmox resources

## Dependencies

This stack has **no dependencies** on other stacks and should be deployed first.

## Secrets Required

Create these secrets in Infisical before deploying:

```
/b2/
  - b2_application_key_id
  - b2_application_key
/proxmox/
  - api_token_id
  - api_token_secret
  - vm_password
  - ssh_public_keys
```

## Configuration

Edit `terraform.tfvars`:

```hcl
# Backblaze B2 buckets
b2_buckets = {
  "homelab-backups" = {
    bucket_type = "allPrivate"
  }
}

# Proxmox resource pools
proxmox_pools = {
  "infrastructure" = {
    comment = "Core infrastructure services"
  }
  "development" = {
    comment = "Development and testing"
  }
}
```

## Backend Configuration

This stack uses remote state stored in Backblaze B2.

1. Create `stacks/_shared/backend.tfvars` with your B2 credentials:
```hcl
access_key = "your-b2-key-id"
secret_key = "your-b2-application-key"
```

2. Initialize with backend configuration:
```bash
tofu init -backend-config=../_shared/backend.tfvars
```

State location: `s3://ullr-backups/opentofu/stacks/foundation/foundation.tfstate`

## Deploy

```bash
tofu init -backend-config=../_shared/backend.tfvars
tofu plan
tofu apply
```
