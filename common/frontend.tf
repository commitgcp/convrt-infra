################
### Frontend ###
################
module "frontend-dev" {
  source               = "../modules/static_website"
  project_id           = var.project_id
  bucket_name          = var.frontend_dev.bucket_name
  backend_name         = var.frontend_dev.backend_name
  bucket_location      = var.region
  bucket_storage_class = "STANDARD"
  bucket_versioning_enabled = true
  website_main_page_file    = var.frontend_dev.website_main_page_file
  website_not_found_page    = var.frontend_dev.website_main_page_file
  cors                      = var.frontend_dev.cors
  enable_lb                 = true
  cdn = {
    enable            = true
    cache_mode        = "CACHE_ALL_STATIC"
    client_ttl        = 3600
    default_ttl       = 3600
    max_ttl           = 86400
    negative_caching  = false
    serve_while_stale = 0
    request_coalescing = true
  }
  ssl = {
    enable       = false #true
    certificates = [] #var.frontend_dev.certificates
  }
}
