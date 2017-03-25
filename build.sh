#!/bin/bash

docker build ./ -t egis/docker-build-slave:latest --ulimit nofile=1048576:1048576


