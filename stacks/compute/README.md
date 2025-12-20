# Compute Stack

Virtual machine provisioning on Proxmox.

## Resources

- **Proxmox VMs** - Virtual machines created from templates

## Dependencies

- **foundation** - Requires Proxmox secrets and resource pools

## Secrets Required

Create these secrets in Infisical before deploying:

```
/proxmox/
  - api_token_id
  - api_token_secret
  - vm_password
  - ssh_public_keys
```

## Configuration

Edit `terraform.tfvars`:

```hcl
proxmox_host     = "https://proxmox.example.com:8006"
proxmox_node     = "ullr"
proxmox_template = "debian-template"
proxmox_ci_user  = "ubuntu"

vms = {
  "docker-host" = {
    cores     = 4
    memory    = 8192
    disk_size = "100G"
    ip        = "10.69.1.100"
    gateway   = "10.69.1.1"
    pool      = "infrastructure"
    node      = "pve"
    template  = "ubuntu-cloud-template"
    tags      = ["docker", "tofu-managed"]
  }

  "k3s-master" = {
    cores     = 2
    memory    = 4096
    disk_size = "50G"
    ip        = "10.69.1.10"
    gateway   = "10.69.1.1"
    pool      = "infrastructure"
    node      = "pve"
    template  = "ubuntu-cloud-template"
    tags      = ["kubernetes", "tofu-managed"]
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

State location: `s3://ullr-backups/opentofu/stacks/compute/compute.tfstate`

## Deploy

```bash
tofu init -backend-config=../_shared/backend.tfvars
tofu plan
tofu apply
```

## Notes

- VMs are created from cloud-init enabled templates
- SSH keys and passwords are injected via cloud-init
- VMs are automatically assigned to Proxmox resource pools
- Tags help identify Terraform-managed resources
