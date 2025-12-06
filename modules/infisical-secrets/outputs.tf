output "secret_names" {
  description = "Names of created secrets"
  value       = keys(var.secrets)
}