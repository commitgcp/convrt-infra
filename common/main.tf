###############
### General ###
###############
locals {
  api = [
    "sqladmin.googleapis.com",
    "run.googleapis.com",
    "artifactregistry.googleapis.com"
  ]
}

resource "google_project_service" "api" {
  for_each = toset(local.api)
  service  = each.key
  project  = var.project_id

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

#################################
### Cloud Storage ###############
#################################
module "gcs_buckets" {
  source     = "terraform-google-modules/cloud-storage/google"
  version    = "~> 6.0"
  project_id = var.project_id
  location   = var.region
  names      = var.bucket_names

  prefix          = ""
  set_admin_roles = false
  #admins = ["group:foo-admins@example.com"]
  #versioning = {
  #  first = true
  #}
  #bucket_admins = {
  #  second = "user:spam@example.com,user:eggs@example.com"
  #}
}

################################
#### Cloud Storage with CDN ####
################################
module "buckets_with_cdn" {
  source               = "../modules/terraform-gcp-cdn-bucket"
  for_each = { for obj in var.buckets_for_cdn : obj.name => obj }

  name                 = each.value.name
  bucket_name          = each.value.name
  project              = var.project_id
  region               = var.region
  ssl = {
    enable  = each.value.ssl.enable
    domains = each.value.ssl.domains
  }
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
}
