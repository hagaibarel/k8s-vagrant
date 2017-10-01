#!/bin/sh

export KUBEVER=1.8.0-00
export DOCKERVER=17.03.2~ce-0~ubuntu-xenial

apt-get update && apt-get install -yq apt-transport-https \
  linux-image-extra-$(uname -r) \
  linux-image-extra-virtual \
  ca-certificates

#add kubernetes apt repository and gpg key
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

add-apt-repository \
  "deb [arch=amd64] http://apt.kubernetes.io \
  kubernetes-$(lsb_release -cs) \
  main"

#add docker apt repository and gpg key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

apt-get update && apt-get install -yq \
  kubeadm=$KUBEVER \
  kubectl=$KUBEVER \
  docker-ce=$DOCKERVER