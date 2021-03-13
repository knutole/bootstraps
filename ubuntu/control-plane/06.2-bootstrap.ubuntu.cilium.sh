#!/bin/bash

### https://docs.cilium.io/en/v1.9/gettingstarted/k8s-install-default/
### https://docs.cilium.io/en/v1.9/concepts/kubernetes/requirements/#k8s-requirements


echo "Adding Cilium Helm repo..."
helm repo add cilium https://helm.cilium.io/

echo "Installing Cilium with Helm..."
helm install cilium cilium/cilium --version 1.9.5   \
  --namespace kube-system                           

# wait for pods to be ready
echo "Waiting for pods to be ready..."
for POD in $(kubectl get pods -n kube-system -o=name | grep cilium)
do 
  echo "Waiting for POD: $POD"
  while [[ $(kubectl get $POD -n kube-system -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for $POD" && sleep 1; done
done

echo "All done!"

