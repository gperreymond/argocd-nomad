#!/bin/bash

kubectl cluster-info --context kind-local-tooling

rm -rf certs
mkdir -p certs
kubectl get secret consul-server-consul-ca-cert -n consul-system -o jsonpath='{.data.tls\.crt}' | base64 --decode > certs/consul-ca.crt

consul agent -config-file=config/consul.hcl