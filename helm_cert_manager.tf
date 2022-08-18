resource "helm_release" "cert-manager" {
  depends_on = [kubernetes_namespace.cert-manager]

  name = "cert-manager"
  # repository = "https://charts.jetstack.io"
  chart             = "./charts/cert-manager"
  namespace         = var.cert_manager_namespace
  dependency_update = true

  values = [
    <<-EOF
    cert-manager:
      installCRDs: true
      enable-certificate-owner-ref: true
      featureGates: "AdditionalCertificateOutputFormats=true"
      prometheus:
        enabled: false
    EOF
  ]

  set {
    name  = "webhook.extraArgs"
    value = "{--featureGates=\"AdditionalCertificateOutputFormats\"}"
  }
}
