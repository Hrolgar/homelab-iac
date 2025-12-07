terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

# Access Application - defines what's being protected
resource "cloudflare_zero_trust_access_application" "this" {
  account_id       = var.account_id
  name             = var.app_name
  domain           = "${var.subdomain}.${var.domain}"
  type             = "self_hosted"
  session_duration = var.session_duration

  # Optional settings
  auto_redirect_to_identity  = var.auto_redirect_to_identity
  skip_interstitial          = var.skip_interstitial
  http_only_cookie_attribute = true
  same_site_cookie_attribute = "lax"

  # Inline policy for v5 provider
  policies = [
    {
      name       = "${var.app_name}-policy"
      decision   = "allow"
      precedence = 1
      include = [
        {
          login_method = {
            id = var.github_idp_id
          }
        }
      ]
    }
  ]
}