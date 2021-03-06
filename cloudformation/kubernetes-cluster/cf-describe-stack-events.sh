#!/bin/bash

aws cloudformation describe-stack-events \
    --stack-name kube \
    --profile mapic