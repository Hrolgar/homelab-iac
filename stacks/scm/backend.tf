terraform {
  backend "s3" {
    bucket = "ullr-backups"
    key    = "opentofu/stacks/scm/scm.tfstate"

    endpoints = {
      s3 = "https://s3.eu-central-003.backblazeb2.com"
    }
    region = "eu-central-003"

    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
}
