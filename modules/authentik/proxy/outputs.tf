output "application_id" {
  value = authentik_application.this.id
}

output "application_uuid" {
  description = "The UUID of the application (for policy bindings)"
  value       = authentik_application.this.uuid
}

output "provider_id" {
  value = authentik_provider_proxy.this.id
}
