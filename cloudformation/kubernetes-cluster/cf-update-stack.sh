#!/bin/bash

aws cloudformation update-stack \
    --stack-name kube \
    --template-body file://kube-cluster.yml \
    --parameters file://kube-parameters.json \
    --capabilities CAPABILITY_IAM \
    --profile mapic