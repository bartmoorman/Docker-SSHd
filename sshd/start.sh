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

if [ ! -f /var/log/denyhost ] && [ ! -f /var/lib/denyhosts/offset ]; then
    sed --in-place --regexp-extended \
    --expression 's/^(IPTABLES\s+=\s+.*)/#\1/' \
    --expression 's/^(ADMIN_EMAIL\s+=\s+.*)/#\1/' \
    --expression '/^#USERDEF_FAILED_ENTRY_REGEX/!b;n;cUSERDEF_FAILED_ENTRY_REGEX = Failed (?P<method>\\S*) for (?P<invalid>invalid user |illegal user )?(?P<user>.*) from (::ffff:)?(?P<host>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})( port \\d+)?( ssh2)?' \
    /etc/denyhosts.conf
fi

exec $(which denyhosts) \
    --file /var/log/sshd.log \
    --foreground
