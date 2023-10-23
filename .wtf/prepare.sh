#!/bin/bash

kubectl create ns argocd-system
helm upgrade argocd charts/argo-cd-5.46.8 --install --namespace argocd-system --values config/argocd.yaml

kubectl create ns vela-system
helm upgrade kubevela charts/vela-core-1.9.6 --install --namespace vela-system
vela addon enable velaux
vela addon enable vela-workflow
vela addon enable fluxcd