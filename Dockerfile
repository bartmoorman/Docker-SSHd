FROM bmoorman/ubuntu

ENV SSHD_USERS="docker" \
    SSHD_KEY_LOC="https://raw.githubusercontent.com/iVirus/Docker/master/SSHd/keys"

ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get update \
 && apt-get install --yes --no-install-recommends \
    curl \
    denyhosts \
    iputils-ping \
    openssh-server \
    python-setuptools \
 && easy_install speedtest-cli \
 && apt-get autoremove --yes --purge \
 && apt-get clean \
 && rm --recursive --force /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY sshd/ /etc/sshd/

EXPOSE 22

CMD ["/etc/sshd/start.sh"]
