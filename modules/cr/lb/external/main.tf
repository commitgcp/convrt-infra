resource "google_compute_region_network_endpoint_group" "cloudrun_neg" {
  project               = var.project
  name                  = "cloudrun-neg-${var.service}"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = var.service
  }
}

module "lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  #version = "~> 6.0"
  project = var.project
  name    = "lb-${var.service}"

  ssl                             = var.elb_config.ssl
  managed_ssl_certificate_domains = var.elb_config.managed_ssl_certificate_domains
  https_redirect                  = var.elb_config.https_redirect

  backends = {
    default = {
      description             = null
      enable_cdn              = var.elb_config.enable_cdn
      custom_request_headers  = null
      custom_response_headers = null
      security_policy         = null
      connection_draining_timeout_sec = 0

      log_config = {
        enable      = var.elb_config.log_config.enable
        sample_rate = var.elb_config.log_config.sample_rate
      }

      groups = [
        {
          group = google_compute_region_network_endpoint_group.cloudrun_neg.id
        }
      ]

      iap_config = {
        enable               = var.elb_config.iap_config.enable
        oauth2_client_id     = var.elb_config.iap_config.oauth2_client_id
        oauth2_client_secret = var.elb_config.iap_config.oauth2_client_secret
      }
    }
  }
}