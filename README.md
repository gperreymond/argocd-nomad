# ARGOCD NOMAD

### Installation

```sh
$ .wtf/install-dependencies.sh
# k8s clusters commands
$ .wtf/cluster/create.sh
$ .wtf/cluster/start.sh
$ .wtf/cluster/stop.sh
$ .wtf/cluster/delete.sh
# only after cluster "create"
$ .wtf/cluster/prepare.sh
# one by one
$ kubectl apply --filename manifests/000-traefik-system.yaml
$ kubectl apply --filename manifests/001-datacenter-system.yaml
$ kubectl apply --filename manifests/002-hashistack-system.yaml
$ kubectl apply --filename manifests/003-nomad.yaml
```
### Web URLs

* https://traefik.docker.localhost/dashboard/
* https://argocd.docker.localhost/
* https://victoria-metrics.docker.localhost/
* https://victoria-logs.docker.localhost/
* https://consul.docker.localhost/


### Documentations

* https://developer.hashicorp.com/consul/docs/k8s/annotations-and-labels
* https://github.com/VictoriaMetrics/helm-charts/tree/master/charts
* https://artifacthub.io/packages/helm/vector/vector