#!/bin/bash
#
# install kubernetes on amazon linux 2
# v. 21.03.01 
# 
# √ tested
# 

# Create configuration file for containerd:
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

## Load modules:
sudo modprobe overlay
sudo modprobe br_netfilter

# Set system configurations for Kubernetes networking:
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

## Apply new settings:
sudo sysctl --system

# Install containerd
## Set up the repository
### Install required packages
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

### Add docker repository
sudo amazon-linux-extras enable docker

## Install containerd
sudo yum install -y containerd

## Configure containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

## Restart containerd
sudo systemctl restart containerd

# Disable swap:
sudo swapoff -a

## Disable swap on startup in /etc/fstab:
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Install Docker
## Install Amazon Linux 2 package
sudo amazon-linux-extras install docker

## Configure Docker
### Add ec2-user to docker group
sudo usermod -a -G docker ec2-user

### Set Docker cgroup driver to systemd
sudo cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

### Enable Docker on boot
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

## Start Docker daemon
sudo systemctl start docker

# Install Kubernetes
## Set up the repository
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

## Set SELinux in permissive mode (effectively disabling it)
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

## Install Kubernetes
### Set version
KUBE_VERSION=1.20.4-0

### Install packages with version tag
sudo yum install -y kubelet-$KUBE_VERSION kubeadm-$KUBE_VERSION kubectl-$KUBE_VERSION --disableexcludes=kubernetes

### Refresh
sudo systemctl enable --now kubelet

