ARG DOCKER_USER
ARG USER_UID
RUN useradd -m $DOCKER_USER -u ${USER_UID} -s /bin/bash
# passwd is docker
RUN echo "$DOCKER_USER:docker" | chpasswd && adduser $DOCKER_USER sudo
RUN RUN echo 'Defaults:$DOCKER_USER timestamp_timeout=-1' | tee -a /etc/sudoers
USER $DOCKER_USER
ADD customized.bashrc /tmp/.
RUN cat /tmp/customized.bashrc >> ~/.bashrc
