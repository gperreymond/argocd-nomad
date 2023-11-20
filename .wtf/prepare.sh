#!/bin/bash

kubectl create ns argocd-system
helm upgrade argocd charts/argo-cd-5.51.2.tgz --install --namespace argocd-system --values config/argocd.yaml

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml
