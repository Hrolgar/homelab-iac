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

output "access_apps" {
  description = "All Access application details"
  value = {
    for name, app in module.cloudflare_access : name => {
      application_id = app.application_id
      domain         = app.application_domain
    }
  }
}

output "github_repos" {
  description = "All GitHub repository details"
  value = {
    for name, repo in module.github_repos : name => {
      url       = repo.html_url
      ssh_url   = repo.ssh_clone_url
      https_url = repo.http_clone_url
    }
  }
}

output "proxmox_vms" {
  description = "All Proxmox VM details"
  value = {
    for name, vm in module.proxmox_vms : name => {
      vm_id      = vm.vm_id
      ip_address = vm.ip_address
      mac        = vm.mac_address
    }
  }
}

output "proxmox_pools" {
  description = "All Proxmox pools"
  value = {
    for name, pool in module.proxmox_pools : name => pool.pool_id
  }
}


output "gitlab_groups" {
  value = {
    for name, group in module.gitlab_groups : name => {
      group_id  = group.group_id
      full_path = group.full_path
      web_url   = group.web_url
    }
  }
}

output "gitlab_projects" {
  value = {
    for name, project in module.gitlab_projects : name => {
      project_id = project.project_id
      web_url    = project.web_url
      ssh_url    = project.ssh_url_to_repo
      http_url   = project.http_url_to_repo
    }
  }
}