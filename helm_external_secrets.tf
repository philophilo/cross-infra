resource "helm_release" "external-secrets" {
  depends_on = [kubernetes_namespace.external-secrets]

  name = "external-secrets"
  namespace = var.external_secrets_namespace
  chart = "./charts/external-secrets"
  dependency_update = true

  values = [
    <<-EOF
    external-secrets:
      installCRDs: true
      es_version: ${var.external_secrets_version}
    EOF
  ]
}
