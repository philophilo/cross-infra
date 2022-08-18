resource "google_compute_address" "external-address" {
  name         = var.external_address
  address_type = "EXTERNAL"
  region       = var.region
}

data "google_compute_address" "cluster" {
  name = google_compute_address.external-address.name
}

data "google_dns_managed_zone" "zone" {
  name    = var.dns_zone
  project = var.project_id
}

output "external_ip" {
  value = data.google_compute_address.cluster.address
}

resource "google_dns_record_set" "ci-record-set" {
  name = "${var.ci_dns_record_set}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.zone.name

  rrdatas = [data.google_compute_address.cluster.address]
}

resource "google_dns_record_set" "monitoring-record-set" {
  name = "${var.monitoring_dns_record_set}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.zone.name

  rrdatas = [data.google_compute_address.cluster.address]
}

resource "google_secret_manager_secret" "address" {
  secret_id = var.address_secret

  labels = {
    network = "address"
  }

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "address-version" {
  secret      = google_secret_manager_secret.address.id
  secret_data = data.google_compute_address.cluster.address
}
