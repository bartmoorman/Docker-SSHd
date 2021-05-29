FROM bmoorman/ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive

ENV SSHD_PORT=22

RUN echo 'deb https://packagecloud.io/ookla/speedtest-cli/ubuntu/ focal main' > /etc/apt/sources.list.d/ookla_speedtest-cli.list \
 && echo 'deb-src https://packagecloud.io/ookla/speedtest-cli/ubuntu/ focal main' >> /etc/apt/sources.list.d/ookla_speedtest-cli.list \
 && curl --silent --location "https://packagecloud.io/ookla/speedtest-cli/gpgkey" | apt-key add \
 && apt-get update \
 && apt-get install --yes --no-install-recommends \
    dnsutils \
    iputils-ping \
    mtr-tiny \
    net-tools \
    openssh-server \
    rsync \
    speedtest \
 && sed --in-place --regexp-extended \
    --expression 's|^#(PasswordAuthentication\s+).*|\1no|' \
    --expression 's|^#(GatewayPorts\s+).*|\1yes|' \
    /etc/ssh/sshd_config \
 && apt-get autoremove --yes --purge \
 && apt-get clean \
 && rm --recursive --force /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY sshd/ /etc/sshd/

VOLUME /config

EXPOSE ${SSHD_PORT}

CMD ["/etc/sshd/start.sh"]
