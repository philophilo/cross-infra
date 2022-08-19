resource "helm_release" "cert-manager" {
  depends_on = [kubernetes_namespace.cert-manager, google_container_node_pool.node_pool]

  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = var.cert_manager_namespace
  version    = "v1.9.1"

  set {
    name  = "installCRDs"
    value = true
  }

  set {
    name  = "enable-certificate-owner-ref"
    value = true
  }

  set {
    name  = "featureGates"
    value = "AdditionalCertificateOutputFormats=true"
  }

  set {
    name  = "prometheus.enabled"
    value = false
  }

  set {
    name  = "webhook.extraArgs"
    value = "{--featureGates=\"AdditionalCertificateOutputFormats\"}"
  }
}
