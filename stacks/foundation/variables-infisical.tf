// Variables for Infisical integration
variable "infisical_host" {
  description = "Infisical host URL"
  type        = string
}

variable "infisical_client_id" {
  description = "Infisical client ID for authentication"
  type        = string
  sensitive   = true
}
variable "infisical_client_secret" {
  description = "Infisical client secret for authentication"
  type        = string
  sensitive   = true
}

variable "infisical_project_id" {
  description = "Infisical project ID"
  type        = string
  sensitive   = true
}

variable "infisical_secrets" {
  description = "Map of secret groups to create in Infisical"
  type = map(object({
    env_slug    = string
    folder_path = string
    secrets     = map(string)
  }))
  default = {}
}

