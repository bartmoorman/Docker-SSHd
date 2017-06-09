### Build
```
docker build \
--tag sshd \
https://github.com/iVirus/Docker.git#master:SSHd
```

### Run
```
docker run \
--rm \
--detach \
--name sshd \
--publish 2222:22 \
--env "SSHD_USERS=docker" \
--env "SSHD_KEY_LOC=https://raw.githubusercontent.com/iVirus/Docker/master/SSHd/keys" \
sshd
```
