#!/bin/bash
for SSHD_USER in ${SSHD_USERS[@]}; do
    if ! getent passwd ${SSHD_USER}; then
        useradd --shell /bin/bash --create-home ${SSHD_USER}
        install --owner ${SSHD_USER} --group ${SSHD_USER} --mode 0700 --directory /home/${SSHD_USER}/.ssh
        curl --silent --location --output /home/${SSHD_USER}/.ssh/authorized_keys "${SSHD_KEY_LOC}/${SSHD_USER}"
    fi
done

if [ ! -d /var/run/sshd ]; then
    rm --force /etc/ssh/ssh_host_*
    DEBIAN_FRONTEND="noninteractive" dpkg-reconfigure openssh-server
    mkdir --parents /var/run/sshd
fi

$(which sshd) -E /var/log/sshd.log

exec $(which denyhosts) \
    --file /var/log/sshd.log \
    --foreground
