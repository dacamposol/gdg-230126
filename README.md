# Maximizing Security and Control in GitOps

## Tasks

1. Have a Kubernetes cluster and put `kubeconfig` under the `/bootstrap/assets` folder
2. Create a Development Vault Server 
```shell
$ vault server -dev -dev-root-token-id="education"
```
3. Export your new Vault address to the shell
4. Initialize your infrastructure
```shell
$ terraform init -upgrade
$ terraform apply
```
5. Check your infrastructure (`k9s`, `kubectl`, Lens...)
