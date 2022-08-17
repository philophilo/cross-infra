resource "google_compute_network" "network" {
  name                    = var.vpc
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name                     = var.subnet
  ip_cidr_range            = var.subnet_cidr
  region                   = var.region
  network                  = google_compute_network.network.self_link
  private_ip_google_access = true
}
