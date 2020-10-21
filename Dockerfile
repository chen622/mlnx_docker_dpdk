ARG OS_VER=${OS_VER} 
ARG DPDK_VER=${DPDK_VER}
FROM centos:${OS_VER}
MAINTAINER Amir Zeidner

WORKDIR /

# Install prerequisite packages
RUN yum update -y &&  yum install -y \
libnl \
numactl-devel \
numactl \
unzip \
wget \
make \
gcc \
ethtool \
net-tools \
rdma-core-devel

# Download and compile DPDK
ARG DPDK_VER
RUN cd /usr/src/ &&  wget http://dpdk.org/browse/dpdk/snapshot/dpdk-${DPDK_VER}.zip && unzip dpdk-${DPDK_VER}.zip 
ENV DPDK_DIR=/usr/src/dpdk-${DPDK_VER}  DPDK_TARGET=x86_64-native-linuxapp-gcc DPDK_BUILD=$DPDK_DIR/$DPDK_TARGET
RUN cd $DPDK_DIR && sed -i 's/\(CONFIG_RTE_LIBRTE_MLX5_PMD=\)n/\1y/g' $DPDK_DIR/config/common_base
RUN cd $DPDK_DIR && make install T=$DPDK_TARGET DESTDIR=install

# Remove unnecessary packages and files
RUN rm -rf /tmp/* && rm /usr/src/dpdk-${DPDK_VER}.zip
