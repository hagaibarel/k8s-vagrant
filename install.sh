#!/bin/sh

export KUBEADMVER=1.8.3-00
export KUBECTLVER=1.8.3-00
export DOCKERVER=17.03.2~ce-0~ubuntu-xenial

echo "running apt-get update and installing some packages"
apt-get update && apt-get install -yq apt-transport-https \
  linux-image-extra-$(uname -r) \
  linux-image-extra-virtual \
  ca-certificates

echo "add kubernetes apt repository and gpg key"
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

add-apt-repository \
  "deb [arch=amd64] http://apt.kubernetes.io \
  kubernetes-$(lsb_release -cs) \
  main"

echo "add docker apt repository and gpg key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

echo "installing kubeadm and dependencies"
apt-get update && apt-get install -yq \
  kubeadm=$KUBEADMVER \
  kubectl=$KUBECTLVER \
  docker-ce=$DOCKERVER