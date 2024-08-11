# docker_dev

My own development environment dockerized.

The user id and user name in the Docker image can be set at build time to match the ones in the host machine.

# Howto

## Build an image

```
docker build -t raulh39/build_env:latest -f Dockerfile.dev --build-arg USER_UID=$(id -u) --build-arg USER_NAME=$(id -un) .
```

## Execute a non-persistent interactive bash inside the image built

```
docker run --hostname devenv --rm -i -t --init raulh39/build_env:latest
```
