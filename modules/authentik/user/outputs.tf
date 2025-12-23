output "id" {
  description = "The ID of the user"
  value       = authentik_user.this.id
}

output "username" {
  description = "The username of the user"
  value       = authentik_user.this.username
}

output "name" {
  description = "The full name of the user"
  value       = authentik_user.this.name
}

output "email" {
  description = "The email of the user"
  value       = authentik_user.this.email
}
