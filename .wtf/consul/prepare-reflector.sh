#!/bin/bash

# -----------------------
# PREPARE
# -----------------------

kubectx k3d-dev-local
kubectl cluster-info --context k3d-dev-local

# -----------------------
# RESUME
# -----------------------

# -----------------------
# APPLY REFLECTOR SETTINGS
# -----------------------

kubectl annotate secret consul-server-consul-ca-cert -n consul-system "reflector.v1.k8s.emberstack.com/reflection-allowed=true"
kubectl annotate secret consul-server-consul-ca-cert -n consul-system "reflector.v1.k8s.emberstack.com/reflection-allowed-namespaces=nomad-system"

kubectl annotate secret consul-server-consul-gossip-encryption-key -n consul-system "reflector.v1.k8s.emberstack.com/reflection-allowed=true"
kubectl annotate secret consul-server-consul-gossip-encryption-key -n consul-system "reflector.v1.k8s.emberstack.com/reflection-allowed-namespaces=nomad-system"

# -----------------------
# END
# -----------------------

echo ""