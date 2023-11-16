# ARGOCD NOMAD

```sh
$ .wtf/install-dependencies.sh
$ .wtf/start-cluster.sh
$ .wtf/prepare.sh
$ kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.yaml
$ kubectl apply --filename manifests/001-datacenter-system.yaml
$ kubectl apply --filename manifests/002-nomad-system.yaml
```
