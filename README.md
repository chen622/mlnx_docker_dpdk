In order to build a docker image, git clone the project and use the Dockerfile as follow:

Run:
docker build --build-arg OS_VER=7.7.1908 --build-arg  DPDK_VER=20.02 -t centos/<image_name>:<version_name> .

OS_VER - Is CentOS image version
DPDK_VER - Is DPDK versrion
<image_name> and <version_name> can be any user-defined name

The user gets the option to determine which DPDK version to use by specifying DPDK_VER=<version_number>
Please refer to the DPDK release notes to know which versions are supported on which OS.

Note: OS version: ubuntu18.04, ubuntu14.04 , ubuntu16.04 , rhel7.2 , rhel7.3
Requires MOFED installation and can be used with different Docker file which is available in this git project under unique tag.
