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
RUN python3.8 -m pip install jupyterlab 
RUN chown -R ${NB_UID} ${HOME}
RUN chown -R ${NB_UID} /opt/biodynamo/bin
USER ${NB_USER}

ENTRYPOINT ["/start.sh"]
