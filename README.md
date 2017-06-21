```
docker run \
--rm \
--detach \
--init \
--name sshd \
--publish 2222:22 \
--env "SSHD_USERS=docker" \
--env "SSHD_KEY_LOC=https://raw.githubusercontent.com/iVirus/Docker/master/SSHd/keys" \
bmoorman/sshd
```
