resource "vault_mount" "cluster" {
  path = "application"
  type = "kv-v2"
}

resource "vault_mount" "common" {
  path = "common"
  type = "kv-v2"
}
