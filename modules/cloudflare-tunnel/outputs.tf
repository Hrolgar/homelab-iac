output "tunnel_id" {
  description = "The tunnel ID"
  value       = cloudflare_zero_trust_tunnel_cloudflared.this.id
}

output "tunnel_name" {
  description = "The tunnel name"
  value       = cloudflare_zero_trust_tunnel_cloudflared.this.name
}

output "tunnel_token" {
  description = "The tunnel token for cloudflared (use in TUNNEL_TOKEN env var)"
  value       = data.cloudflare_zero_trust_tunnel_cloudflared_token.this.token
  sensitive   = true
}

output "tunnel_cname" {
  description = "The CNAME target for this tunnel"
  value       = "${cloudflare_zero_trust_tunnel_cloudflared.this.id}.cfargotunnel.com"
}

output "dns_records" {
  description = "Created DNS records"
  value = {
    for key, record in cloudflare_dns_record.tunnel_routes : key => {
      id      = record.id
      fqdn    = record.name
      content = record.content
    }
  }
}

output "hostnames" {
  description = "List of all hostnames configured for this tunnel"
  value       = [for hostname, route in var.routes : "${hostname}.${route.domain}"]
}
