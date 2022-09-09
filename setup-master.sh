#!/bin/bash
#
#  Installation Docker & Docker-Compose
#
# Setup daemon.
mkdir -p /etc/docker/
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
sudo apt-get update
sudo apt-get install -yqq apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -yqq docker-ce docker-ce-cli containerd.io
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

#
# Installation Kubeadm
#

sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet=1.23.0-00 kubeadm=1.23.0-00 kubectl=1.23.0-00
sudo apt-mark hold kubelet kubeadm kubectl

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

ip=`hostname -I | cut -d' ' -f1`

kubeadm init --apiserver-advertise-address=$ip --pod-network-cidr=192.168.0.0/16 --kubernetes-version=1.23.0

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://projectcalico.docs.tigera.io/manifests/calico.yaml
kubectl apply -f https://raw.githubusercontent.com/ilkilab/infrastructure-labs/cka/cka-setup/infra-setup.yaml
#kubectl apply -f https://raw.githubusercontent.com/ilkilab/infrastructure-labs/cka/cka-setup/cka-setup.yaml

# Install CRICTL
VERSION="v1.23.0"
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/critest-$VERSION-linux-amd64.tar.gz
sudo tar zxvf critest-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
rm -f critest-$VERSION-linux-amd64.tar.gz

#
#  Push SSH public key
#
# Push SSH Key for Root
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqwvE11dHB+xKvcFYA2np4Xqmmx7HsIOEjO2FkbnoWOWGFD4GKdGsnbcSxg5EM5K9iooO6sBD0j7w30EiUNMIK06SSyK4hvM5nq4V+0yFOfWD/1s8wen8kqu22RnjEOrikeNPeQsNKAjwsCBGsmd7DyqWRRtOKwyUjJFvDJEhutKR4zGMx0xnPHA1G3vE6eYc4yoR9IhwwT7d0cbsPeqgz6ocblr+o8vNSfCjDtEpDj8ro1QV5PVRx1z/I6f3YTDEH1ZjGsJXpdcYEqIIBNagDMFql5a8aaupEAqI0tcMrjMToWyR+MbDDP0PtXZcSGLSR7bYiuSGbfyxyI4JvU9TTWgz34PU4fia6sTUijSjSsDeRJAGjwVBmKfcX1mkBAkQsPBG7JrGltAIU3Fp+eVnShCXtbGM/JRUqSBgDXMeOq+/ADPcCeXj/eFd7g+UciQTS1CaNDh92aCwe2LxfRit8dmgLN4LGW2dKp45V+Zz8KOq9koWqe+B9EIY8JkPO7LM=" >> /root/.ssh/authorized_keys
