#!/bin/bash
#
#  Installation Docker & Docker-Compose
#
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
sudo apt-get install -y kubelet=1.22.1-00 kubeadm=1.22.1-00 kubectl=1.22.1-00
sudo apt-mark hold kubelet kubeadm kubectl

# Push SSH Key for Root
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCl3ekSTD+NtyDerAsGoB0Sd4TgtjsHzFqtDWbdCFj6/yNFBbgjVdWzWncLH6uPYdWXljCL4nJdPqdPax6aklHgfBbF3X/zWf45xe4DdMVnkkC72L1iQqvkpr7KAjb5ppHA+1xBDIaRtvJ7LWBpKbl7Yu8Nn/e4jK87w3vWIkXJLXzj4cfAaaT0+yOxvi+CtFoZ6Dlryi7n48FfwM8twYwGmbu0KO9BM0ILIBlhUGxz5JEkRpcTHEoKMmo/dMMDHKW3alQ2a5UdzDVh8h5HpfwYPUh60R5yiJ83YkvCUq6WblKU4bm63wSHYwpm6C+tMHaq5Xh9lYkDP2ZThhIZw/AL9CHyTmjCcadcuUG9ItvMb08vNB/iHpdXunm0vLbxKZlKu4UtO3JbN+mErEKbep5CRQUWblZLakjQZtZqypsk/+wIgS3KQw35RuOAfE6URZh2naLLk2ex78KmQr3hR7EAN7bp8tumCl5NAV43OLPMTOA+89Kmi3maYY8Setgg7rs= root@ILKI-4CLG063" >> /root/.ssh/authorized_keys