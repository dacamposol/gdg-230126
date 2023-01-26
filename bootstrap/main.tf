terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 1.13.0"
    }

    k8s = {
      source  = "banzaicloud/k8s"
      version = ">= 0.8.0"
    }
  }
}

# == Provider ==

provider "kubernetes" {
  config_path = "${path.module}/assets/kubeconfig"
}

provider "k8s" {
  config_path = "${path.module}/assets/kubeconfig"
}

provider "vault" {
  namespace = ""
}