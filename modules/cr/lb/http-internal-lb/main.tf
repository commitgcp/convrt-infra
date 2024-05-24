data "google_compute_network" "default" {
  name = var.network
}

data "google_compute_subnetwork" "default" {
  name   = var.subnetwork
  region = var.region
}

# Reserved internal address
resource "google_compute_address" "default" {
  name         = "${var.service}-address"
  provider     = google-beta
  subnetwork   = data.google_compute_subnetwork.default.id
  address_type = "INTERNAL"
  region       = var.region
  purpose      = "SHARED_LOADBALANCER_VIP"
}

resource "google_compute_region_network_endpoint_group" "cloudrun_neg" {
  name                  = "cloudrun-neg-${var.service}"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = var.service
  }
}

resource "google_compute_region_backend_service" "default" {
  provider              = google-beta
  project               = var.project
  region                = var.region
  name                  = "lb-${var.service}-backend-default"
  protocol              = "HTTP"
  load_balancing_scheme = "INTERNAL_MANAGED"

  backend {
    group          = google_compute_region_network_endpoint_group.cloudrun_neg.id
    balancing_mode = "UTILIZATION"
  }
}

resource "google_compute_region_url_map" "default" {
  project         = var.project
  name            = "lb-${var.service}-url-map"
  region          = var.region
  default_service = google_compute_region_backend_service.default.self_link
}

resource "google_compute_region_target_http_proxy" "default" {
  name    = "${var.service}-http-proxy"
  region  = var.region
  url_map = google_compute_region_url_map.default.id
  project = var.project
}

# Regional forwarding rule
resource "google_compute_forwarding_rule" "redirect" {
  name                  = "lb-${var.service}"
  region                = var.region
  ip_protocol           = "TCP"
  ip_address            = google_compute_address.default.id
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_range            = var.lb_port
  target                = google_compute_region_target_http_proxy.default.id
  network               = data.google_compute_network.default.id
  subnetwork            = data.google_compute_subnetwork.default.id
}