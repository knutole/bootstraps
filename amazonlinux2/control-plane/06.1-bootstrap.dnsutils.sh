#!/bin/bash

echo "Creating dnsutils pod..."
kubectl apply -f https://k8s.io/examples/admin/dns/dnsutils.yaml

echo "Usage:"
echo "$ kubectl exec -i -t dnsutils -- nslookup kubernetes.default"
echo "$ kubectl exec -ti dnsutils -- cat /etc/resolv.conf"
echo "See https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/"