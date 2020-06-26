### Docker Run
```
docker run \
--detach \
--name sshd \
--restart unless-stopped \
--publish 2222:22 \
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
    restart: unless-stopped
    ports:
      - "2222:22"
    volumes:
      - sshd-config:/config

volumes:
  sshd-config:
```

### Environment Variables
|Variable|Description|Default|
|--------|-----------|-------|
|TZ|Sets the timezone|`America/Denver`|
|SSHD_PORT|Sets the port sshd listens on|`22`|
|SSHD_USERS|Space-separated list of users to create|`<empty>`|
|SSHD_KEY_LOC|Base location of accompanying keys for above users|`<empty>`|
