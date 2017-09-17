# -*- mode: ruby -*-
# vi: set ft=ruby :

### configuration parameters
BOX_BASE = "ubuntu/xenial64"
BOX_CPU_COUNT = 1
BOX_RAM_MB = "2048"

# Install a kube cluster using kubeadm:
# http://kubernetes.io/docs/getting-started-guides/kubeadm/

Vagrant.configure("2") do |config|
  config.vm.box = BOX_BASE
  config.vm.box_check_update = false

  config.vm.provider "virtualbox" do |vb|
    vb.cpus = BOX_CPU_COUNT
    vb.memory = BOX_RAM_MB
  
  end
  
  (1..3).each do |i|
    config.vm.define "k8s#{i}" do |c|
      c.vm.hostname = "k8s#{i}"
      c.vm.network "private_network", ip: "192.168.77.1#{i}"
      
      c.vm.provision "shell", path: "install.sh"
      c.vm.provision "shell", inline: "sed 's/127\.0\.0\.1.*master.*/192\.168\.77\.1#{i} k8s#{i}/' -i /etc/hosts"
      
      if i == 1
        #master node
        c.vm.provision "shell", inline: "kubeadm init --apiserver-advertise-address 192.168.77.11 --token 7d0576.ee0f7f72653463dd"
        c.vm.provision "shell", path: "master-setup.sh", privileged: false
      else
        #minion nodes
        c.vm.provision "shell", inline: "kubeadm join --token 7d0576.ee0f7f72653463dd 192.168.77.11:6443"
        c.vm.provision "shell", inline: "route add 10.96.0.1 gw 192.168.77.11"
      end            
    end
  end
  
  if Vagrant.has_plugin?("vagrant-cachier")
      config.cache.scope = :box
  end

end