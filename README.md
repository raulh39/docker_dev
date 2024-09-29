# docker_dev

My own development environment dockerized.

The user id and user name in the Docker image can be set at build time to match the ones in the host machine.

# Howto

## Adjust compose.yaml
More surely, the "volumes" section or the name of the image should be modified to adjust it for your preferences.

As you and me are the same person (there is no way someone else is reading this snoozefest), think about the project you
are now developing... are you still using "Work" as the main folder? Most surely not, huh?. So change that.

## Start Docker container
```
USER_UID=$(id -u) USER_NAME=$(id -un) docker compose up -d --build
```

## Use it in VS Code
You need to install the "Remote -SSH" extension or the full extension pack "Remote Development".

Then ctrl+shift+p > "Remote-SSH: Add New Ssh Host..." and follow instructions.

Finally ctrl+shift+p > "Remote-SSH: Connect to Host..." and select previous entry.

Frankly, it is so simple that if you can't do it by yourself then it is impossible for me to explain it... again, we 
are the same person, get over it.
