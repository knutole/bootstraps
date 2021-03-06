#!/bin/bash

aws cloudformation create-stack \
    --stack-name kube \
    --template-body file://kube-cluster.yml \
    --parameters file://kube-parameters.json \
    --capabilities CAPABILITY_IAM \
    --profile mapic
