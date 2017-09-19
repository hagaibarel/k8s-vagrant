#!/bin/sh

echo "apiserver address $1"
echo "join token $2"

sudo kubeadm init --apiserver-advertise-address $1 --token $2

# move kubecfg file to home folder
mkdir -p $HOME/.kube
sudo cp -rf /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# install weave network plugin 
# https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/#pod-network
export kubever=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever" 

# copy kubecfg file to shared vagrant directory
cp -rf $HOME/.kube/config /vagrant/k8s-vagrant