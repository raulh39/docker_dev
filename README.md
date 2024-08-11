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
But I don't really see the point of doing it except to reset the system to a healthy state (you will lose, for example, Conan's cache)

## Use it in VS Code
You need to install the "Dev Containers" extension.

### Recomended way for quick & dirty solo development

My recomendation is to start the docker container with the `docker run` command show in the previous section through a command line, not using VS Code.

Then open VS Code (with the Dev Containers extension), and execute (Shift+Ctrl+P) "Dev Containers: Attach to Running Container..." and select "/devenv".

If "/devenv" is not being shown, it is because you haven't started it. Execute the `docker run` command and start again.

A new VS Code window will be started whitout any content shown.

Here select "Open Folder" and navigate to the directory where you want to create (or have created) the C++ project.

That is.

Take into account that all the VS Code extensions in the host normally do not apply to the vscode instance in the Docker container.

You need to install them in the vs code docker container. A new directory ~/.vscode-server is going to be created by VS Code, and it will store there all the extensions, settings, etc. that you use.

But this means that every time you remove the container, all of that is going to be removed.

It is a very bad idea to try to mount (either bind-mount or volume-mount) this ~/.vscode-server directory if that is what you are thinking on how to solve it. Don't do it.

What you should actually do is to use a configuration file that VS Code Dev Containers extension uses when connecting to a container.

You can open it with Shift+Ctrl+P > "Dev Containers: Open Container Configuration File".

But, for installing extension, it is easier to search for the extension in Ctrl+Shift+X and instead of pressing the "Install" button, right click and select "Add to devcontainer.json". The next time you attach to the container it will be installed.

As you are not going to remove the "devenv" container, you can also just install the extensions and they will stay there.

### Not recomended: starting the container directly in vscode
To Be Done

### Recomendation for a repo with several members in the team
To Be Done
