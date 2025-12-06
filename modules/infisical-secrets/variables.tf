variable "project_id" {
  description = "Infisical project/workspace ID"
  type        = string
}

variable "env_slug" {
  description = "Environment slug (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "folder_path" {
  description = "Folder path in Infisical"
  type        = string
  default     = "/"
}

variable "secrets" {
  description = "Map of secret names to values"
  type        = map(string)
}