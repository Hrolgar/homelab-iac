variable "target_id" {
  description = "ID of the target (application, flow, etc.)"
  type        = string
}

variable "group_id" {
  description = "ID of the group to bind (mutually exclusive with user_id)"
  type        = string
  default     = null
}

variable "user_id" {
  description = "ID of the user to bind (mutually exclusive with group_id)"
  type        = number
  default     = null
}

variable "order" {
  description = "Order of the policy binding"
  type        = number
  default     = 0
}

variable "enabled" {
  description = "Whether the binding is enabled"
  type        = bool
  default     = true
}

variable "timeout" {
  description = "Timeout in seconds"
  type        = number
  default     = 30
}
