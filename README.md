# How to build CentOS Docker container with Nvidia Mellanox DPDK drivers
 
In order to build a docker image, git clone the project and use the Dockerfile as explained in this Wiki.

## 1. Cloning:

`git clone https://github.com/chen622/mlnx_docker_dpdk.git`

## 2. Building Docker image - For example run:

`docker build --build-arg OS_VER=7.6.1810 --build-arg DPDK_VER=21.11 --build-arg OFED_VER=5.4-3.4.0.0 --build-arg KERNEL_URL=https://mirrors.tuna.tsinghua.edu.cn/centos-vault/7.6.1810/os/x86_64/Packages/kernel-3.10.0-957.el7.x86_64.rpm -t centos/<image_name>:<version_name> .`


* OS_VER - CentOS image version

* DPDK_VER - DPDK version

* OFED_VER - Nvidia Mellanox MOFED version. **Not** specifying MOFED version will install default MOFED upstream packages.

* <image_name> and <version_name> - Can be any user defined name

> Note: Please refer to DPDK release note to validate which DPDK version is supported in a combination of which OS.

> Note: OS versions: ubuntu18.04, ubuntu14.04 , ubuntu16.04 , rhel7.2 , rhel7.3 can be used with different Dockerfile which is available in this git project under unique branch.

## 3. Running Docker image:

`docker run --name <image_name> --net=host -h "<host_name>" -itd --privileged -v /sys/kernel/mm/hugepages:/sys/kernel/mm/hugepages -v /dev/hugepages:/dev/hugepages centos/<image_name>:<version_name> /sbin/init`