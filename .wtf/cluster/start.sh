#!/bin/bash

k3d cluster start dev-local

# change kubernetes context
kubectx k3d-dev-local
kubectl cluster-info --context k3d-dev-local
