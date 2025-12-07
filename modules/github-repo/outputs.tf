output "repo_name" {
  description = "Repository name"
  value       = github_repository.this.name
}

output "repo_full_name" {
  description = "Full repository name (owner/repo)"
  value       = github_repository.this.full_name
}

output "html_url" {
  description = "Repository URL"
  value       = github_repository.this.html_url
}

output "ssh_clone_url" {
  description = "SSH clone URL"
  value       = github_repository.this.ssh_clone_url
}

output "http_clone_url" {
  description = "HTTP clone URL"
  value       = github_repository.this.http_clone_url
}

output "node_id" {
  description = "Node ID (for GraphQL)"
  value       = github_repository.this.node_id
}