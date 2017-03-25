# docker-build-slave

Building image
--------------

To build the image use `build.sh` script.

Running image
-------------

To start/run the image use `run.sh` script.

The `run.sh` script takes the following arguments:
* `--port` - the port to expose on the container.
* `--data` - directory that will be mapped to `/data` inside the container.
* `--mem` - the amount of memory to provide for container.
* `--docker-login` - the login name for Docker Hub.
* `--docker-password` - the password for Docker Hub.
* `--docker-email` - Docker Hub email.
* `--docker-pull` - can be `true` or `false`. If `true` will pull images on container start.

The image can be run by executing the command:

`run.sh --name build-slave --docker-login $DOCKER_LOGIN --docker-password $DOCKER_PASSWORD --docker-email $DOCKER_EMAIL --docker-pull true`

