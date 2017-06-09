#!/bin/bash
for SSHD_USER in ${SSHD_USERS[@]}; do
    if ! getent passwd ${SSHD_USER}; then
        useradd --shell /bin/bash --create-home ${SSHD_USER}
        install --owner ${SSHD_USER} --group ${SSHD_USER} --mode 0700 --directory /home/${SSHD_USER}/.ssh
        curl --silent --location --output /home/${SSHD_USER}/.ssh/authorized_keys "${SSHD_KEY_LOC}/${SSHD_USER}"
    fi
done

exec $(which sshd) \
    -D \
    -e
