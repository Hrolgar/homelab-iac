output "proxmox_ci_password" {
  value     = try(
    module.infisical_secrets["proxmox"].secrets["proxmox/vm_password"].value,
    null
  )
  sensitive = true
}

output "proxmox_ci_ssh_keys" {
  value     = try(
    module.infisical_secrets["proxmox"].secrets["proxmox/ssh_public_keys"].value,
    null
  )
  sensitive = true
}

# output "cloudflare_account_id" {
#   value     = module.infisical_secrets["cloudflare"].secrets["cloudflare/account_id"].value
#   sensitive = true
# }


output "cloudflare_github_idp_id" {
  value     = try(
    module.infisical_secrets["cloudflare"].secrets["cloudflare/github_idp_id"].value,
    null
  )
  sensitive = true
}
