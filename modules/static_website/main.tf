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
  source     = "./lb-gcs"
  project_id = var.project_id
  bucket     = google_storage_bucket.website.name
  cdn        = var.cdn
  ssl        = var.ssl
  backend_name = var.backend_name
  http_forwarding_rule_name = var.http_forwarding_rule_name
  http_target_proxy = var.http_target_proxy
  http_url_map = var.http_url_map
  https_target_proxy = var.https_target_proxy
  https_forwarding_rule_name = var.https_forwarding_rule_name
  https_url_map = var.https_url_map
  load_balancing_scheme = var.load_balancing_scheme
}
