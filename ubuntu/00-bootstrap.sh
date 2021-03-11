#!/bin/bash

echo 
echo
echo "********************************************"
echo "*** Bootstrap script"
echo "********************************************"
echo "*** NODE: $NODE"
echo "*** HOME: $HOME"
echo "*** K8_NODE_TYPE: $K8_NODE_TYPE"
echo "********************************************"
echo

# self-own
sudo chown -R ubuntu:ubuntu /home/ubuntu

# upgrade
sudo apt-get update
sudo apt-get upgrade -y

# run scripts in sorted order
for CURR_FILE in $(ls -I "00*" -I "*manual*" -1v) # ignore 00-bootstrap, sort 
do
    echo "*** Dry-running bootstrap script: $CURR_FILE"
    # bash $CURR_FILE

done

echo "*** All done!"