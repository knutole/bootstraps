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

# run scripts in sorted order
for CURR_FILE in $(ls -I 00* -1v *.ubuntu.*) # ignore 00-boostrap, sort, show only ubuntu 
do
    echo "*** Dry run: Running bootstrap script: $CURR_FILE"
done

echo "*** All done!"