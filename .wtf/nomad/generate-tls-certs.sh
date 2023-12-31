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
secret_name="nomad-server-tls-certs"
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
# GENERATE TLS CERTS
# -----------------------

secret_exists=$(kubectl get secret $secret_name -n $namespace 2>/dev/null)
dnsnames="-additional-dnsname=nomad-server.$namespace.svc.cluster.local"
dnsnames="$dnsnames -additional-dnsname=*.nomad-server.$namespace.svc.cluster.local"
dnsnames="$dnsnames -additional-dnsname=nomad-server.$namespace"
dnsnames="$dnsnames -additional-dnsname=*.nomad-server.$namespace"
dnsnames="$dnsnames -additional-dnsname=nomad.docker.localhost"

if [ -z "$secret_exists" ]; then
    echo "[INFO] secret $secret_name does not exist in namespace $namespace"
    nomad tls ca create
    nomad tls cert create -server -region=$region $dnsnames
    nomad tls cert create -client -region=$region $dnsnames
    nomad tls cert create -cli -region=$region $dnsnames
    mkdir certs
    mv *.pem certs
    kubectl create secret generic $secret_name  -n $namespace --from-file=certs
    kubectl create secret tls nomad-server-tls -n kube-system --cert=certs/global-server-nomad.pem --key=certs/global-server-nomad-key.pem
else
    echo "[INFO] secret $secret_name exists in namespace $namespace"
fi

# -----------------------
# END
# -----------------------

echo ""
