### Usage
```
docker run \
--detach \
--name sshd \
--init \
--publish 2222:22 \
--env "SSHD_USERS=bmoorman" \
--env "SSHD_KEY_LOC=https://raw.githubusercontent.com/iVirus/Docker-SSHd/master/keys" \
--volume sshd-config:/config \
bmoorman/sshd:latest
```
