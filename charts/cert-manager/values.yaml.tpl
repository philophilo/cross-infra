cert-manager:
  installCRDs: true
  enable-certificate-owner-ref: true
  featureGates: "AdditionalCertificateOutputFormats=true"
  prometheus:
    enabled: false
cross-cert-manager:
  gcpSecretSA: ${gcp_secret_sa}
  certNamespace: ${cert_namespace}
  esNamespace: ${es_namespace}
  gcpSecretSACredentials: ${gcp_secret_sa_credentials}
  dnsServiceAccount: ${dns_service_account}
