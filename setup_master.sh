#!/bin/bash
#
#  Installation Kubernetes Master
#

#
# Install ETCDCTL
#

wget https://github.com/etcd-io/etcd/releases/download/v3.5.2/etcd-v3.5.2-linux-amd64.tar.gz -O /tmp/etcd-v3.5.2-linux-amd64.tar.gz
tar -xvf /tmp/etcd-v3.5.2-linux-amd64.tar.gz -C /tmp
mv /tmp/etcd-v3.5.2-linux-amd64/etcdctl /usr/bin/

#
# Setup Kubernetes with Kubeadm
#

kubeadm init --apiserver-advertise-address=${address} --pod-network-cidr=192.168.0.0/16 --kubernetes-version=1.22.1

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://projectcalico.docs.tigera.io/manifests/calico.yaml
