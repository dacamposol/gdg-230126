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
* Enter the token: "mytoken"
* Enter the url: http://127.0.0.1:8200
* Enter Terraform perform actions confirmation: yes

Clear the directory stack
```shell
popd
```
### 5. Check your infrastructure (`minikube`,`k9s`, `kubectl`, Lens...)
With ArgoCD
or Openlens
or kubectl

### 5.a show namespaces
```shell
kubectl get namespaces
```
Output:
````console
NAME              STATUS   AGE
apps-system       Active   14m
argocd            Active   14m
default           Active   99d
kube-node-lease   Active   99d
kube-public       Active   99d
kube-system       Active   99d
secrets-system    Active   13m
````

Show Secrets
```shell
kubectl -n secrets-system get all
```
Output:
```
NAME                                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/external-secrets-78986ddfdf                   1         1         1       14m
replicaset.apps/external-secrets-cert-controller-79688fbc89   1         1         1       14m
replicaset.apps/external-secrets-webhook-887d856fb            1         1         1       14m
```
### 6. Issue
An Output of issue can be found at `Output.md`
[Execution log](Output.md)

There is also Warning from "externalsecret-validate" with message "ca cert not yet ready" from object `
validating-webhook-configuration`

### 7. Stop and clean up all
#### 7.a kill vault server
```shell
pkill vault;
ps aux | grep vault | grep -v grep
```

#### 7.b clean up k8s
##### 7.b.1. remove the finalizer from "argocd"
```shell
kubectl get namespace argocd -o json >tmp.json;
```

##### 7.b.2. Install jq
```shell
brew install jq
```

##### 7.b.3. Replace the finalizer values 
```shell
(jq '.spec.finalizers = []' < tmp.json) > new_tmp.json
```
Reference:
* redirect file to jq: https://stackoverflow.com/questions/53280090/parse-error-invalid-numeric-literal-at-line-2-column-0/53280264#53280264
* sed is only for text replacement https://www.cyberciti.biz/faq/how-to-use-sed-to-find-and-replace-text-in-files-in-linux-unix-shell/

##### 7.b.4. patch with forwarding
1. Open the proxy from a separate terminal
```shell
kubectl proxy
```

2. Call the curl api to remove the finalizers on the argocd namespace
```
curl -k -H "Content-Type: application/json" -X PUT --data-binary @new_tmp.json http://127.0.0.1:8001/api/v1/namespaces/argocd/finalize
```

The pattern used is:
```
curl -k -H "Content-Type: application/json" -X PUT --data-binary @tmp.json http://127.0.0.1:8001/api/v1/namespaces/[your-namespace]/finalize
````

<!-- this patch method doesn't work
2. Patch namespace
```shell
kubectl patch namespace argocd --patch '{"spec": {"finalizers":[]}}' 
```
if patch don't work

```
kubectl edit namespace argocd
```
replace
```
spec:
  finalizers:
  - kubernetes
with
spec:
  finalizers:  
```
-->

3. After change the finalizers of argocd namespace, remove all the namespace
```shell
kubectl delete namespace apps-system argocd secrets-system
```

4. terminate the kubectl proxy with `ctl + c`
5. remove the tmp.json files
```shell
rm tmp.json;
rm new_tmp.json
```