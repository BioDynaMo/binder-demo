FROM ubuntu:18.04

# Install prerequisites for BioDynaMo
RUN apt-get update && apt-get install -y \
  sudo \
  wget \
  libopenmpi-dev \
  libomp-dev \
  libnuma-dev \
  libtbb-dev \
  libpthread-stubs0-dev \
  curl

RUN if ! [ -L /etc/localtime ]; then \
      sudo ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime; \
    fi

RUN apt -y update
RUN apt install -y build-essential python3.8 python3.8-dev python3-pip
RUN python3.8 -m pip install --no-cache-dir notebook==5.*
RUN python3.8 -m pip install jupyter metakernel

# Install BioDynaMo
ARG BDM_VERSION=v0.1.0
RUN wget "http://cern.ch/biodynamo-lfs/biodynamo-$BDM_VERSION.tar.gz"
RUN mkdir -p /opt/biodynamo 
RUN tar -zxf biodynamo-${BDM_VERSION}.tar.gz -C /opt/biodynamo
RUN rm biodynamo-${BDM_VERSION}.tar.gz 
