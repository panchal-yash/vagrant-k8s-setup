#!/bin/bash

JOIN_COMMAND=$(curl db1:80)

echo "Following is the Join Command:- $JOIN_COMMAND"

$JOIN_COMMAND

curl db1:8080 > /etc/kubernetes/kubelet-admin.conf

echo "KUBECONFIG=/etc/kubernetes/kubelet-admin.conf" >> /etc/environment

source /etc/environment
