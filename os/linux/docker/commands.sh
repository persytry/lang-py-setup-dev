#!/bin/bash

# 在wsl2上执行build,run命令,需要加上: --events-backend=file
podman build -f ./basic.docker -t persytry/basic:latest
#docker build -f ./basic.docker -t persytry/basic:latest .
