FROM ubuntu:14.04

# Update and upgrade
RUN apt-get update && apt-get -y upgrade

# Install basics
RUN apt-get install -y build-essential patch g++ rpm zlib1g zlib1g-dev m4 bison libncurses5-dev \
    libglib2.0-dev gettext tcl intltool libxml2-dev liborbit2-dev libx11-dev ccache flex \
    uuid-dev liblzo2-dev mtd-utils libexpat1-dev texinfo imagemagick graphviz doxygen gawk \
    openbsd-inetd nfs-kernel-server ntp subversion ttf-freefont libfribidi-dev libcairo2-dev \
    xsltproc libgnutls-openssl27 u-boot-tools libssl-dev zeroc-ice35 wget git-core \
    lib32z-dev sudo vim xterm

# Install openssl manually to build with SSL2 suport (ubuntu version is built with NO_SSL2 flag)
# needed to compile LTIB's wget see https://community.nxp.com/thread/289198
# Need to 'export LDFLAGS=-L/usr/local/ssl/lib; export CPPFLAGS=-I/usr/local/ssl/include'
# before calling ./ltib see ENVs below
RUN cd /tmp && wget https://www.openssl.org/source/openssl-1.0.2n.tar.gz \
    && tar xzf openssl-1.0.2n.tar.gz && cd openssl-1.0.2n \
    && ./config shared && make && make install

# Set up locale
RUN apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# User management
RUN groupadd -g 1000 cmonkey && useradd -u 1000 -g 1000 -ms /bin/bash cmonkey && usermod -a -G sudo cmonkey && usermod -a -G users cmonkey
RUN mkdir -p /home/cmonkey && chown cmonkey:cmonkey /home/cmonkey

# Allow use of rpm and ltib rpm without sudo permision
RUN echo 'cmonkey ALL= NOPASSWD: /usr/bin/rpm, /opt/freescale/ltib/usr/bin/rpm' >> /etc/sudoers
# Allow users in the sudo group to sudo without password
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER cmonkey

WORKDIR /home/workspace

ENV LDFLAGS -L/usr/local/ssl/lib
ENV CPPFLAGS -I/usr/local/ssl/include