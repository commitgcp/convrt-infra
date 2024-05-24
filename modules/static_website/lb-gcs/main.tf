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
  name        = var.backend_name == null ? "backend-${var.bucket}" : var.backend_name
  bucket_name = var.bucket
  enable_cdn  = var.cdn.enable
  project     = var.project_id
  compression_mode        = "AUTOMATIC"

  dynamic "cdn_policy" {
    for_each = var.cdn.enable ? [var.cdn] : []
    content {
      cache_mode        = cdn_policy.value.cache_mode
      client_ttl        = cdn_policy.value.client_ttl
      default_ttl       = cdn_policy.value.default_ttl
      max_ttl           = cdn_policy.value.max_ttl
      negative_caching  = cdn_policy.value.negative_caching
      serve_while_stale = cdn_policy.value.serve_while_stale
      request_coalescing = cdn_policy.value.request_coalescing
    }
  }
}

resource "google_compute_url_map" "default" {
  count           = var.ssl.enable ? 0 : 1
  name            = var.http_url_map == null ? "http-lb-url-map-${var.bucket}" : var.http_url_map
  project         = var.project_id
  default_service    =  google_compute_backend_bucket.default.id
}

resource "google_compute_url_map" "redirect" {
  count           = var.ssl.enable ? 1 : 0
  name            = var.http_url_map == null ? "http-lb-url-map-${var.bucket}" : var.http_url_map
  project         = var.project_id

  default_url_redirect {
      https_redirect         = true
      redirect_response_code = "MOVED_PERMANENTLY_DEFAULT" 
      strip_query            = false
  }
}

resource "google_compute_url_map" "https" {
  count            = var.ssl.enable ? 1 : 0
  name            = var.https_url_map == null ? "https-lb-url-map-${var.bucket}" : var.https_url_map
  project         = var.project_id
  default_service = google_compute_backend_bucket.default.id
}

resource "google_compute_target_http_proxy" "default" {
  name    = var.http_target_proxy == null ? "http-lb-proxy-${var.bucket}" : var.http_target_proxy
  project = var.project_id
  url_map = var.ssl.enable ? google_compute_url_map.redirect[0].id : google_compute_url_map.default[0].id
}

resource "google_compute_target_https_proxy" "default" {
  count            = var.ssl.enable ? 1 : 0
  name             = var.https_target_proxy == null ? "https-lb-proxy-${var.bucket}" : var.https_target_proxy
  project          = var.project_id
  url_map          = google_compute_url_map.https[0].id
  ssl_certificates = var.ssl.certificates
}

#######################
### Forwarding rule ###
#######################
resource "google_compute_global_forwarding_rule" "default" {
  name                  = var.http_forwarding_rule_name == null ? "http-lb-forwarding-rule-${var.bucket}" : var.http_forwarding_rule_name
  project               = var.project_id
  ip_protocol           = "TCP"
  load_balancing_scheme = var.load_balancing_scheme
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.lb_static_ip.id
}

resource "google_compute_global_forwarding_rule" "https" {
  count                 = var.ssl.enable ? 1 : 0
  name                  = var.https_forwarding_rule_name == null ? "https-lb-forwarding-rule-${var.bucket}" : var.https_forwarding_rule_name
  project               = var.project_id
  ip_protocol           = "TCP"
  load_balancing_scheme = var.load_balancing_scheme
  port_range            = "443"
  target                = google_compute_target_https_proxy.default[0].id
  ip_address            = google_compute_global_address.lb_static_ip.id
}
