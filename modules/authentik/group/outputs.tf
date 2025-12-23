output "id" {
  description = "The ID of the group"
  value       = authentik_group.this.id
}

output "name" {
  description = "The name of the group"
  value       = authentik_group.this.name
}
