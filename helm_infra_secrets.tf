resource "helm_release" "cross-external-secrets" {
  depends_on = [
    kubernetes_namespace.external-secrets,
    google_container_node_pool.node_pool,
    helm_release.external-secrets,
    helm_release.reflector
  ]

  name              = "cross-external-secrets"
  namespace         = var.external_secrets_namespace
  chart             = "./charts/cross-external-secrets"
  dependency_update = true

  values = [templatefile("${path.module}/charts/cross-external-secrets/values.yaml.tpl",
    {
      "es_namespace"              = var.external_secrets_namespace
      "gcpsm_secret_store"        = var.gcpsm_secret_store
      "gcp_secret_sa"             = var.gcp_secret_sa
      "gcp_secret_sa_credentials" = var.gcp_secret_sa_credentials
      "project_id"                = var.project_id
      "address_secret"            = var.address_secret
      "ip_secret_key"             = var.ip_secret_key
      "cert_namespace"            = var.cert_manager_namespace
      "jenkins_username"          = var.jenkins_username
      "jenkins_password"          = var.jenkins_password
      "argocd_namespace"          = var.argocd_namespace
    }
  )]

}
