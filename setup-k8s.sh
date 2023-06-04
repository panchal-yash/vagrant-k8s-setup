#!/bin/bash

set +xe

yes y | ssh-keygen -q -t rsa -N '' >/dev/null

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4ns0dEv0sJV+rMDftaaTDwsj2y0hf0/vOsPepy+YJzFW4B8dgTa75bN12uexH78Xcth06MkOCiB3iOuIkoxEcQx8JMUiUCiIpNSWTTTjxu4zhx6k68Fw6eczbbBoXenNO6i7lCB1rXsd2NO4JgOEMobi6IzdkOXINV3LX5Pu3zrbxOKSeTIKnVEt3kK0/yrvCEKAg8lyGIuZ6Xh6zOLkbhQGpWDNexQa8kx4K/2QN98dNWAFktihcy1UOZJ4ha17MEsDRxyNb5lixWurv23/BpjbaiywpQbmZ+hAfS3wN2hxMSuP4pwkoCiRBvQjT7fD5jeMJ3YiYVv56VBbf0TAAcLentCowfzEdwPYyExma0J0PXmregNPlaw38KcmlSmUfXn77XRIgJ70aAcq3MscsqlKpIN7AYYbTBuDj/7ENpI8dsJarNWmeHMlfoi0mwI9izPnJim3XODdGWAZlV0CXvG2NpmzASxuKYrf8occNtyjjrD/Fn5DBHuD6PbJn8KE= yash@yash-ThinkPad-P15-Gen-2i" >> ~/.ssh/authorized_keys

cat <<EOF >> /etc/hosts
192.168.1.101 db1
192.168.1.102 db2
192.168.1.103 db3
EOF
sudo swapoff -a
sudo apt-get install -y apt-transport-https 
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
# Apply sysctl params without reboot
sudo sysctl --system
sudo apt-get update

for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

sudo apt-get update
sudo apt-get install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y



curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet=1.26.0-00 kubeadm=1.26.0-00 kubectl=1.26.0-00
sudo apt-mark hold kubelet kubeadm kubectl

sudo rm /etc/containerd/config.toml
#https://stackoverflow.com/questions/72504257/i-encountered-when-executing-kubeadm-init-error-issue
sudo systemctl restart containerd

apt-get install net-tools -y
#ifconfig enp0s3 down
