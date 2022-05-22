#!/bin/bash

export http_proxy=http://proxy.izds.top:63000

sudo docker build -f ./dev.dockerfile -t dev:latest --build-arg apt_source_switch=0 --build-arg myminiserve=$myminiserve --build-arg http_proxy=$http_proxy --build-arg myprivsvr=$myprivsvr . | tee devbuilder.log
#docker run -it --mount type=bind,source=/,target=/root/h dev
