#!/bin/bash

docker network create --subnet=192.168.200.0/24 kind
kind create cluster --config=cluster.yaml

kubectl cluster-info --context kind-local-tooling
