#!/bin/bash

### https://docs.cilium.io/en/v1.9/gettingstarted/k8s-install-default/
### https://docs.cilium.io/en/v1.9/concepts/kubernetes/requirements/#k8s-requirements


# echo "Adding Cilium Helm repo..."
# helm repo add cilium https://helm.cilium.io/

# echo "Installing Cilium with Helm..."
# helm install cilium cilium/cilium --version 1.9.3   \
#   --namespace kube-system                           

# # wait for pods to be ready
# echo "Waiting for pods to be ready..."
# for POD in $(kubectl get pods -n kube-system -o=name | grep cilium)
# do 
#   echo "Waiting for POD: $POD"
#   while [[ $(kubectl get $POD -n kube-system -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for $POD" && sleep 1; done
# done

# echo "All done!"



# Install Cilium 
## Documentation
### https://docs.cilium.io/en/v1.9/gettingstarted/k8s-install-default/
### https://docs.cilium.io/en/v1.9/concepts/kubernetes/requirements/#k8s-requirements
## Get plugin

CILIUM_VERSION=1.9.5
echo "Getting Cilium yaml v$CILIUM_VERSION... "
wget https://raw.githubusercontent.com/cilium/cilium/$CILIUM_VERSION/install/kubernetes/quick-install.yaml 
cat quick-install.yaml
# kubectl create -f https://raw.githubusercontent.com/cilium/cilium/$CILIUM_VERSION/install/kubernetes/quick-install.yaml

echo "Apply manually...."
## Validate Cilium install
# kubectl -n kube-system get pods --watch

# Check status of Cilium components:
# kubectl get pods -n kube-system
