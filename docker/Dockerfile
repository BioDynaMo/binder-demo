
FROM ubuntu:18.04

# man required by ROOT
RUN apt-get update && apt-get install -y \
  git \
  sudo \
  man \
  software-properties-common \
  wget \
  xvfb \
  wget \
  libopenmpi-dev \
  libomp-dev \
  libnuma-dev \
  libtbb-dev \
  libpthread-stubs0-dev \
  nodejs \
  yarn \
  npm

RUN if ! [ -L /etc/localtime ]; then \
      sudo ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime; \
    fi

RUN apt-get update && apt-get -y update
RUN apt-get install -y build-essential python3.6 python3-pip python3-dev
RUN pip3 install --no-cache-dir notebook==5.*
RUN pip3 install jupyter 

ARG BDM_VERSION=v0.1.0 
RUN wget "http://cern.ch/biodynamo-lfs/biodynamo-$BDM_VERSION.tar.gz"
RUN mkdir -p $HOME/biodynamo 
RUN tar -zxf biodynamo-${BDM_VERSION}.tar.gz -C $HOME/biodynamo 
RUN npm install -g requirejs 

RUN ["/bin/bash", "-c", "source $HOME/biodynamo/bin/binder_thisbdm.sh"]





