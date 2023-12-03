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
kubectx k3d-dev-local
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

mkdir certs

# -----------------------
# GENERATE GOSSIP ENCRYPTION KEY
# -----------------------

secret_exists=$(kubectl get secret $secret_name -n $namespace 2>/dev/null)
if [ -z "$secret_exists" ]; then
    echo "[INFO] secret $secret_name does not exist in namespace $namespace"
    uuid=$(curl -s https://www.uuidgenerator.net/api/version4)
    echo $uuid > certs/bootstrap.token
    kubectl create secret generic $secret_name  -n $namespace --from-file=certs
else
    echo "[INFO] secret $secret_name exists in namespace $namespace"
fi

token=$(kubectl get secret $secret_name -n $namespace -o jsonpath='{.data.bootstrap\.token}' | base64 --decode)
echo "[INFO]... acl token is $token"
echo $token > certs/bootstrap.token

# -----------------------
# DOWNLOAD NOMAD CERTS
# -----------------------

tls_secret_name="nomad-server-tls-certs"
tls_secret_exists=$(kubectl get secret $tls_secret_name -n $namespace 2>/dev/null)
if [ -z "$tls_secret_exists" ]; then
    echo "[ERROR] secret $tls_secret_name does not exist in namespace $namespace"
    exit 1
else
    echo "[INFO] secret $tls_secret_name exists in namespace $namespace"
fi

echo "[INFO] download certs"
kubectl get secret nomad-server-tls-certs -n nomad-system -o json | jq -r '.data."nomad-agent-ca.pem"' | base64 --decode > certs/nomad-agent-ca.pem
kubectl get secret nomad-server-tls-certs -n nomad-system -o json | jq -r --arg REGION "$region" '.data[$REGION + "-cli-nomad.pem"]' | base64 --decode > certs/$region-cli-nomad.pem
kubectl get secret nomad-server-tls-certs -n nomad-system -o json | jq -r --arg REGION "$region" '.data[$REGION + "-cli-nomad-key.pem"]' | base64 --decode > certs/$region-cli-nomad-key.pem

# -----------------------
# VERIFY BOOTSTRAP NOMAD
# -----------------------

nomad server members \
    -address=https://nomad.docker.localhost \
    -region=$region \
    -ca-cert=certs/nomad-agent-ca.pem \
    -client-cert=certs/$region-cli-nomad.pem \
    -client-key=certs/$region-cli-nomad-key.pem \
    -json

exit 0

# -----------------------
# RUN BOOTSTRAP NOMAD
# -----------------------

nomad acl bootstrap \
    -address=https://nomad.docker.localhost \
    -region=$region \
    -ca-cert=certs/nomad-agent-ca.pem \
    -client-cert=certs/$region-cli-nomad.pem \
    -client-key=certs/$region-cli-nomad-key.pem \
    certs/bootstrap.token

# -----------------------
# END
# -----------------------

echo ""
