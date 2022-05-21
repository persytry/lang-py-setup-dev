#!/bin/bash

export http_proxy=http://proxy.izds.top:63000

docker build -f ./base.dockerfile -t base:latest --build-arg apt_source_switch=0 --build-arg myminiserve=$myminiserve --build-arg http_proxy=$http_proxy .
#docker run -it --mount type=bind,source=/,target=/root/h base
