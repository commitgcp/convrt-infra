module "utils" {
  source = "terraform-google-modules/utils/google"
}

data "google_compute_network" "network" {
  project = var.project
  name    = var.network
}

data "google_compute_subnetwork" "subnetwork" {
  project = var.project
  name    = var.subnet
  region  = var.region
}

resource "google_compute_instance" "default" {
  name         = "${var.vm_name}-${module.utils.region_short_name_map[var.region]}"
  machine_type = var.vm_type
  zone         = var.zone
  project      = var.project

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = data.google_compute_network.network.self_link
    subnetwork = data.google_compute_subnetwork.subnetwork.self_link
  }
}