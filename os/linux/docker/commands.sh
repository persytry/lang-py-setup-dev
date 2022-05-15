#!/bin/bash

docker build -f ./base.docker -t base:latest .
#docker run -it --mount type=bind,source=/,target=/root/h base
