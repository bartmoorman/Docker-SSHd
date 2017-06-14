FROM ubuntu:xenial

ENV TZ="America/Denver" \
    LANG="C.UTF-8" \
    SSHD_USERS="docker" \
    SSHD_KEY_LOC="https://raw.githubusercontent.com/iVirus/Docker/master/SSHd/keys"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get dist-upgrade --yes && \
    apt-get install --yes --no-install-recommends tzdata openssh-server curl ca-certificates fail2ban && \
    mkdir /var/run/sshd && \
    apt-get autoremove --yes --purge && \
    apt-get clean && \
    rm --recursive --force /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ssh/ /etc/ssh/

CMD ["/etc/ssh/start.sh"]

EXPOSE 22
