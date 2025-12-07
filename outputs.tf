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

# Cloudflare Tunnel Outputs
output "tunnels" {
  description = "All tunnel details"
  value = {
    for name, tunnel in module.cloudflare_tunnels : name => {
      tunnel_id    = tunnel.tunnel_id
      tunnel_cname = tunnel.tunnel_cname
      hostnames    = tunnel.hostnames
    }
  }
}

output "tunnel_tokens" {
  description = "Tunnel tokens for cloudflared containers"
  value = {
    for name, tunnel in module.cloudflare_tunnels : name => tunnel.tunnel_token
  }
  sensitive = true
}

# Cloudflare Access Outputs
output "access_apps" {
  description = "All Access application details"
  value = {
    for name, app in module.cloudflare_access : name => {
      application_id = app.application_id
      domain         = app.application_domain
    }
  }
}