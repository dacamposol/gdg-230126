# === ArgoCD ===

variable argo_cd_version {
  description = "Value of the ArgoCD version to be deployed"
  type = string
  default = "2.5.8"
}

variable argo_cd_namespace {
  description = "Value of the Kubernetes namespace where to deploy ArgoCD resources"
  type = string
  default = "argocd"
}

# === GitOps ===

variable gitops_monorepo {
  description = "Value of the repository where all the different applications are defined"
  type = string
  default = "https://github.com/dacamposol/gdg-230126"
}

variable gitops_bootstrap {
  description = "Value of the path where is the App of Apps which sets the infrastructure"
  type = string
  default = "bootstrap"
}