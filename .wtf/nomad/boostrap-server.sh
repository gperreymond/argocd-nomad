#!/bin/bash

# -----------------------
# PREPARE
# -----------------------

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -region) region="$2"; shift ;;
        *) echo "[ERROR] param is not authorized"; exit 1;;
    esac
    shift
done

if [[ -z "$region" ]]; then
    echo "[ERROR] region is mandatory"
    exit 1
fi

rm -rf certs

# change kubernetes context
kubectl config use-context k3d-dev-local
kubectl cluster-info --context k3d-dev-local

# secret to verify
secret_name="nomad-bootstrap-acl-token"
namespace="nomad-system"

# -----------------------
# RESUME
# -----------------------

echo ""
echo "====================================================================="
echo "[INFO] region..................... $region"
echo "[INFO] secret..................... $secret_name"
echo "[INFO] namespace.................. $namespace"
echo "====================================================================="
echo ""

# -----------------------
# GENERATE GOSSIP ENCRYPTION KEY
# -----------------------

secret_exists=$(kubectl get secret $secret_name -n $namespace 2>/dev/null)

mkdir certs
if [ -z "$secret_exists" ]; then
    echo "[INFO] secret $secret_name does not exist in namespace $namespace"
    uuid=$(curl -s https://www.uuidgenerator.net/api/version4)
    echo $uuid > certs/bootstrap.token
    kubectl create secret generic $secret_name  -n $namespace --from-file=certs
else
    echo "[INFO] secret $secret_name exists in namespace $namespace"
fi

token=$(kubectl get secret $secret_name -n $namespace -o jsonpath='{.data.bootstrap\.token}' | base64 --decode)
echo "[INFO] acl token is $token"
echo $token > certs/bootstrap.token

# -----------------------
# VERIFY BOOTSTRAP NOMAD
# -----------------------

# -----------------------
# RUN BOOTSTRAP NOMAD
# -----------------------

tls_secret_name="nomad-tls-certs"
# retrieve keys from the secret
keys=$(kubectl get secret $tls_secret_name -n $namespace -o jsonpath="{.data}" | jq -r 'keys[]')
# loop through each key and save its value to a file
echo "[INFO] download certs"
for key in $keys; do
    key_replaced="${key//./\\\.}"
    content=$(kubectl get secret $tls_secret_name -n $namespace -o jsonpath="{.data.${key_replaced}}" | base64 --decode)
    echo $content > certs/$key
    echo "[INFO] ... $key downloaded "
done

nomad acl bootstrap \
    -address=https://nomad.docker.localhost:4646 \
    -region=$region \
    -ca-cert=certs/nomad-agent-ca.pem \
    -client-cert=certs/$region-cli-nomad.pem \
    -client-key=certs/$region-cli-nomad-key.pem \
    certs/bootstrap.token

# -----------------------
# END
# -----------------------

echo ""
