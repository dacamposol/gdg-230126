resource "kubernetes_namespace" "applications_namespace" {
  metadata {
    name = var.applications_namespace
  }
}

resource "kubernetes_secret" "vault_token" {
  metadata {
    name = var.vault_dev_token_secret
    namespace = var.applications_namespace
  }
  data = {
    token = var.vault_dev_token
  }
  depends_on = [
    kubernetes_namespace.applications_namespace
  ]
}