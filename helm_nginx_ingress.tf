resource "helm_release" "nginx-ingress" {
  depends_on = [
    kubernetes_namespace.nginx-ingress,
    google_container_node_pool.node_pool
  ]

  name = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart = "ingress-nginx"
  namespace = var.ingress_namespace
  version = "4.2.1"
}
