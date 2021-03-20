#!/bin/bash

# Install Helm
echo "Installing Helm..."
sudo curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 -o get_helm.sh
sudo bash get_helm.sh

echo "Helm version:"
helm version

echo "All done!"
