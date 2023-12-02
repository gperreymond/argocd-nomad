#!/bin/bash

# change kubernetes context
kubectx k3d-dev-local
kubectl cluster-info --context k3d-dev-local

kubectl create ns argocd-system
helm upgrade argocd charts/argo-cd-5.51.4.tgz --install --namespace argocd-system --values charts/values/argocd.yaml
