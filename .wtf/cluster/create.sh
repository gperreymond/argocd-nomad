#!/bin/bash

docker network create k3d-dev-local
k3d cluster create --config cluster.yaml

# change kubernetes context
kubectl config use-context k3d-dev-local
kubectl cluster-info --context k3d-dev-local
