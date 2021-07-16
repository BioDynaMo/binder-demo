FROM ubuntu:20.04


ENV TZ=Europe/Berlin

RUN if ! [ -L /etc/localtime ]; then \
      ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime; \
    fi
# Install prerequisites for BioDynaMo
RUN apt-get update && apt-get install -y --no-install-recommends \
  sudo \
  wget \
  libopenmpi-dev \
  libomp-dev \
  libnuma-dev \
  libtbb-dev \
  libpthread-stubs0-dev \
  curl \ 
  git \
  make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget ca-certificates curl llvm libncurses5-dev \
  ninja-build\
  libffi-dev\
  bsdmainutils\
  doxygen  

RUN if ! [ -L /etc/localtime ]; then \
      sudo ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime; \
    fi

RUN apt -y update
# RUN apt install -y build-essential python3.8 python3.8-dev python3-pip




# RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# USER docker

RUN mkdir -p /build_dir
# RUN chown docker /build_dir

WORKDIR /build_dir
RUN curl -L -O https://github.com/Kitware/CMake/releases/download/v3.19.3/cmake-3.19.3-Linux-x86_64.sh
RUN chmod +x cmake-3.19.3-Linux-x86_64.sh
RUN sudo ./cmake-3.19.3-Linux-x86_64.sh --skip-license --prefix=/usr/local

ENV HOME /build_dir

RUN if [ ! -f "$HOME/.pyenv/bin/pyenv" ]; then \
          curl https://pyenv.run | bash; \
    fi 


ENV PYTHON_VERSION 3.9.1
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
# RUN set -ex \
#     && curl https://pyenv.run | bash \
#     && pyenv update \
#     && pyenv install $PYTHON_VERSION \
#     && pyenv global $PYTHON_VERSION \
#     && pyenv rehash


# 
# 
RUN git clone https://github.com/BioDynaMo/biodynamo.git
WORKDIR /build_dir/biodynamo
RUN eval "$(pyenv init --path)"
RUN eval "$(pyenv init -)"
RUN PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install 3.9.1 && pyenv global 3.9.1

RUN pyenv global 3.9.1
RUN pyenv local 3.9.1


RUN python -m pip install --no-cache-dir notebook==5.*
RUN python -m pip install jupyter metakernel jupyterlab ipykernel 


RUN cmake -G Ninja \
    -Dparaview=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -B build\
    -Dnotebooks=ON
RUN cmake --build build --parallel --config Release


WORKDIR /build_dir/biodynamo/build
# RUN . bin/thisbdm.sh
SHELL ["/bin/bash", "-c", "source /build_dir/biodynamo/build/bin/thisbdm.sh"]
ENV DISPLAY=:99.0
RUN ninja run-unit-tests

# ENTRYPOINT ["tail",  "-f", "/build_dir/biodynamo/build/bin/thisbdm.sh"]



# Install BioDynaMo
# ARG BDM_VERSION=v0.9.21
# RUN wget "http://cern.ch/biodynamo-lfs/biodynamo-$BDM_VERSION.tar.gz"
# RUN mkdir -p /opt/biodynamo 
# RUN tar -zxf biodynamo-${BDM_VERSION}.tar.gz -C /opt/biodynamo
# RUN rm biodynamo-${BDM_VERSION}.tar.gz 
