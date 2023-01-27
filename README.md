# Maximizing Security and Control in GitOps

## Tasks

### 1. Have a Kubernetes cluster and put `kubeconfig` under the `/bootstrap/assets` folder.

### 1.a (optional) play with your docker desktop and minikube
Get the context of kubernetes
```shell
kubectl config get-contexts
```
Use context of docker desktop
```shell
kubectl config use-context docker-desktop
```
Get k8s nodes
```shell
kubectl get nodes
```
view the current config
```shell
kubectl config view
```

Note:

By default, on Mac and Linux, the `kubeconfig` file is available as `config` at the path `$HOME/.kube/`

### 1.b create a simlink instead of copy
```shell
ln -s ${HOME}/.kube/config ./bootstrap/assets/kubeconfig 
```

### 2.a Create a Development Vault Server
Install vault binary from Homebrew
```shell
brew install vault
```
Reference:
* https://www.vaultproject.io/

Outputs:
```console
To restart vault after an upgrade:
  brew services restart vault
  Or, if you don't want/need a background service you can just run:
  /opt/homebrew/opt/vault/bin/vault server -dev
  ==> Summary
  🍺  /opt/homebrew/Cellar/vault/1.12.2: 8 files, 202.4MB
  ==> Running `brew cleanup vault`...
```

### 2.b Start Vault Server in Dev mode
```shell
vault server -dev -dev-root-token-id="education"
```

### 3. Export your new Vault address to the shell
```shell
export VAULT_ADDR='http://127.0.0.1:8200'
```
check the status, before this the `VAULT_ADDR` must be exported
```shell
vault status
```
### 4. Initialize your infrastructure
Homebrew install terraform
```shell
brew install terraform
```
Reference:
* https://www.terraform.io/

Output:
```console
==> Running `brew cleanup terraform`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
```

```shell
pushd ./bootstrap;
terraform init -upgrade;
popd
```

```shell
pushd ./bootstrap;
terraform apply;
```
Enter the token: "mytoken"
Enter the url: http://127.0.0.1:8200
Enter Terraform perform actions confirmation: yes
### 5. Check your infrastructure (`minikube`,`k9s`, `kubectl`, Lens...)

### 6. Issue
An Output of issue can be found at `Output.md`
[Execution log](Output.md)

There is also Warning from "externalsecret-validate" with message "ca cert not yet ready"
