#!/bin/bash
echo "********************************************"
echo "*** install docker "
echo "********************************************"
echo "*** os: ubuntu"
echo "*** v. 21.03.11 "
echo "********************************************"

set -e

# update, get deps
sudo apt-get update
sudo apt-get install \
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
sudo apt-get update

# 19.03
# install docker
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y docker-ce docker-ce-cli 
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y containerd.io

# add user to docker group
sudo usermod -aG docker ubuntu

# verify
docker version

# use systemd
sudo mkdir /etc/docker
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