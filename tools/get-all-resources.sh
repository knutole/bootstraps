#!/bin/bash

for RESOURCE in $(kubectl api-resources --sort-by=name -o=name) # ignore 00-bootstrap, sort 
do
    echo 
    echo  "Looking up $RESOURCE..."
    kubectl get $RESOURCE --all-namespaces 

done