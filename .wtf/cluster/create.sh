#!/bin/bash

docker network create k3d-dev-local
k3d cluster create --config cluster.yaml

# change kubernetes context
kubectx k3d-dev-local
kubectl cluster-info --context k3d-dev-local
