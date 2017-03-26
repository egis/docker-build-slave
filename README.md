# docker-build-slave

Building image
--------------

To build the image use `build.sh` script.

Running image
-------------

To start/run the image `--privileged` flag *must* be used.
This is needed for *docker* service to start inside the container.

The image can be run by executing the command:

`docker run -d -i --privileged --name=$NAME egis/docker-build-slave`

