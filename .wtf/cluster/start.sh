#!/bin/bash

k3d cluster start dev-local

# change kubernetes context
kubectx k3d-dev-local
kubectl cluster-info --context k3d-dev-local

kubectl taint nodes k3d-dev-local-server-0 key=node-master:NoSchedule
kubectl taint nodes k3d-dev-local-server-1 key=node-master:NoSchedule
kubectl taint nodes k3d-dev-local-server-2 key=node-master:NoSchedule
