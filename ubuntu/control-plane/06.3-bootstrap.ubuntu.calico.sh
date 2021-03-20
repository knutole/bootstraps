#!/bin/bash

# https://docs.projectcalico.org/getting-started/kubernetes/quickstart

# Install the Tigera Calico operator and custom resource definitions.
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml

# Install Calico by creating the necessary custom resource.
cat <<EOF | sudo tee calico.custom-resources.yaml
apiVersion: operator.tigera.io/v1
kind: Installation
metadata:
  name: default
spec:
  # Configures Calico networking.
  calicoNetwork:
    # Note: The ipPools section cannot be modified post-install.
    ipPools:
    - blockSize: 26
      cidr: 10.0.0.0/16 # must match kubeadm init --pod-network-cidr $CIDR
      encapsulation: VXLANCrossSubnet
      natOutgoing: Enabled
      nodeSelector: all()
EOF

# create
kubectl create -f calico.custom-resources.yaml
