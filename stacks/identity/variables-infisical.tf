variable "infisical_env_slug" {
  description = "Infisical environment slug (e.g., 'prod', 'dev')"
  type        = string
  default     = "prod"
}


/// INFISICAL VARIABLES ///

variable "infisical_host" {
  type = string
}

variable "infisical_project_id" {
  type = string
}

variable "infisical_client_id" {
  type      = string
  sensitive = true
}

variable "infisical_client_secret" {
  type      = string
  sensitive = true
}
