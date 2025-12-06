output "tunnel_id" {
  description = "The tunnel ID"
  value       = var.tunnel_id
}

output "tunnel_name" {
  description = "The tunnel name"
  value       = var.tunnel_name
}

output "dns_records" {
  description = "Map of created DNS records"
  value = {
    for hostname, record in cloudflare_dns_record.tunnel_routes : hostname => {
      fqdn    = "${hostname}.${var.routes[hostname].domain}"
      zone_id = record.zone_id
    }
  }
}

output "hostnames" {
  description = "List of all hostnames configured for this tunnel"
  value       = [for hostname, route in var.routes : "${hostname}.${route.domain}"]
}
