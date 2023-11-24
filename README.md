# ARGOCD NOMAD

```sh
$ .wtf/install-dependencies.sh
$ .wtf/start-cluster.sh
# only after start-cluster
$ .wtf/prepare.sh
# one by one like that
$ kubectl apply --filename manifests/000-metallb-system.yaml
$ kubectl apply --filename manifests/001-datacenter-system.yaml
# The consul-server-consul-mesh-gateway service loadbalancer would have this ipv4 : 192.168.200.200
$ kubectl apply --filename manifests/002-hashistack-system.yaml
```

* https://developer.hashicorp.com/consul/docs/k8s/annotations-and-labels
* https://github.com/VictoriaMetrics/helm-charts/tree/master/charts
* https://artifacthub.io/packages/helm/vector/vector