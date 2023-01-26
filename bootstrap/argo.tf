# === ArgoCD ===

## Namespace

resource "kubernetes_namespace" "argo" {
  metadata {
    name = var.argo_cd_namespace
  }
}

## Resources

data "http" "install" {
  url = "https://raw.githubusercontent.com/argoproj/argo-cd/v${var.argo_cd_version}/manifests/install.yaml"
}

locals {
  manifests = split("\n---\n", data.http.install.response_body)
}

resource "k8s_manifest" "argo" {
  count = length(local.manifests)

  content = local.manifests[count.index]
  namespace = var.argo_cd_namespace
  depends_on = [
    kubernetes_namespace.argo
  ]
}

resource "k8s_manifest" "apps-infra" {
  content = <<-EOF
            apiVersion: argoproj.io/v1alpha1
            kind: Application
            metadata:
              name: infra
              namespace: ${var.argo_cd_namespace}
              finalizers:
              - resources-finalizer.argocd.argoproj.io
            spec:
              destination:
                namespace: ${var.argo_cd_namespace}
                server: "https://kubernetes.default.svc"
              project: default
              source:
                path: ${var.gitops_bootstrap}
                repoURL: ${var.gitops_monorepo}
                targetRevision: HEAD
              syncPolicy:
                automated:
                  prune: true
            EOF
  namespace = var.argo_cd_namespace
  depends_on = [
    k8s_manifest.argo
  ]
}