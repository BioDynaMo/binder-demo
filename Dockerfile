FROM biodynamo/notebooks:d13ec0f6a6ba

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

RUN mkdir -p ${HOME}/notebooks

# Copy the generated html notebooks into the static folder
RUN for d in /opt/biodynamo/notebooks/*  ; do \
    cp -v $d/*.ipynb ${HOME}/notebooks/ ;\
    done 

# Copy source script and set permissions
COPY ./start.sh /
RUN ["chmod", "+x", "/start.sh"]

# Add ROOT configuration options to jupyter. These would normally be added
# when running `root --notebook`, but since Binder runs with the `jupyter`
# command, we need to add it explicitely ourselves
COPY ./jupyter_notebook_config.py ${HOME}/.jupyter/jupyter_notebook_config.py

USER root
RUN sudo adduser ${NB_USER} sudo
RUN echo "${NB_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chown -R ${NB_UID} ${HOME}
RUN chown -R ${NB_UID} /opt/biodynamo/bin
USER ${NB_USER}

WORKDIR ${HOME}/notebooks
ENTRYPOINT ["/start.sh"]
