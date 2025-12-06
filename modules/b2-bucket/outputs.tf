output "bucket_name" {
  description = "Name of the bucket"
  value       = b2_bucket.this.bucket_name
}

output "bucket_id" {
  description = "ID of the bucket"
  value       = b2_bucket.this.bucket_id
}

output "key_id" {
  description = "Application key ID"
  value       = b2_application_key.this.application_key_id
}

output "application_key" {
  description = "Application key"
  value       = b2_application_key.this.application_key
  sensitive   = true
}

output "s3_endpoint" {
  description = "S3-compatible endpoint"
  value       = "s3.${var.region}.backblazeb2.com"
}