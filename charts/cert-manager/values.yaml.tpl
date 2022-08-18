cert-manager:
  chart_version: ${ cert_chart_version }
  app_version: ${ cert_app_version }
  installCRDs: true
  enable-certificate-owner-ref: true
  featureGates: "AdditionalCertificateOutputFormats=true"
  prometheus:
    enabled: false
