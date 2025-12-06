output "buckets" {
  description = "All bucket details"
  value = {
    for name, bucket in module.b2_buckets : name => {
      bucket_name = bucket.bucket_name
      bucket_id   = bucket.bucket_id
      s3_endpoint = bucket.s3_endpoint
      key_id      = bucket.key_id
    }
  }
}

output "bucket_keys" {
  description = "Application keys for all buckets"
  value = {
    for name, bucket in module.b2_buckets : name => bucket.application_key
  }
  sensitive = true
}