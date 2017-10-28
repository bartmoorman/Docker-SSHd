```
docker run \
--rm \
--detach \
--name sshd \
--hostname sshd \
--publish 2222:22 \
--env "SSHD_USERS=bmoorman" \
--env "SSHD_KEY_LOC=https://raw.githubusercontent.com/iVirus/Docker-SSHd/master/keys" \
bmoorman/sshd
```
