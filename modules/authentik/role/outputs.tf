output "id" {
  description = "The UUID of the role"
  value       = authentik_rbac_role.this.id
}

output "name" {
  description = "The name of the role"
  value       = authentik_rbac_role.this.name
}
