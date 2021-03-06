#!/bin/bash

aws cloudformation create-change-set \
    --stack-name kube \
    --change-set-name kube-cs \
    --template-body file://kube-cluster.yml \
    --parameters file://kube-parameters.json \
    --capabilities CAPABILITY_IAM \
    --profile mapic
