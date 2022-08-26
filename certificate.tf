resource "tls_private_key" "cross-key" {
  algorithm   = "RSA"
}

resource "tls_cert_request" "cross-key" {
  private_key_pem = tls_private_key.cross-key.private_key_pem

  dns_names = [
    var.cert_dns_name_wild,
  ]

  subject {
    common_name  = var.cert_common_name
    organization = var.org_name
  }
}

resource "google_privateca_ca_pool" "cross-pool" {
  name = "${var.org_name}-pool"
  location = var.region
  tier = "ENTERPRISE"
  project = var.project_id
  publishing_options {
    publish_ca_cert = true
    publish_crl = true
  }
  labels = {
    pool = "cross-pool"
  }
  issuance_policy {
    baseline_values {
      ca_options {
        is_ca = false
      }
      key_usage {
        base_key_usage {
          digital_signature = true
          key_encipherment = true
        }
        extended_key_usage {
          server_auth = true
        }
      }
    }
  }
}

resource "google_privateca_certificate_authority" "cross-ca" {
  certificate_authority_id = "cross-authority"
  location = var.region
  project = var.project_id
  pool = google_privateca_ca_pool.cross-pool.name
  config {
    subject_config {
      subject {
        organization = var.org_name
        common_name = var.cert_common_name
      }
    }
    x509_config {
      ca_options {
        is_ca = true
      }
      key_usage {
        base_key_usage {
          cert_sign = true
          crl_sign = true
        }
        extended_key_usage {
          server_auth = true
        }
      }
    }
  }
  type = "SELF_SIGNED"
  key_spec {
    algorithm = var.ca_cert_algorithm
  }
}

resource "google_privateca_certificate" "cross-cert" {
  pool = google_privateca_ca_pool.cross-pool.name
  certificate_authority = google_privateca_certificate_authority.cross-ca.certificate_authority_id
  project = var.project_id
  location = var.region
  lifetime = "860s"
  name = var.cert_name
  pem_csr = tls_cert_request.cross-key.cert_request_pem
}

output "privateca" {
  pem_certificate = google_privateca_certificate.cross-cert.pem_certificate
  pem_certificate_chain = google_privateca_certificate.cross-cert.pem_certificate_chain
}

resource "google_secret_manager_secret" "pem-certificate" {
  secret_id = var.pem_certificate_secret
  
  labels = {
    certificate = "public"
  }

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "pem-certificate-version" {
  secret = google_secret_manager_secret.pem-certificate.id
  secret_data = google_privateca_certificate.cross-cert.pem_certificate
}

#resource "google_secret_manager_secret" "pem-certificate-chain" {
#  secret_id = var.pem_certificate_chain_secret
#  
#  labels = {
#    certificate = "public"
#  }
#
#  replication {
#    automatic = true
#  }
#}
#
#resource "google_secret_manager_secret_version" "pem-certificate-chain-version" {
#  secret = google_secret_manager_secret.pem-certificate-chain.id
#  secret_data = google_privateca_certificate.cross-cert.pem_certificate_chain
#}
