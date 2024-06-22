# docker_dev

My own development environment dockerized

# Howto

Build an image:

`docker build -t raulh39/build_env:latest -f Dockerfile.dev .`

Execute an interactive bash inside the image built:

`docker run --hostname devenv --rm -i -t --init raulh39/build_env:latest`
