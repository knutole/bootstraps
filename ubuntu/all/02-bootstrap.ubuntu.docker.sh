#!/bin/bash
echo "********************************************"
echo "*** install docker "
echo "********************************************"
echo "*** os: ubuntu"
echo "*** v. 21.03.11 "
echo "********************************************"

# set -e

# update, get deps
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# get gpg key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# add repo
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# update
sudo apt-get update -y

# 19.03
# install docker
DOCKER_VERSION=5:19.03.15~3-0~ubuntu-focal
echo "Install Docker version $DOCKER_VERSION"
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y docker-ce=$DOCKER_VERSION docker-ce-cli=$DOCKER_VERSION
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y containerd.io

# add user to docker group 
# (need to log out/in to take effect - or use sudo for rest of script)
sudo usermod -aG docker ubuntu

# use systemd
sudo mkdir -p /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

# restart
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker

# verify
sudo docker version