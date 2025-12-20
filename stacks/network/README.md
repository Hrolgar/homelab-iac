# Network Stack

Network infrastructure including Cloudflare tunnels, DNS, and Zero Trust Access.

## Resources

- **Cloudflare Tunnels** - Secure tunnels to expose services
- **Cloudflare DNS Records** - Automatic DNS records for tunnel routes
- **Cloudflare Zero Trust Access** - Application access control

## Dependencies

- **foundation** - Requires Cloudflare secrets from Infisical

## Secrets Required

Create these secrets in Infisical before deploying:

```
/cloudflare/
  - api_token
  - account_id
  - github_idp_id
/cloudflare/tunnels/
  - <tunnel_name>_tunnel_token  (for each tunnel)
```

## Configuration

Edit `terraform.tfvars`:

```hcl
# Cloudflare tunnels with routes
tunnels = {
  "homelab-main" = {
    routes = {
      "portainer" = {
        domain        = "example.com"
        subdomain     = "portainer"
        service       = "http://10.69.1.100:9000"
        no_tls_verify = false
      }
      "grafana" = {
        domain        = "example.com"
        subdomain     = "grafana"
        service       = "http://10.69.1.101:3000"
        no_tls_verify = false
      }
    }
  }
}

# Zero Trust Access applications
access_apps = {
  "Portainer" = {
    domain        = "example.com"
    subdomain     = "portainer"
    allowed_email = "you@example.com"
  }
}
```

## Backend Configuration

This stack uses remote state stored in Backblaze B2.

1. Ensure `stacks/_shared/backend.tfvars` exists with your B2 credentials
2. Initialize with backend configuration:
```bash
tofu init -backend-config=../_shared/backend.tfvars
```

State location: `s3://ullr-backups/opentofu/stacks/network/network.tfstate`

## Deploy

```bash
tofu init -backend-config=../_shared/backend.tfvars
tofu plan
tofu apply
```

## Notes

- Tunnel tokens must be generated in the Cloudflare dashboard first
- DNS records are automatically created for each tunnel route
- Access applications use GitHub as the identity provider
