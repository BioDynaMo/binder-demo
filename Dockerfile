FROM biodynamo/notebooks:ce0ac29b0e6f

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# Copy source script and set permissions
COPY ./start.sh /
RUN ["chmod", "+x", "/start.sh"]

# Add ROOT configuration options to jupyter. These would normally be added
# when running `root --notebook`, but since Binder runs with the `jupyter`
# command, we need to add it explicitely ourselves
COPY ./jupyter_notebook_config.py ${HOME}/.jupyter/jupyter_notebook_config.py

USER root

# Copy the notebooks 
RUN mkdir -p ${HOME}/notebooks
RUN for d in /opt/biodynamo/notebooks/*  ; do \
        dl=$(basename $d); \
        mkdir -p ${HOME}/notebooks/$dl ;\
        cp -v $d/*.ipynb ${HOME}/notebooks/$dl ; \
        for l in $d/*.h ; do \
            ll=$(basename $l); \
            if [ $ll != $dl.h ]; then \
                cp -v $l ${HOME}/notebooks/$dl ; \
            fi ;\
        done; \
    done 

RUN sudo adduser ${NB_USER} sudo
RUN echo "${NB_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chown -R ${NB_UID} ${HOME}
RUN chown -R ${NB_UID} /opt/biodynamo/bin
USER ${NB_USER}

WORKDIR ${HOME}/notebooks
ENTRYPOINT ["/start.sh"]
