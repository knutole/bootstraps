#!/bin/bash

NODE=$2
echo "Boostrap script..."
echo "NODE: $NODE"
echo "HOME: $HOME"

sudo yum update && yum install -y curl

echo "Installing ZSH"
curl https://raw.githubusercontent.com/knutole/bootstraps/main/bootstrap-scripts/amazonlinux2/bootstrap.zsh.amazonlinux2.sh \
    -H "Cache-Control: no-cache"  -L --output /home/ec2-user/bootstrap.zsh.amazonlinux2.sh

echo "Installing Kubernetes"
curl https://raw.githubusercontent.com/knutole/bootstraps/main/bootstrap-scripts/amazonlinux2/bootstrap.kubernetes.amazonlinux2.sh
    -H "Cache-Control: no-cache"  -L --output /home/ec2-user/bootstrap.kubernetes.amazonlinux2.sh

if [ "$NODE" == "control" ]; then
    echo "Initializing cluster..."
    curl https://raw.githubusercontent.com/knutole/bootstraps/main/bootstrap-scripts/amazonlinux2/bootstrap.init-kubernetes-cluster.amazonlinux2.sh
        -H "Cache-Control: no-cache"  -L --output /home/ec2-user/bootstrap.init-kubernetes-cluster.amazonlinux2.sh
fi

echo "All done!"