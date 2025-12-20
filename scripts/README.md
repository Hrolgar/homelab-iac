# Scripts

Utility scripts for managing the homelab infrastructure.

## backup-tfvars.sh

Backs up all stack `terraform.tfvars` files to Backblaze B2 storage.

**Usage:**
```bash
./scripts/backup-tfvars.sh
```

**Requirements:**
- AWS CLI installed (`apt install awscli` or `brew install awscli`)
- `stacks/_shared/backend.tfvars` configured with B2 credentials

**What it backs up:**
- `stacks/foundation/terraform.tfvars` → `s3://ullr-backups/opentofu/stacks/tfvars/foundation.tfvars`
- `stacks/network/terraform.tfvars` → `s3://ullr-backups/opentofu/stacks/tfvars/network.tfvars`
- `stacks/compute/terraform.tfvars` → `s3://ullr-backups/opentofu/stacks/tfvars/compute.tfvars`
- `stacks/scm/terraform.tfvars` → `s3://ullr-backups/opentofu/stacks/tfvars/scm.tfvars`
- `stacks/_shared/infisical.auto.tfvars` → `s3://ullr-backups/opentofu/stacks/tfvars/_shared.tfvars`

**Note:** Run this script periodically to ensure your configuration is backed up, especially before making significant changes.
