# k8s-vagrant
<img src="https://kubernetes.io/images/favicon.png" width="100" height="100" /> <img src="https://hyzxph.media.zestyio.com/Vagrant_VerticalLogo_FullColor.rkvQk0Hax.svg" width="100" height="100" />

This Vagrant project will start a local kubernetes cluster, bootstrapped using kubeadm. 

See [here](https://kubernetes.io/docs/admin/kubeadm/) for details regrading kubeadm.

## Prerequisites

The project has been tested and known to work with Vagrant >=v2.0.0. To Download Vagrant, head over to HashiCorp's Vagrant [download page](https://www.vagrantup.com/downloads.html).

## Usage

1. Clone the repo
    ```shell
    $ git clone https://github.com/HagaiBarel/k8s-vagrant.git
    ```

2. Open a terminal from the root of the repository, and run

    ```shell
    $ vagrant up
    ```

By default, Vagrant will preform the following:
- Provision a Kubernetes master node, with the local ip of 192.168.77.10
- Provision 3 worker nodes, each with a consecutive IP address and name, i.e. 
  - kube-worker1, IP 192.168.77.11 
  - kube-worker2, IP 192.168.77.12
  - etc. 
- Bootstrap each node with kubeadm and all dependencies
- Install weave-net CNI plugin to allow inter-cluster networking
- Place a kubecfg file in the root of the Vagrant folder after the master has been provisioned. The file will be named `k8s-vagrant`, and is actually the `admin.conf` file found in the master node's `/etc/kubernetes` folder and placed in the `/vagrant` shared folder for convenience

If you'd like to provision just the master, run
```shell
$ vagrant up kube-master
```

To check the environment status, run
```shell
$ vagrant status
```

### Communicating with the Cluster
In order to communicate with the cluster, you'll need to use the config file from the cluster.

There are a couple of options for doing that:
1. use the kubeconfig flag with each `kubectl` call.
   for example:
   ```shell
   $ kubectl get nodes --kubeconfig=k8s-vagrant
   ```

2. Modify the $KUBECONFIG environment variable. The method changes from one OS to another, see [here](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/#set-the-kubeconfig-environment-variable) for details

3. Merge the `k8s-vagrant` file contents with your `$HOME/.kube/config` file. Note that this option is the least preferred method, as you'll need to preform this action every time you run `vagrant up` from scratch.

### Clean up
To delete the cluster and all resources, run `vagrant destroy` from the repository's root folder.

## Defaults

Most of the default parameters are configurable and defined in the top of the Vagrantfile.

Below is a list of the default parameters:

parameter  | value  | description |
| -------- | ------ | ----------- |
box_base | `ubuntu/xenial64` | the base box for all VMs, Ubuntu 16.04 64bit
box_cpu_count | `1` | number of CPUs for each VM
box_ram_mb | `2048` | amount of ram (in Mb) for each VM
master_ip | `192.168.77.10`| local IP for master node
join_token | `7d0576.ee0f7f72653463dd` | token for connecting the master and workers
worker_count | `3` | number of worker nodes
kubernetes_version | `v1.10.2` | kubernetes api server version

Feel free to modify these values to your needs.

## Notes

Please note that by default, kubeadm starts the api server in RBAC authorization mode (see [here](https://kubernetes.io/docs/admin/authorization/rbac/) for further details). 

While I strongly encourage using RBAC for authorization, it can cause some issues when trying to run Helm's server (tiller) in the cluster. This can be easily solved, and you can find a script that bootstraps helm by creating the needed resources in the root of the repo (look for [bootstrap-helm.sh](./bootstrap-helm.sh)).

To create the service account and role binding, and install tiller with the proper service account, run 

```shell
$ ./bootstrap-helm.sh
```

from the terminal (using the `k8s-vagrant` context). Refer to [this](https://github.com/kubernetes/helm/blob/master/docs/service_accounts.md) link for further details.

## Sharing is Caring

This project is licensed under the MIT license, which means you are free to use and modify it to your heart's desire, as long as you provide credit. See the license details [here](./LICENSE).

Please note that this project is distributed As-Is, and no warranty is provided. <i>Use at your own risk.</i>

## Contribution

Contributes are welcomed! If you'd like to contribute please do the following - 
1. Fork the repo
2. Make your changes
3. Submit a pull request

See this [link](https://github.com/MarcDiethelm/contributing/blob/master/README.md) for some good instructions on contributing to a GitHub project.
