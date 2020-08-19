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

USER root
RUN chown -R ${NB_UID} ${HOME}
RUN chown -R ${NB_UID} /opt/biodynamo
USER ${NB_USER}

ENTRYPOINT ["/start.sh"]
