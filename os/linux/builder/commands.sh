#!/bin/bash

export http_proxy=http://proxy.izds.top:63000

sudo docker build -f ./dev.dockerfile -t dev:latest --build-arg apt_source_switch=0 --build-arg myminiserve=$myminiserve --build-arg http_proxy=$http_proxy --build-arg myprivsvr=$myprivsvr . 2>&1 | tee devbuilder.log

#docker run -it --mount type=bind,source=/,target=/root/h dev

#删除所有停止的容器
#docker container prune -f

#删除所有不使用的镜像
#docker image prune --force --all
