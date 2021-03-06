#!/bin/bash

NODE=$2
echo "Boostrap script..."
echo "NODE: $NODE"
echo "HOME: $HOME"

# sudo yum update && yum install -y curl
sudo apt update && sudo apt install -y curl unzip

cd ~ && mkdir .bootstrap && cd .bootstrap
curl -L https://github.com/knutole/bootstraps/archive/main.zip -o bootstraps.zip
unzip bootstraps.zip
cd bootstraps-main/bootstrap-scripts/ubuntu
for CURR_FILE in $(ls -S1)
do
    echo "Next file: ${CURR_FILE}"
done

echo "Installing ZSH"
curl https://raw.githubusercontent.com/knutole/bootstraps/main/bootstrap-scripts/amazonlinux2/bootstrap.zsh.amazonlinux2.sh \
    -H "Cache-Control: no-cache"  -L --output ~/bootstrap.zsh.amazonlinux2.sh

echo "Installing Kubernetes"
curl https://raw.githubusercontent.com/knutole/bootstraps/main/bootstrap-scripts/amazonlinux2/bootstrap.kubernetes.amazonlinux2.sh
    -H "Cache-Control: no-cache"  -L --output ~/bootstrap.kubernetes.amazonlinux2.sh


if [ "$NODE" == "control" ]; then
    echo "Initializing cluster..."
    curl https://raw.githubusercontent.com/knutole/bootstraps/main/bootstrap-scripts/amazonlinux2/bootstrap.init-kubernetes-cluster.amazonlinux2.sh
        -H "Cache-Control: no-cache"  -L --output ~/bootstrap.init-kubernetes-cluster.amazonlinux2.sh
    bash ~/bootstrap.init-kubernetes-cluster.amazonlinux2.sh
fi

echo "All done!"