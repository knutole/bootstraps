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


# Initialize the Kubernetes cluster on the control plane node using kubeadm (Note: This is only performed on the Control Plane Node):
sudo kubeadm init --pod-network-cidr 10.1.0.0/16

# Set kubectl access:
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Test access to cluster:
kubectl version

# Install the Calico Network Add-On
# On the Control Plane Node, install Calico Networking:
# kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Install Cilium 
## Documentation
### https://docs.cilium.io/en/v1.9/gettingstarted/k8s-install-default/
### https://docs.cilium.io/en/v1.9/concepts/kubernetes/requirements/#k8s-requirements
## Get plugin
kubectl create -f https://raw.githubusercontent.com/cilium/cilium/1.9.3/install/kubernetes/quick-install.yaml

## Validate Cilium install
kubectl -n kube-system get pods --watch

# Check status of Calico components:
kubectl get pods -n kube-system

# Create test
kubectl create ns cilium-test
kubectl apply -n cilium-test -f https://raw.githubusercontent.com/cilium/cilium/1.9.3/examples/kubernetes/connectivity-check/connectivity-check.yaml
kubectl get pods -n cilium-test

# Install Hubble UI for Celium
# https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/
export CILIUM_NAMESPACE=kube-system
kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/1.9.3/install/kubernetes/quick-hubble-install.yaml
kubectl port-forward -n $CILIUM_NAMESPACE svc/hubble-ui --address 0.0.0.0 --address :: 12000:80
# And then open http://localhost:12000/ to access the UI. (or public IP if ports are open)


# Install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
bash get_helm.sh

# Install Kubeview
helm repo add kubeview https://benc-uk.github.io/kubeview/charts
helm install my-kubeview kubeview/kubeview --version 0.1.20


# install krew
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" &&
  tar zxvf krew.tar.gz &&
  KREW=./krew-"${OS}_${ARCH}" &&
  "$KREW" install krew
)

# add to .zshrc: 
# export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
# restart shell: exec zsh

# install kubectl ns + ctx
kubectl krew install ctx
kubectl krew install ns

# done
echo "Done!"