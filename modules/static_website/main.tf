##############
### BUCKET ###
##############
resource "google_storage_bucket" "website" {
  project                  = var.project_id
  name                     = var.bucket_name
  location                 = var.bucket_location
  force_destroy            = false
  storage_class            = var.bucket_storage_class
  labels                   = var.bucket_labels
  public_access_prevention = var.bucket_public ? "inherited" : "enforced"

  versioning {
    enabled = var.bucket_versioning_enabled
  }
  website {
    main_page_suffix = var.website_main_page_file
    not_found_page   = var.website_not_found_page
  }

  dynamic "cors" {
    for_each = var.cors == null ? [] : [var.cors]
    content {
      origin          = cors.value.origin
      method          = cors.value.method
      response_header = cors.value.response_header
      max_age_seconds = cors.value.max_age_seconds
    }
  }
}

# Make bucket public
resource "google_storage_bucket_iam_member" "public" {
  count  = var.bucket_public ? 1 : 0
  bucket = google_storage_bucket.website.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

#####################
### LOAD BALANCER ###
#####################
module "gcs-lb-cdn" {
  source                     = "./lb-external"
  project_id                 = var.project_id
  bucket                     = google_storage_bucket.website.name
  cdn                        = var.cdn
  ssl                        = var.ssl
  forwarding_rule_name_https = var.forwarding_rule_name_https
  forwarding_rule_name       = var.forwarding_rule_name
  target_http_proxy_name     = var.target_http_proxy_name
  target_https_proxy_name    = var.target_https_proxy_name
  url_map_name               = var.url_map_name
  url_map_https              = var.url_map_https
}
