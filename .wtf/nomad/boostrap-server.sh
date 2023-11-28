#!/bin/bash

# -----------------------
# PREPARE
# -----------------------

rm -rf certs

# change kubernetes context
kubectl cluster-info --context k3d-dev-local

# secret to verify
secret_name="nomad-acl-bootstrap"
namespace="nomad-system"

# -----------------------
# RESUME
# -----------------------

echo ""
echo "====================================================================="
echo "[INFO] secret..................... $secret_name"
echo "[INFO] namespace.................. $namespace"
echo "====================================================================="
echo ""

# -----------------------
# GENERATE GOSSIP ENCRYPTION KEY
# -----------------------

secret_exists=$(kubectl get secret $secret_name -n $namespace 2>/dev/null)

if [ -z "$secret_exists" ]; then
    echo "[INFO] secret $secret_name does not exist in namespace $namespace"
    mkdir certs
else
    echo "[INFO] secret $secret_name exists in namespace $namespace"
fi

# -----------------------
# END
# -----------------------

echo ""
