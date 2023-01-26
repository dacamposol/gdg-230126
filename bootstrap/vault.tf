resource "vault_namespace" "root" {
  path = "gdg"
}

resource "vault_mount" "cluster" {
  namespace = vault_namespace.root.path
  path = "application"
  type = "kv-v2"
}

resource "vault_mount" "common" {
  namespace = vault_namespace.root.path
  path = "common"
  type = "kv-v2"
}
