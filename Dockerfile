ARG OS_VER=${OS_VER}
ARG DPDK_VER=${DPDK_VER}
ARG OFED_VER=${OFED_VER}
FROM centos:${OS_VER}
MAINTAINER Amir Zeidner

WORKDIR /

# Install prerequisite packages
RUN yum update -y &&  yum install -y \
numactl-devel \
numactl \
unzip \
wget \
gcc \
ethtool \
net-tools \
python36 \
epel-release \
dnf-plugins-core 

RUN yum config-manager --set-enabled powertools ; exit 0

RUN easy_install-3.6 pip && pip3 install meson

RUN yum install -y \
ninja-build 

# Install MOFED - If no MOFED version supplied install from upstream 
ARG OFED_VER
ARG OS_VER
RUN if [ "$OFED_VER" != "" ] ; then  cd /etc/yum.repos.d && wget https://linux.mellanox.com/public/repo/mlnx_ofed/${OFED_VER}/rhel${OS_VER:0:3}/mellanox_mlnx_ofed.repo ; fi
RUN yum install -y \
rdma-core-devel \
libibverbs-utils 

# Download and compile DPDK
ARG DPDK_VER
RUN cd /usr/src/ &&  wget http://dpdk.org/browse/dpdk/snapshot/dpdk-${DPDK_VER}.zip && unzip dpdk-${DPDK_VER}.zip 
ENV DPDK_DIR=/usr/src/dpdk-${DPDK_VER}
RUN cd $DPDK_DIR && meson build
RUN cd $DPDK_DIR/build && ninja
RUN cd $DPDK_DIR/build && ninja install

# Remove unnecessary packages and files
RUN rm -rf /tmp/* && rm /usr/src/dpdk-${DPDK_VER}.zip && yum clean all
