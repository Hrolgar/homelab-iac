variable "name" {
  description = "Name of the group"
  type        = string
}

variable "is_superuser" {
  description = "Whether the group has superuser privileges"
  type        = bool
  default     = false
}

variable "parent_group_id" {
  description = "ID of the parent group (optional)"
  type        = string
  default     = null
}

variable "user_ids" {
  description = "List of user IDs to add to this group"
  type        = list(number)
  default     = []
}

variable "role_ids" {
  description = "List of role UUIDs to assign to this group"
  type        = list(string)
  default     = []
}
