#!/bin/sh

apt-get update && apt-get install -y apt-transport-https \
  linux-image-extra-$(uname -r) \
  linux-image-extra-virtual \
  ca-certificates

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 \
  --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

cat <<EOF > /etc/apt/sources.list.d/docker.list
deb https://apt.dockerproject.org/repo ubuntu-xenial main
EOF

apt-get update && apt-get install -y kubelet \
  kubeadm \
  kubectl \
  kubernetes-cni \
  docker-engine=1.12.6-0~ubuntu-xenial