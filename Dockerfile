FROM bmoorman/ubuntu:bionic

ENV SSHD_USERS="docker" \
    SSHD_KEY_LOC="https://raw.githubusercontent.com/iVirus/Docker/master/SSHd/keys"

ARG DEBIAN_FRONTEND="noninteractive"

RUN echo 'deb https://ookla.bintray.com/debian bionic main' > /etc/apt/sources.list.d/speedtest.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61 \
 && apt-get update \
 && apt-get install --yes --no-install-recommends \
    curl \
    iputils-ping \
    mtr-tiny \
    net-tools \
    openssh-server \
    speedtest \
 && sed --in-place --regexp-extended \
    --expression 's/^#(PasswordAuthentication\s+).*/\1no/' \
    --expression 's/^#(GatewayPorts\s+).*/\1yes/' \
    /etc/ssh/sshd_config \
 && apt-get autoremove --yes --purge \
 && apt-get clean \
 && rm --recursive --force /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY sshd/ /etc/sshd/

VOLUME /config

EXPOSE 22

CMD ["/etc/sshd/start.sh"]
