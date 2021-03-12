#!/bin/bash


# Install Kubeview
echo "Installing Kubeview..."
helm repo add kubeview https://benc-uk.github.io/kubeview/charts
helm install my-kubeview kubeview/kubeview --version 0.1.20
