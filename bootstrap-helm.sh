#!/bin/sh

set -e

echo "Creating service account and role binding for tiller..."
kubectl -n kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount kube-system:tiller

echo "Installing tiller..."
helm init --service-account tiller

echo "Done."