terraform {
  backend "gcs" {
    bucket = "convrt-all-projects-tf-state"
    prefix = "common-state/network"
  }
}
