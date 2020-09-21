#!/bin/bash
for SSHD_USER in ${SSHD_USERS}; do
    if ! getent passwd ${SSHD_USER} > /dev/null; then
        useradd --shell /bin/bash --create-home ${SSHD_USER}
        install --owner ${SSHD_USER} --group ${SSHD_USER} --mode 700 --directory /home/${SSHD_USER}/.ssh
        curl --silent --location --output /home/${SSHD_USER}/.ssh/authorized_keys "${SSHD_KEY_LOC}/${SSHD_USER}"
    fi
done

if [ ! -d /config/ssh/keys ]; then
    install --directory /config/ssh/keys
fi

for HOST_KEY in /etc/ssh/ssh_host_*_key; do
    TYPE=$(cut -d_ -f3 <<< ${HOST_KEY##*/})
    if [ ! -f /config/ssh/keys/ssh_host_${TYPE}_key ]; then
        ssh-keygen -q -f /config/ssh/keys/ssh_host_${TYPE}_key -t ${TYPE} -N ''
    fi
    rm --force /etc/ssh/ssh_host_${TYPE}_key*
    ln --symbolic /config/ssh/keys/ssh_host_${TYPE}_key* /etc/ssh
done

if [ ! -d /var/run/sshd ]; then
    install --directory /var/run/sshd
fi

exec $(which sshd) \
    -D \
    -e \
    -p ${SSHD_PORT}
