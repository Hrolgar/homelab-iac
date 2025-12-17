output "secret_names" {
  description = "Names of created secrets"
  value       = keys(var.secrets)
}

output "secrets" {
  description = "Full secret objects indexed by secret name"
  value       = infisical_secret.this
  sensitive   = true
}
