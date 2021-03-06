#!/bin/bash
#
# install kubernetes on ubuntu
# v. 21.03.01 
# 
# NOT tested
# 

# Install global dependencies
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg

# Create configuration file for containerd:
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

# Load modules:
sudo modprobe overlay
sudo modprobe br_netfilter

# Set system configurations for Kubernetes networking:
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Apply new settings:
sudo sysctl --system

# Install containerd:
sudo apt-get update 
sudo apt-get install -y device-mapper-persistent-data lvm2 
sudo apt-get install -y containerd

# Create default configuration file for containerd:
sudo mkdir -p /etc/containerd

# Generate default containerd configuration and save to the newly created default file:
sudo containerd config default | sudo tee /etc/containerd/config.toml

# Restart containerd to ensure new configuration file usage:
sudo systemctl restart containerd
# sudo systemctl enable containerd.service

# Disable swap:
sudo swapoff -a

# Disable swap on startup in /etc/fstab:
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab



# # install docker
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# echo \
#   "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
#   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# sudo apt-get update -y
# sudo apt-get install -y docker-ce docker-ce-cli containerd.io
# sudo usermod -aG docker ubuntu

# ### Set Docker cgroup driver to systemd
# sudo cat <<EOF | sudo tee /etc/docker/daemon.json
# {
#   "exec-opts": ["native.cgroupdriver=systemd"]
# }
# EOF

# sudo systemctl enable docker.service
# sudo systemctl enable containerd.service
# sudo systemctl start docker





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
