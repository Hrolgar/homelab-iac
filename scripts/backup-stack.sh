#!/bin/bash
# Backup current stack's terraform.tfvars to B2
# Usage: Run from within a stack directory: ../../scripts/backup-stack.sh

set -e

BUCKET="ullr-backups"
ENDPOINT="https://s3.eu-central-003.backblazeb2.com"
REGION="eu-central-003"

# Detect which stack we're in
CURRENT_DIR=$(basename "$PWD")
PARENT_DIR=$(basename "$(dirname "$PWD")")

if [ "$PARENT_DIR" != "stacks" ]; then
  echo "Error: This script must be run from within a stack directory (e.g., stacks/scm)"
  exit 1
fi

STACK_NAME="$CURRENT_DIR"

# Find all .tfvars files in current directory (excluding backend.tfvars)
TFVARS_FILES=$(find . -maxdepth 1 -name "*.tfvars" -type f ! -name "backend.tfvars" ! -name "infisical.auto.tfvars")

if [ -z "$TFVARS_FILES" ]; then
  echo "Error: No .tfvars files found in current directory"
  exit 1
fi

# Source backend credentials
if [ ! -f "../_shared/backend.tfvars" ]; then
  echo "Error: ../_shared/backend.tfvars not found"
  echo "Please create it with your B2 credentials"
  exit 1
fi

# Extract credentials from backend.tfvars
ACCESS_KEY=$(grep 'access_key' ../_shared/backend.tfvars | cut -d'"' -f2)
SECRET_KEY=$(grep 'secret_key' ../_shared/backend.tfvars | cut -d'"' -f2)

if [ "$ACCESS_KEY" == "your-b2-key-id" ] || [ "$SECRET_KEY" == "your-b2-application-key" ]; then
  echo "Error: Please configure your B2 credentials in ../_shared/backend.tfvars"
  exit 1
fi

# Check if B2 CLI is installed
if ! command -v b2 &> /dev/null; then
  echo "Error: B2 CLI is not installed"
  echo "Install it with: pip install b2 --user  (or pipx install b2)"
  exit 1
fi

echo "Backing up ${STACK_NAME} tfvars files to B2..."
echo ""

# Authorize B2
b2 authorize-account "$ACCESS_KEY" "$SECRET_KEY" > /dev/null 2>&1

# Upload each tfvars file
for file in $TFVARS_FILES; do
  filename=$(basename "$file")
  echo "  Uploading ${filename}..."
  b2 file upload "$BUCKET" "$file" "opentofu/stacks/${STACK_NAME}/tfvars/${filename}" --quiet
done

echo ""
echo "✓ Backup complete!"
echo "  Uploaded to: s3://${BUCKET}/opentofu/stacks/${STACK_NAME}/tfvars/"
