#!/bin/bash
echo "********************************************"
echo "*** initialize kubernetes cluster "
echo "*** (on control plane only)"
echo "********************************************"
echo "*** os: ubuntu"
echo "*** v. 21.03.06 "
echo "***"
echo "*** ? tested"
echo "********************************************"

set -e
export HOME=/home/ubuntu

# Disable swap:
sudo swapoff -a

# Disable swap on startup in /etc/fstab:
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Initialize the Kubernetes cluster on the control plane node using kubeadm (Note: This is only performed on the Control Plane Node):
CIDR=10.0.10.0/16 # needs to match AWS subnet apparently
echo "Initializing cluster @ $CIDR..."
# sudo kubeadm init --pod-network-cidr $CIDR
sudo kubeadm init # autoconfigure CIDR

# Set kubectl access:
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Test access to cluster:
kubectl version
kubectl get nodes

# done
echo "All done!"

