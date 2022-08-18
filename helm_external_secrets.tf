resource "helm_release" "external-secrets" {
  depends_on = [kubernetes_namespace.external-secrets]

  name              = "external-secrets"
  namespace         = var.external_secrets_namespace
  chart             = "./charts/external-secrets"
  dependency_update = true

  values = [templatefile("${path.module}/charts/external-secrets/values.yaml.tpl",
      {
        "es_version" = var.external_secrets_version
      }
    )
  ]

  set {
    name  = "es_version"
    value = var.external_secrets_version
  }
}
