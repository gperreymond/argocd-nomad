# ARGOCD NOMAD

```sh
$ .wtf/install-dependencies.sh
$ .wtf/start-cluster.sh
$ .wtf/prepare.sh
$ nomad agent -dev
```

```sh
$ cd src
$ make manifests
$ make install
$ make run
```

```sh
$ kubectl apply --filename manifests/argocd-nomad.yaml
```