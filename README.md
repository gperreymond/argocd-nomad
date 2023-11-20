# ARGOCD NOMAD

```sh
$ .wtf/install-dependencies.sh
$ .wtf/start-cluster.sh
$ .wtf/prepare.sh
$ docker network inspect -f '{{.IPAM.Config}}' kind
$ kubectl apply --filename manifests/000-metallb-system.yaml
$ kubectl apply --filename manifests/001-datacenter-system.yaml
$ kubectl apply --filename manifests/002-hashistack-system.yaml
```

* https://developer.hashicorp.com/consul/docs/k8s/annotations-and-labels
* https://github.com/VictoriaMetrics/helm-charts/tree/master/charts
* https://artifacthub.io/packages/helm/vector/vector