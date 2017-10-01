#!/bin/sh

export KUBEVER=1.8.0-00
export DOCKERVER=1.12.6-0~ubuntu-xenial

apt-get update && apt-get install -yq apt-transport-https \
  linux-image-extra-$(uname -r) \
  linux-image-extra-virtual \
  ca-certificates

#add kubernetes gpg repo key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

#add docker gpg repo key
apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 \
  --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

#add kubernetes repo to apt sources list
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

#add docker repo to apt sources list
cat <<EOF > /etc/apt/sources.list.d/docker.list
deb https://apt.dockerproject.org/repo ubuntu-xenial main
EOF

apt-get update && apt-get install -yq \
  kubeadm=$KUBEVER \
  kubectl=$KUBEVER \
  docker-engine=$DOCKERVER