#!/bin/bash


# Create test
echo "Creating cilium test suite..."
kubectl create ns cilium-test
kubectl apply -n cilium-test -f https://raw.githubusercontent.com/cilium/cilium/1.9.5/examples/kubernetes/connectivity-check/connectivity-check.yaml
kubectl get pods -n cilium-test
