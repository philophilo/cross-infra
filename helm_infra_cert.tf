resource "helm_release" "cross-cert-manager" {
  depends_on = [
    kubernetes_namespace.cert-manager,
    google_container_node_pool.node_pool,
    helm_release.reflector,
    helm_release.cross-external-secrets,
    helm_release.cert-manager
  ]

  name              = "cross-cert-manager"
  chart             = "./charts/cross-cert-manager"
  namespace         = var.cert_manager_namespace
  dependency_update = true
  force_update      = true

  values = [templatefile("${path.module}/charts/cross-cert-manager/values.yaml.tpl",
    {
      "gcp_secret_sa"             = var.gcp_secret_sa
      "cert_namespace"            = var.cert_manager_namespace
      "es_namespace"              = var.external_secrets_namespace
      "gcp_secret_sa_credentials" = var.gcp_secret_sa_credentials
      "dns_service_account"       = var.service_account_base64
      "cert_name"                 = var.cert_name
      "cert_secret_name"          = var.cert_secret_name
      "cert_issuer_ref_name"      = var.cert_issuer_ref_name
      "cert_common_name"          = var.cert_common_name
      "cert_dns_name"             = var.cert_dns_name
      "cert_dns_name_wild"        = var.cert_dns_name_wild
      "ci_namespace"              = var.ci_namespace
      "logging_namespace"         = var.logging_namespace
      "project_id"                = var.project_id
      "acme_server"               = var.acme_server
      "acme_email"                = var.acme_email
      "acme_account_private_key"  = var.acme_account_private_key
    }
  )]
}

