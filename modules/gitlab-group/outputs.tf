output "group_id" {
  description = "The ID of the group"
  value       = gitlab_group.this.id
}

output "full_path" {
  description = "The full path of the group"
  value       = gitlab_group.this.full_path
}

output "web_url" {
  description = "Web URL of the group"
  value       = gitlab_group.this.web_url
}