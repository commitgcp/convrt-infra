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