terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.26.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.10.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }

  }
  required_version = ">= 0.14"
}
