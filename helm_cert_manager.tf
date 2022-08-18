resource "helm_release" "cert-manager" {
  depends_on = [kubernetes_namespace.cert-manager]

  name = "cert-manager"
  # repository = "https://charts.jetstack.io"
  chart     = "./helm/cert-manager"
  namespace = var.cert_manager_namespace

  values = [
    templatefile(
      "${path.module}/helm/cert-manager/values.yaml.tpl",
      {
        "cert_chart_version" = var.cert_chart_version
        "cert_app_version"   = var.cert_app_version
      }
    )
  ]

  set {
    name  = "webhook.extraArgs"
    value = "{--featureGates=\"AdditionalCertificateOutputFormats\"}"
  }
}
