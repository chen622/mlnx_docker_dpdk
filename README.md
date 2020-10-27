## How to build CentOS Docker container with Nvidia Mellanox DPDK drivers
 
In order to build a docker image, git clone the project and use the Dockerfile as explained in this Wiki.

Cloning:

`git clone https://github.com/Mellanox/mlnx_docker_dpdk`

Building Docker image - For example run:

`docker build --build-arg OS_VER=7.7.1908 --build-arg DPDK_VER=20.02 --build-arg OFED_VER=5.1-2.3.7.1 -t centos/<image_name>:<version_name> .`

* OS_VER - CentOS image version

* DPDK_VER - DPDK version

* OFED_VER - Nvidia Mellanox MOFED version. **Not** specifying MOFED version will install default MOFED upstream packages.

* <image_name> and <version_name> - Can be any user defined name

> Note: Please refer to DPDK release note to validate which DPDK version is supported in a combination of which OS.

> Note: OS version: ubuntu18.04, ubuntu14.04 , ubuntu16.04 , rhel7.2 , rhel7.3 can be used with different Dockerfile which is available in this git project under unique branch.
