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

#####################
### Cloud Storage ###
#####################
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