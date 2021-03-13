#!/bin/bash

# this script is run directly from cloudformation template,
# like so: curl GITHUB | bash

echo 
echo
echo "************************"
echo "*** Bootstrap script ***"
echo "************************"
echo "***   Ubuntu 20.4    ***"
echo "***   -----------    ***"
echo "***       Zsh        ***"
echo "***      Docker      ***"
echo "***    Kubernetes    ***"
echo "************************"
echo "***       v.2        ***"
echo "************************"
echo
echo

# upgrade
sudo apt-get update
sudo apt-get install -y unzip
sudo apt-get upgrade -y

# get bootscripts
cd /home/ubuntu
curl -L https://github.com/knutole/bootstraps/archive/main.zip -o bootstraps.zip
unzip -o bootstraps.zip && rm bootstraps.zip
cd bootstraps-main/ubuntu

# self-own
sudo chown -R ubuntu:ubuntu /home/ubuntu


echo "Running ALL scripts..."
cd /home/ubuntu/bootstraps-main/ubuntu/all

# run scripts in sorted order
for CURR_FILE in $(ls -I "00*" -I "*manual*" -1v) # ignore 00-bootstrap, sort 
do
    echo "*** Running bootstrap script: $CURR_FILE"
    bash $CURR_FILE
done


echo "Running Control Plane scripts..."
cd /home/ubuntu/bootstraps-main/ubuntu/control-plane

# run scripts in sorted order
for CURR_FILE in $(ls -I "00*" -I "*manual*" -1v) # ignore 00-bootstrap, sort 
do
    echo "*** Dry-running bootstrap script: $CURR_FILE"
    # bash $CURR_FILE
done




echo "*** All done!"

