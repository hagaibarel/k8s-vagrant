# -*- mode: ruby -*-
# vi: set ft=ruby :

# Install a kube cluster using kubeadm:
# http://kubernetes.io/docs/getting-started-guides/kubeadm/

### configuration parameters
### Box parameters
BOX_BASE = "ubuntu/xenial64"
BOX_CPU_COUNT = 1
BOX_RAM_MB = "2048"
### kubeadm parameters
master_ip = "192.168.77.10"
token = "7d0576.ee0f7f72653463dd"
worker_count = 2

Vagrant.configure("2") do |config|
  config.vm.box = BOX_BASE
  config.vm.box_check_update = false
  config.vm.provision "shell", path: "install.sh"
  
  # use cache plugin if available
  # https://github.com/fgrehm/vagrant-cachier
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.vm.provider "virtualbox" do |vb|
    vb.cpus = BOX_CPU_COUNT
    vb.memory = BOX_RAM_MB
  end

  # master node configuration
  config.vm.define "kube-master" do |c|
    c.vm.hostname = "kube-master"
    c.vm.network "private_network", ip: master_ip
    
    c.vm.provision "shell" do |s|
      s.inline = "sed 's/127.0.0.1.*kube-master/'$1' kube-master/' -i /etc/hosts"
      s.args = [master_ip]
    end
    c.vm.provision "shell" do |s|
      s.path = "master-setup.sh"
      s.privileged = false
      s.args = [master_ip, token]
    end
  end
  
  # worker nodes configuration
  (1..worker_count).each do |i|
    config.vm.define "kube-worker#{i}" do |c|
      worker_ip = master_ip.split('.').tap{|n| n[-1] = n[-1].to_i + i}.join('.')
      c.vm.hostname = "kube-worker#{i}"
      c.vm.network "private_network", ip: worker_ip
            
      c.vm.provision "shell" do |s|
        s.inline = "sed 's/127.0.0.1.*kube-worker#{i}/'$1' kube-worker#{i}/' -i /etc/hosts"
        s.args = [worker_ip]
      end
      c.vm.provision "shell" do |s|
        s.path = "worker-setup.sh"
        s.args = [master_ip, token]
      end             
    end
  end
end