# docker_dev

My own development environment dockerized.

The user id and user name in the Docker image can be set at build time to match the ones in the host machine.

# Howto

## Build an image

```
docker build -t raulh39/build_env:latest -f Dockerfile.dev --build-arg USER_UID=$(id -u) --build-arg USER_NAME=$(id -un) .
```

## Execute a non-persistent interactive bash inside the image built
This is useful to quickly test something, but it is not recomended for development
```
docker run --hostname temporal --rm -i -t --init raulh39/build_env:latest
```

## Use it for development

Start it with some directories mounted, but don't let it finish:

```
docker run \
--hostname devenv \
--name devenv \
--init -d \
-v$HOME/Repositories:/home/ubuntu/Repositories \
raulh39/build_env:latest \
sleep infinity
```

Now execute something in it. For example, you can start an interactive shell:
```
docker exec -i -t devenv bash -i
```

You can temporary stop it:
```
docker stop devenv
```
and then start it again:
```
docker start devenv
```
This is useful when restarting the host machine (the "stop" command is not needed in that case as Docker daemon will do it for yourself)
Of course, all running processes will stop.

While you don't delete the container, all the files you create inside it will be preserved, even if they don't belong to a mounted
volume. This means, for example, that Conan's cache will be maintained.

In order to delete the container use the usual:
```
docker container rm devenv
```
