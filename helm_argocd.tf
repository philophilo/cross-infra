resource "helm_release" "argocd" {
  depends_on = [
    kubernetes_namespace.argocd,
    helm_release.cross-external-secrets
  ]

  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = var.argocd_namespace
  version    = var.argocd_chart_version

  valued = [
    <<-EOF
    global:
      image:
        imagePullPolicy: Always
      ingress:
        enabled:
          enabled: true
          hosts:
            - ${var.cert_dns_argo}
    repoServer:
      extraContainers:
      - name: cmp
        command: [/var/run/argocd/argocd-cmp-server]
        image: busybox
        securityContext:
          runAsNonRoot: true
          runAsUser: 999
        env:
          - name: ADMIN_USERNAME
            valueFrom:
              secretKeyRef:
                name: ${replace(var.jenkins_username, "_", "-")}
                key: ${var.jenkins_username_key}
          - name: ADMIN_PASSWORD
            valueFrom:
              secretKeyRef:
                name: ${replace(var.jenkins_password, "_", "-")}
                key: ${var.jenkins_pasword_key}
        volumeMounts:
          - mountPath: /var/run/argocd
            name: var-files
          - mountPath: /home/argocd/cmp-server/plugins
            name: plugins
          - mountPath: /home/argocd/cmp-server/config/plugin.yaml
            subPath: plugin.yaml
            name: cmp-plugin
          - mountPath: /tmp
            name: tmp-dir
      volumes:
        - configMap:
            name: cmp-plugin
          name: cmp-plugin
    configs:
      secrets:
        argocdServerAdminPassword: "${var.argocd_password}"

    EOF
  ]

  set {
    name  = "dev.enabled"
    value = false
  }

}
