#!/bin/bash


kubeadm init --apiserver-advertise-address=192.168.1.101 --pod-network-cidr=192.168.1.0/24 --v=5


IPADDR="192.168.1.101"
NODENAME=$(hostname -s)
POD_CIDR="192.168.1.0/16"

sudo kubeadm init --apiserver-advertise-address=$IPADDR  --apiserver-cert-extra-sans=$IPADDR  --pod-network-cidr=$POD_CIDR --node-name $NODENAME --ignore-preflight-errors Swap


mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


echo "Setting up Weaveworks Network"

kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

kubectl get nodes
kubectl get pods --all-namespaces
kubectl cluster-info

kubeadm token create --print-join-command > index.html

docker run -dit -p 80:80 -v ./index.html:/usr/share/nginx/html/index.html nginx
