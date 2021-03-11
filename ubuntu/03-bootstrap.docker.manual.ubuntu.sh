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

# install docker
sudo apt-get install -y docker-ce docker-ce-cli 
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y containerd.io

# verify
docker version