#!/bin/bash
for SSHD_USER in ${SSHD_USERS[@]}; do
    if ! getent passwd ${SSHD_USER}; then
        useradd --shell /bin/bash --create-home ${SSHD_USER}
        install --owner ${SSHD_USER} --group ${SSHD_USER} --mode 0700 --directory /home/${SSHD_USER}/.ssh
        curl --silent --location --output /home/${SSHD_USER}/.ssh/authorized_keys "${SSHD_KEY_LOC}/${SSHD_USER}"
    fi
done

if [ ! -d /config/ssh/keys ]; then
    mkdir --parents /config/ssh/keys
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
    mkdir --parents /var/run/sshd
fi

$(which sshd) -E /var/log/sshd.log

pidfile=/var/run/denyhosts.pid

if [ -f ${pidfile} ]; then
    pid=$(cat ${pidfile})

    if [[ ! -d /proc/${pid} || ( -d /proc/${pid} && $(basename $(readlink /proc/${pid}/exe)) != 'python2.7' ) ]]; then
        rm ${pidfile}
    fi
fi

exec $(which denyhosts) \
    --file /var/log/sshd.log \
    --foreground
