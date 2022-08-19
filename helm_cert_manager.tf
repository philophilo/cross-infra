resource "helm_release" "cert-manager" {
  depends_on = [kubernetes_namespace.cert-manager, google_container_node_pool.node_pool]

  name = "cert-manager"
  chart             = "./charts/cert-manager"
  namespace         = var.cert_manager_namespace
  dependency_update = true

  values = [templatefile("${path.module}/charts/cert-manager/values.yaml.tpl",
    {
      "gcp_secret_sa" = var.gcp_secret_sa
      "cert_namespace" = var.cert_manager_namespace
      "es_namespace" = var.external_secrets_namespace
      "gcp_secret_sa_credentials" = var.gcp_secret_sa_credentials
      "dns_service_account" = var.service_account_base64
    }
  )]

  set {
    name  = "webhook.extraArgs"
    value = "{--featureGates=\"AdditionalCertificateOutputFormats\"}"
  }
}
