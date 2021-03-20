#!/bin/bash


# Install Hubble UI for Celium
# https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/
echo "Installing Hubble UI..."
kubectl create ns hubble-ui
kubectl apply -n hubble-ui -f https://raw.githubusercontent.com/cilium/cilium/1.9.3/install/kubernetes/quick-hubble-install.yaml
