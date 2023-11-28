#!/bin/bash

k3d cluster start dev-local

# change kubernetes context
kubectl config use-context k3d-dev-local
kubectl cluster-info --context k3d-dev-local
