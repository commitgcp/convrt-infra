####################
### LB Static IP ###
####################
resource "google_compute_global_address" "lb_static_ip" {
  name    = "ip-${var.bucket}"
  project = var.project_id
}

###############
### Backend ###
###############
resource "google_compute_backend_bucket" "default" {
  name        = "backend-${var.bucket}"
  bucket_name = var.bucket
  enable_cdn  = var.cdn.enable
  project     = var.project_id

  dynamic "cdn_policy" {
    for_each = var.cdn.enable ? [var.cdn] : []
    content {
      cache_mode        = cdn_policy.value.cache_mode
      client_ttl        = cdn_policy.value.client_ttl
      default_ttl       = cdn_policy.value.default_ttl
      max_ttl           = cdn_policy.value.max_ttl
      negative_caching  = cdn_policy.value.negative_caching
      serve_while_stale = cdn_policy.value.serve_while_stale
    }
  }
}

resource "google_compute_url_map" "default" {
  name    = var.url_map_name
  project = var.project_id
  #default_service = google_compute_backend_bucket.default.id

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }


  lifecycle {
    ignore_changes = [
      description
    ]
  }
}

resource "google_compute_url_map" "https" {
  name            = var.url_map_https
  project         = var.project_id
  default_service = google_compute_backend_bucket.default.id
}

resource "google_compute_target_http_proxy" "default" {
  name    = var.target_http_proxy_name
  project = var.project_id
  url_map = google_compute_url_map.default.id
}

resource "google_compute_target_https_proxy" "default" {
  count   = var.ssl.enable ? 1 : 0
  name    = var.target_https_proxy_name
  project = var.project_id
  url_map = google_compute_url_map.https.id
  ssl_certificates = [
    google_compute_managed_ssl_certificate.default[0].id
  ]
}

#######################
### Forwarding rule ###
#######################
resource "google_compute_global_forwarding_rule" "default" {
  name                  = var.forwarding_rule_name
  project               = var.project_id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.lb_static_ip.id
}

resource "google_compute_global_forwarding_rule" "https" {
  count                 = var.ssl.enable ? 1 : 0
  name                  = var.forwarding_rule_name_https
  project               = var.project_id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443"
  target                = google_compute_target_https_proxy.default[0].id
  ip_address            = google_compute_global_address.lb_static_ip.id
}

resource "google_compute_managed_ssl_certificate" "default" {
  count    = var.ssl.enable && length(var.ssl.domains) > 0 ? 1 : 0
  name     = "https-lb-cert-${var.bucket}"
  project  = var.project_id
  provider = google-beta
  managed {
    domains = var.ssl.domains
  }
}
