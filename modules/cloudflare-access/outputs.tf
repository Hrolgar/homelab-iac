output "application_id" {
  description = "The Access application ID"
  value       = cloudflare_zero_trust_access_application.this.id
}

output "application_domain" {
  description = "The full domain of the protected application"
  value       = "${var.subdomain}.${var.domain}"
}
