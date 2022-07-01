ARG OS_VER=${OS_VER}
FROM centos:${OS_VER}
ARG OS_VER
ARG DPDK_VER=${DPDK_VER}
ARG OFED_VER=${OFED_VER}
ARG DOWNLOAD_DIR=/opt/
ARG KERNEL_URL=${KERNEL_URL}
ARG KERNEL_DEVEL_URL=${KERNEL_DEVEL_URL}
MAINTAINER Chenming C ccm@ccm.ink

WORKDIR /

RUN mkdir -p ${DOWNLOAD_DIR}

RUN sed -e 's|^mirrorlist=|#mirrorlist=|g' \
             -e 's|^#baseurl=http://mirror.centos.org|baseurl=https://mirrors.tuna.tsinghua.edu.cn|g' \
             -i.bak \
             /etc/yum.repos.d/CentOS-*.repo

# Install prerequisite packages
RUN yum makecache && yum install -y \
libnl \
numactl-devel \
numactl \
unzip \
make \
gcc \
ethtool \
net-tools \
perl \
wget \
pciutils-libs \
pciutils \
gcc-gfortran \
tcsh libusbx \
lsof \
libnl3 \
tcl  \
libmnl  \
fuse-libs  \
tk \
python3 \
which \
sysvinit-tools \
python-devel \
redhat-rpm-config \
rpm-build \
libtool \
createrepo \
ca-certificates

RUN if [ "$KERNEL_URL" != "" ] ; then cd ${DOWNLOAD_DIR} && wget -q ${KERNEL_URL} && wget -q ${KERNEL_DEVEL_URL} && yum localinstall -y kernel-*.rpm ; fi

# Install MOFED
RUN cd $DOWNLOAD_DIR && wget -q https://content.mellanox.com/ofed/MLNX_OFED-${OFED_VER}/MLNX_OFED_LINUX-${OFED_VER}-rhel${OS_VER:0:3}-x86_64.tgz

RUN cd $DOWNLOAD_DIR && tar -xzvf MLNX_OFED_LINUX-${OFED_VER}-rhel${OS_VER:0:3}-x86_64.tgz && cd MLNX_OFED_LINUX-${OFED_VER}-rhel${OS_VER:0:3}-x86_64 && ./mlnxofedinstall --add-kernel-support --without-fw-update --dpdk -q

RUN pip3 install meson ninja pyelftools

# Download and compile DPDK
RUN cd $DOWNLOAD_DIR &&  wget https://fast.dpdk.org/rel/dpdk-${DPDK_VER}.tar.xz && mkdir dpdk-${DPDK_VER} && tar -xvf dpdk-${DPDK_VER}.tar.xz -C dpdk-${DPDK_VER} --strip-components 1
RUN cd ${DOWNLOAD_DIR}/dpdk-${DPDK_VER} && meson build && cd build && ninja  && ninja install

# Remove unnecessary packages and files
RUN rm -rf /tmp/*
