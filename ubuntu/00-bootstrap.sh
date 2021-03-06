#!/bin/bash

NODE=$2
echo "Bootstrap script..."
echo "NODE: $NODE"
echo "HOME: $HOME"
echo "K8_NODE_TYPE: $K8_NODE_TYPE"

# get deps
sudo apt-get update && sudo apt-get install -y curl unzip

# pull script
mkdir ~/.bootstraps && cd ~/.bootstraps
curl -L https://github.com/knutole/bootstraps/archive/main.zip -o bootstraps.zip
unzip bootstraps.zip
cd bootstraps-main/bootstrap-scripts/ubuntu

# run scripts in sorted order
for CURR_FILE in $(ls -I 00* -1v *.ubuntu.*) # ignore 00-boostrap, sort, show only ubuntu 
do
    echo "Dry run: Running bootstrap script: $CURR_FILE"
done

echo "All done!"