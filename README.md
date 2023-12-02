# ARGOCD NOMAD

### Installation

```sh
$ .wtf/install-dependencies.sh
# cluster: create and start
$ .wtf/cluster/create.sh
# cluster: on/off
$ .wtf/cluster/start.sh
$ .wtf/cluster/stop.sh
# cluster: destroy/remove
$ .wtf/cluster/delete.sh
# only after cluster "create"
$ .wtf/cluster/prepare.sh # waiting for all argocd pods... (2 minutes)
$ kubectl apply --filename manifests/000-traefik-system.yaml
$ kubectl apply --filename manifests/001-datacenter-system.yaml
$ kubectl apply --filename manifests/002-hashistack-system.yaml # waiting for all consul pods... (4 minutes)
$ .wtf/consul/preprare-reflector.sh
$ .wtf/nomad/generate-gossip-encryption-key.sh
$ .wtf/nomad/generate-tls-certs.sh -region global
$ kubectl apply --filename manifests/003-nomad-server.yaml
$ .wtf/nomad/boostrap-server.sh -region global
```
### Web URLs

* https://traefik.docker.localhost/dashboard/
* https://argocd.docker.localhost/
* https://victoria-metrics.docker.localhost/
* https://victoria-logs.docker.localhost/
* https://consul.docker.localhost/
* https://nomad.docker.localhost/


### Documentations

```sh
$ openssl x509 -in certs/global-server-nomad.pem -text -noou
```

* https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector
* https://developer.hashicorp.com/consul/docs/k8s/annotations-and-labels
* https://github.com/VictoriaMetrics/helm-charts/tree/master/charts
* https://artifacthub.io/packages/helm/vector/vector