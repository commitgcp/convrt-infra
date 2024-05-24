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