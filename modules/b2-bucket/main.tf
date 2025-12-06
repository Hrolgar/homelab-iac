terraform {
  required_providers {
    b2 = {
      source = "backblaze/b2"
    }
  }
}

resource "b2_bucket" "this" {
  bucket_name = var.bucket_name
  bucket_type = var.public ? "allPublic" : "allPrivate"
  

  default_server_side_encryption {
    mode      = "SSE-B2"
    algorithm = "AES256"
  }

  dynamic "lifecycle_rules" {
    for_each = var.days_to_keep_old_versions != null ? [1] : []
    content {
      file_name_prefix              = ""
      days_from_hiding_to_deleting  = var.days_to_keep_old_versions
      days_from_uploading_to_hiding = 0
    }
  }

  # dynamic "bucket_info" {
  #   for_each = length(var.tags) > 0 ? [1] : []
  #   content {
  #     tags = var.tags
  #   }
  # }
}

resource "b2_application_key" "this" {
  key_name     = "${var.bucket_name}-key"
  bucket_ids   = [b2_bucket.this.bucket_id]
  capabilities = var.key_capabilities
}
