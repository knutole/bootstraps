#!/bin/bash
echo
echo "********************************************"
echo "*** install kubernetes on ubuntu"
echo "********************************************"
echo "*** os: ubuntu"
echo "*** v. 21.03.06 "
echo "***"
echo "*** ? tested"
echo "********************************************"
echo

# Install global dependencies
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    net-tools 

# Download and add GPG key:
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add Kubernetes to repository list:
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Update package listings:
sudo apt-get update

# Install Kubernetes packages (Note: If you get a dpkg lock message, just wait a minute or two before trying the command again):
K8SVERSION=1.20.1-00
sudo apt-get install -y kubelet=$K8SVERSION kubeadm=$K8SVERSION kubectl=$K8SVERSION

# Turn off automatic updates:
sudo apt-mark hold kubelet kubeadm kubectl
