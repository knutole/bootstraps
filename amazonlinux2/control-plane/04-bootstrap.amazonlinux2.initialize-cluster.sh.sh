#!/bin/bash
#
# initialize kubernetes cluster
# v. 21.02.28 
#
# √ tested 
#

# Initialize the Kubernetes cluster on the control plane node using kubeadm (Note: This is only performed on the Control Plane Node):
sudo kubeadm init --pod-network-cidr 10.1.0.0/16

# Set kubectl access:
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Test access to cluster:
kubectl version

# Install the Calico Network Add-On
# On the Control Plane Node, install Calico Networking:
# kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
