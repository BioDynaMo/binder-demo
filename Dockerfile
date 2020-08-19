FROM biodynamo/notebooks:latest
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} /opt
USER ${NB_USER}

RUN ["/bin/bash", "-c", "source /opt/biodynamo/bin/binder_thisbdm.sh"]
RUN ["/bin/bash", "-c", "source /opt/biodynamo/third_party/root/bin/thisroot.sh"]
