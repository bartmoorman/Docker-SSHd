### Usage
```
docker run \
--rm \
--detach \
--init \
--name sshd \
--hostname sshd \
--volume sshd-config:/config \
--publish 12222:22 \
--env "SSHD_USERS=bmoorman" \
--env "SSHD_KEY_LOC=https://raw.githubusercontent.com/iVirus/Docker-SSHd/master/keys" \
bmoorman/sshd
```
