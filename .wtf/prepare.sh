#!/bin/bash

kubectl create ns argocd-system
helm upgrade argocd charts/argo-cd-5.46.8 --install --namespace argocd-system --values config/argocd.yaml
