terraform {
  backend "gcs" {
    bucket = "convrt-all-projects-tf-state"
    prefix = "dev-state/dev"
  }
}
