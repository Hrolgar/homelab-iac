variable "bucket_name" {
  description = "Name for the B2 bucket (must be globally unique)"
  type        = string
}

variable "public" {
  description = "Whether the bucket is public"
  type        = bool
  default     = false
}

variable "days_to_keep_old_versions" {
  description = "Days to keep old file versions before deleting (null to keep forever)"
  type        = number
  default     = null
}

variable "key_capabilities" {
  description = "Capabilities for the application key"
  type        = list(string)
  default = [
    "listBuckets",
    "listFiles",
    "readFiles",
    "writeFiles",
    "deleteFiles"
  ]
}
variable "region" {
  description = "B2 region (e.g. us-west-004, eu-central-003)"
  type        = string
  default     = "us-west-004"
}

variable "tags" {
  description = "Tags to apply to the bucket"
  type        = map(string)
  default     = {}
}