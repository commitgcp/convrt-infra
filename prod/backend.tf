terraform {
  backend "gcs" {
    bucket = "convrt-all-projects-tf-state"
    prefix = "prod-state"
  }
}
