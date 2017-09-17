#!/bin/sh
echo $(whoami)

# move kubecfg file to home folder
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# install weave network plugin 
export kubever=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever" 

# copy kubecfg file to shared vagrant directory
cp -i $HOME/.kube/config /vagrant/config