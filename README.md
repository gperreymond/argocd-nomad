# ARGOCD NOMAD

```sh
$ .wtf/install-dependencies.sh
$ .wtf/start-cluster.sh
$ .wtf/prepare.sh
$ nomad agent -dev -bind 192.168.1.35 # replace 192.168.1.35 by your own
$ kubectl apply --filename manifests/argocd-nomad.yaml
```

Edit the file: charts/argocd-nomad/templates/configmap.yaml
```yaml
- name: NOMAD_ADDR
  value: http://192.168.1.35:4646 # replace 192.168.1.35 by your own
```