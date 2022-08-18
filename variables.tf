variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "service_account" {
  type = string
}

variable "vpc" {
  type = string
}

variable "subnet" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "node_pool" {
  type = string
}

variable "autoscaling_cpu" {
  type = number
}

variable "autoscaling_memory" {
  type = number
}

variable "autoscaling_min_node_count" {
  type = number
}

variable "autoscaling_max_node_count" {
  type = number
}

variable "autoscaling_machine_type" {
  type = string
}

variable "external_address" {
  type = string
}

variable "address_secret" {
  type = string
}

variable "dns_zone" {
  type = string
}

variable "ci_dns_record_set" {
  type = string
}

variable "monitoring_dns_record_set" {
  type = string
}

variable "argocd_namespace" {
  type = string
}

variable "argocd_chart_version" {
  type = string
}

variable "cert_manager_namespace" {
  type = string
}

variable "cert_chart_version" {
  type = string
}

variable "cert_app_version" {
  type = string
}

variable "external_secrets_namespace" {
  type = string
}

variable "external_secrets_version" {
  type = string
}

variable "gcpsm_secret_store" {
  type = string
}

variable "gcp_secret_sa" {
  type = string
}

variable "gcp_secret_sa_credentials" {
  type = string
}

variable "ip_secret_key" {
  type = string
}
