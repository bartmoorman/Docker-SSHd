FROM bmoorman/ubuntu

ENV SSHD_USERS="docker" \
    SSHD_KEY_LOC="https://raw.githubusercontent.com/iVirus/Docker/master/SSHd/keys"

RUN apt-get update && \
    apt-get dist-upgrade --yes && \
    apt-get install --yes --no-install-recommends curl denyhosts openssh-server iputils-ping && \
    apt-get autoremove --yes --purge && \
    apt-get clean && \
    rm --recursive --force /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ssh/ /etc/ssh/

CMD ["/etc/ssh/start.sh"]

EXPOSE 22
