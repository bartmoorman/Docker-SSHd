### Docker Run
```
docker run \
--detach \
--name sshd \
--publish 2222:22 \
--env "SSHD_USERS=bmoorman" \
--env "SSHD_KEY_LOC=https://raw.githubusercontent.com/iVirus/Docker-SSHd/master/keys" \
--volume sshd-config:/config \
bmoorman/sshd:latest
```

### Docker Compose
```
version: "3.7"
services:
  sshd:
    image: bmoorman/sshd:latest
    container_name: sshd
    ports:
      - "2222:22"
    environment:
      - SSHD_USERS=bmoorman
      - SSHD_KEY_LOC=https://raw.githubusercontent.com/iVirus/Docker-SSHd/master/keys
    volumes:
      - sshd-config:/config

volumes:
  sshd-config:
```
