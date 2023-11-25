#!/bin/bash

k3d cluster start dev-local
kubectl cluster-info --context k3d-dev-local
