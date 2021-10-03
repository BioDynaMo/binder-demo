FROM biodynamo/notebooks:

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER jovyan
ENV NB_UID 1000
ENV HOME /home/jovyan


ENV BUILD_HOME /build_dir

RUN sudo adduser --disabled-password \
    --gecos "Default user" \
    --uid 1000 \
    jovyan


# Copy source script and set permissions
COPY ./start.sh /
RUN ["chmod", "+x", "/start.sh"]

# Add ROOT configuration options to jupyter. These would normally be added
# when running `root --notebook`, but since Binder runs with the `jupyter`
# command, we need to add it explicitely ourselves
COPY ./jupyter_notebook_config.py ${HOME}/.jupyter/jupyter_notebook_config.py

# USER root

# Copy the notebooks 
RUN mkdir -p ${HOME}/notebook
RUN cp -R ${BUILD_HOME}/biodynamo/notebook ${HOME}/notebook
# RUN for d in ${BUILD_HOME}/biodynamo/notebooks/*  ; do \
#         dl=$(basename $d); \
#         mkdir -p ${HOME}/notebooks/$dl ;\
#         cp -v $d/*.ipynb ${HOME}/notebooks/$dl ; \
#         for l in $d/*.h ; do \
#             ll=$(basename $l); \
#             if [ $ll != $dl.h ]; then \
#                 cp -v $l ${HOME}/notebooks/$dl ; \
#             fi ;\
#         done; \
#     done 


RUN sudo adduser jovyan sudo
RUN echo "jovyan ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chown -R 1000 ${HOME}
RUN chown -R 1000 ${BUILD_HOME}/biodynamo/build/
RUN chown -R 1000 /usr/local/share/jupyter
# RUN chown -R 1000 /usr/share/jupyter/nbconvert/templates/conf.json
RUN chmod +755 /usr/local/share/jupyter
# change the permissions on the directories to group, other read and execute
RUN find /usr/share/jupyter/ -type d -exec chmod go+rx {} \;

# change all the other files to group, other read
RUN find /usr/share/jupyter/ -type f -exec chmod  go+r {} \;

# change all the executables to group, other execute
RUN find /usr/share/jupyter/ -type f -perm -100 -exec chmod go+x {} \;


# change the permissions on the directories to group, other read and execute
RUN find /build_dir/.pyenv/versions/3.9.1/share/jupyter/ -type d -exec chmod go+rx {} \;

# change all the other files to group, other read
RUN find /build_dir/.pyenv/versions/3.9.1/share/jupyter/ -type f -exec chmod  go+r {} \;

# change all the executables to group, other execute
RUN find /build_dir/.pyenv/versions/3.9.1/share/jupyter/ -type f -perm -100 -exec chmod go+x {} \;


USER jovyan

WORKDIR ${HOME}/notebook
# WORKDIR ${HOME}/notebooks
# ENTRYPOINT ["tail",  "-f", "/start.sh"]
ENTRYPOINT ["bash","/start.sh"]
