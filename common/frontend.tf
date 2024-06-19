################
### Frontend ###
################
module "frontend-dev" {
  source                     = "../modules/static_website"
  project_id                 = var.project_id
  bucket_name                = var.frontend_dev.bucket_name
  backend_name               = var.frontend_dev.backend_name
  bucket_location            = var.region
  bucket_storage_class       = "STANDARD"
  bucket_versioning_enabled  = true
  website_main_page_file     = var.frontend_dev.website_main_page_file
  website_not_found_page     = var.frontend_dev.website_main_page_file
  cors                       = var.frontend_dev.cors
  enable_lb                  = true
  forwarding_rule_name_https = var.frontend_dev.forwarding_rule_name_https
  forwarding_rule_name       = var.frontend_dev.forwarding_rule_name
  target_https_proxy_name    = var.frontend_dev.target_https_proxy_name
  target_http_proxy_name     = var.frontend_dev.target_http_proxy_name
  url_map_name               = var.frontend_dev.url_map_name
  url_map_https              = var.frontend_dev.url_map_https
  cdn = {
    enable             = true
    cache_mode         = "CACHE_ALL_STATIC"
    client_ttl         = 3600
    default_ttl        = 3600
    max_ttl            = 86400
    negative_caching   = false
    serve_while_stale  = 0
    request_coalescing = true
  }
  ssl = var.frontend_dev.ssl
}

module "frontend-preprod" {
  source                     = "../modules/static_website"
  project_id                 = var.project_id
  bucket_name                = var.frontend_preprod.bucket_name
  backend_name               = var.frontend_preprod.backend_name
  bucket_location            = var.region
  bucket_storage_class       = "STANDARD"
  bucket_versioning_enabled  = true
  website_main_page_file     = var.frontend_preprod.website_main_page_file
  website_not_found_page     = var.frontend_preprod.website_main_page_file
  cors                       = var.frontend_preprod.cors
  enable_lb                  = true
  forwarding_rule_name_https = var.frontend_preprod.forwarding_rule_name_https
  forwarding_rule_name       = var.frontend_preprod.forwarding_rule_name
  target_https_proxy_name    = var.frontend_preprod.target_https_proxy_name
  target_http_proxy_name     = var.frontend_preprod.target_http_proxy_name
  url_map_name               = var.frontend_preprod.url_map_name
  url_map_https              = var.frontend_preprod.url_map_https
  cdn = {
    enable             = true
    cache_mode         = "CACHE_ALL_STATIC"
    client_ttl         = 3600
    default_ttl        = 3600
    max_ttl            = 86400
    negative_caching   = false
    serve_while_stale  = 0
    request_coalescing = true
  }
  ssl = var.frontend_preprod.ssl
}

module "frontend-prod" {
  source                     = "../modules/static_website"
  project_id                 = var.project_id
  bucket_name                = var.frontend_prod.bucket_name
  backend_name               = var.frontend_prod.backend_name
  bucket_location            = var.region
  bucket_storage_class       = "STANDARD"
  bucket_versioning_enabled  = true
  website_main_page_file     = var.frontend_prod.website_main_page_file
  website_not_found_page     = var.frontend_prod.website_main_page_file
  cors                       = var.frontend_prod.cors
  forwarding_rule_name_https = var.frontend_prod.forwarding_rule_name_https
  forwarding_rule_name       = var.frontend_prod.forwarding_rule_name
  target_https_proxy_name    = var.frontend_prod.target_https_proxy_name
  target_http_proxy_name     = var.frontend_prod.target_http_proxy_name
  url_map_name               = var.frontend_prod.url_map_name
  url_map_https              = var.frontend_prod.url_map_https
  enable_lb                  = true
  cdn = {
    enable             = true
    cache_mode         = "CACHE_ALL_STATIC"
    client_ttl         = 3600
    default_ttl        = 3600
    max_ttl            = 86400
    negative_caching   = false
    serve_while_stale  = 0
    request_coalescing = true
  }
  ssl = var.frontend_prod.ssl
}