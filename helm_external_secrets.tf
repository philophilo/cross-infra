resource "helm_release" "external-secrets" {
  depends_on = [kubernetes_namespace.external-secrets, google_container_node_pool.node_pool]

  name       = "external-secrets"
  namespace  = var.external_secrets_namespace
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "v0.5.9"

  set {
    name  = "installCRDs"
    value = true
  }

}

resource "helm_release" "reflector" {
  depends_on = [kubernetes_namespace.external-secrets, google_container_node_pool.node_pool]

  name       = "reflector"
  namespace  = var.external_secrets_namespace
  repository = "https://emberstack.github.io/helm-charts"
  chart      = "reflector"
  version    = "6.1.47"

}
