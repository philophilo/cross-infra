resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.argocd_namespace
  }
}

resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = var.cert_manager_namespace
  }
}

resource "kubernetes_namespace" "external-secrets" {
  metadata {
    name = var.external_secrets_namespace
  }
}

resource "kubernetes_namespace" "ci" {
  metadata {
    name = var.ci_namespace
  }
}

resource "kubernetes_namespace" "logging" {
  metadata {
    name = var.logging_namespace
  }
}
