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

FLAVOR=amazonlinux2
USER=ec2-user
HOME=/home/$USER

# update
sudo yum update && sudo yum -y install unzip

# get bootscripts
cd $HOME
curl -L https://github.com/knutole/bootstraps/archive/main.zip -o bootstraps.zip
unzip -o bootstraps.zip && rm bootstraps.zip
cd bootstraps-main/$FLAVOR

# self-own
sudo chown -R $USER:$USER $HOME

echo "Running ALL scripts..."
cd $HOME/bootstraps-main/$FLAVOR/all

# run scripts in sorted order
for CURR_FILE in $(ls -I "00*" -I "*manual*" -1v) # ignore 00-bootstrap, sort 
do
    echo "*** Running bootstrap script: $CURR_FILE"
    bash $CURR_FILE
done

echo "Running Control Plane scripts..."
cd $HOME/bootstraps-main/$FLAVOR/control-plane

# run scripts in sorted order
for CURR_FILE in $(ls -I "00*" -I "*manual*" -1v) # ignore 00-bootstrap, sort 
do
    echo "*** Dry-running bootstrap script: $CURR_FILE"
    # bash $CURR_FILE
done

echo "*** All done!"
