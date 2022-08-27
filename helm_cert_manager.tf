resource "helm_release" "cert-manager" {
  depends_on = [kubernetes_namespace.cert-manager,
    google_container_node_pool.node_pool,
    helm_release.nginx_ingress
  ]

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
    name  = "featureGates"
    value = "AdditionalCertificateOutputFormats=true,"
  }

  set {
    name  = "extraArgs"
    value = format("{%s,%s,%s\\,%s}",
      "--enable-certificate-owner-ref=true",
      "--dns01-recursive-nameservers-only",
      "--dns01-recursive-nameservers=8.8.8.8:53",
      "1.1.1.1:53")
  }

  set {
    name  = "prometheus.enabled"
    value = false
  }

  set {
    name  = "webhook.extraArgs"
    value = "{--feature-gates=AdditionalCertificateOutputFormats=true}"
  }
}
