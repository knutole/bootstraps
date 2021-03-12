#!/bin/bash
echo "********************************************"
echo "*** initialize kubernetes cluster "
echo "*** (on control plane only)"
echo "********************************************"
echo "*** os: ubuntu"
echo "*** v. 21.03.06 "
echo "***"
echo "*** ? tested"
echo "********************************************"

set -e
export HOME=/home/ubuntu

# print network debug logs
bash /home/ubuntu/bootstraps-main/tools/network-debugging.sh

# Initialize the Kubernetes cluster on the control plane node using kubeadm (Note: This is only performed on the Control Plane Node):
echo "Initializing cluster..."
sudo kubeadm init --pod-network-cidr 10.100.0.0/16

# print network debug logs
bash /home/ubuntu/bootstraps-main/tools/network-debugging.sh

# Set kubectl access:
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Test access to cluster:
kubectl version

# Install Cilium 
## Documentation
### https://docs.cilium.io/en/v1.9/gettingstarted/k8s-install-default/
### https://docs.cilium.io/en/v1.9/concepts/kubernetes/requirements/#k8s-requirements
## Get plugin
echo "Installing Cilium..."
kubectl create -f https://raw.githubusercontent.com/cilium/cilium/1.9.5/install/kubernetes/quick-install.yaml

## Validate Cilium install
kubectl -n kube-system get pods

# print network debug logs
bash /home/ubuntu/bootstraps-main/tools/network-debugging.sh

# wait for pods to be ready
for POD in $(kubectl get pods -n kube-system -o=name | grep cilium)
do
  while [[ $(kubectl get $POD -n kube-system -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for $POD" && sleep 1; done
done

# print network debug logs
bash /home/ubuntu/bootstraps-main/tools/network-debugging.sh

# Create test
echo "Creating cilium test suite..."
kubectl create ns cilium-test
kubectl apply -n cilium-test -f https://raw.githubusercontent.com/cilium/cilium/1.9.3/examples/kubernetes/connectivity-check/connectivity-check.yaml
kubectl get pods -n cilium-test

# print network debug logs
bash /home/ubuntu/bootstraps-main/tools/network-debugging.sh

# wait for pods to be ready
for POD in $(kubectl get pods -n cilium-test -o=name | grep cilium)
do
  while [[ $(kubectl get $POD -n cilium-test -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for $POD" && sleep 1; done
done

# print network debug logs
bash /home/ubuntu/bootstraps-main/tools/network-debugging.sh

# Install Hubble UI for Celium
# https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/
echo "Installing Hubble UI..."
kubectl create ns hubble-ui
kubectl apply -n hubble-ui -f https://raw.githubusercontent.com/cilium/cilium/1.9.3/install/kubernetes/quick-hubble-install.yaml

# print network debug logs
bash /home/ubuntu/bootstraps-main/tools/network-debugging.sh

# wait for pods to be ready
for POD in $(kubectl get pods -n hubble-ui -o=name)
do
  while [[ $(kubectl get $POD -n hubble-ui -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for $POD" && sleep 1; done
done

# kubectl port-forward -n $CILIUM_NAMESPACE svc/hubble-ui --address 0.0.0.0 --address :: 12000:80
# And then open http://localhost:12000/ to access the UI. (or public IP if ports are open)

# print network debug logs
bash /home/ubuntu/bootstraps-main/tools/network-debugging.sh

# Install Helm
echo "Installing Helm..."
sudo curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 -o get_helm.sh
sudo bash get_helm.sh

# print network debug logs
bash /home/ubuntu/bootstraps-main/tools/network-debugging.sh

# Install Kubeview
echo "Installing Kubeview..."
helm repo add kubeview https://benc-uk.github.io/kubeview/charts
helm install my-kubeview kubeview/kubeview --version 0.1.20

# print network debug logs
bash /home/ubuntu/bootstraps-main/tools/network-debugging.sh


# install krew
echo "Installing krew..."
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" &&
  tar zxvf krew.tar.gz &&
  KREW=./krew-"${OS}_${ARCH}" &&
  "$KREW" install krew
)

# print network debug logs
bash /home/ubuntu/bootstraps-main/tools/network-debugging.sh

# add to .zshrc: 
# export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
# restart shell: exec zsh


# install kubectl ns + ctx
echo "Installing ctx + ns..."
kubectl krew install ctx
kubectl krew install ns

# print network debug logs
bash /home/ubuntu/bootstraps-main/tools/network-debugging.sh

# done
echo "Done!"