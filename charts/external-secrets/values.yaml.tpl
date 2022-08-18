external-secrets:
  installCRDs: true
cross-external-secrets:
  esNamespace: ${es_namespace}
  gcpsmSecretStore: ${gcpsm_secret_store}
  gcpSecretSA: ${gcp_secret_sa}
  gcpSecretSACredentials: ${gcp_secret_sa_credentials}
  projectID: ${project_id}
  addressSecret: ${address_secret}
  ipSecretKey: ${ip_secret_key}
  certNamespace: ${cert_namespace}
