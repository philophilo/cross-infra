resource "helm_release" "argocd" {
  depends_on = [
    kubernetes_namespace.argocd,
    helm_release.cross-external-secrets,
    helm_release.cross-cert-manager
  ]

  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = var.argocd_namespace
  version    = "4.10.6"

  values = [
    <<-EOF
    global:
      image:
        imagePullPolicy: Always
    server:
      name: cross-argocd
      ingress:
        enabled: true
        annotations:
          nginx.ingress.kubernetes.io/ssl-redirect: "true"
          cert-manager.io/cluster-issuer: ${var.cert_issuer_ref_name}
          nginx.ingress.kubernetes.io/proxy-ssl-verify: 'on'
          nginx.ingress.kubernetes.io/http2-push-preload: 'true'
          nginx.ingress.kubernetes.io/backend-protocol: HTTPS
        ingressClassName: "nginx"
        hosts:
          - ${var.cert_dns_argocd}
        paths:
          - path: /
        pathType: Prefix
        tls:
        - secretName: ${var.cert_secret_name}
          hosts:
            - ${var.cert_dns_argocd}
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
                key: ${var.jenkins_password_key}
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

}
