#!/bin/bash

export http_proxy=http://proxy.izds.top:63000

#执行本shell文件的命令前面最好不要加`sudo`,否则读到的环境变量是root用户的,除非你确实想使用root用户下的环境变量
sudo docker build -f ./base.dockerfile -t base:latest --build-arg apt_source_switch=0 --build-arg myminiserve=$myminiserve --build-arg http_proxy=$http_proxy --build-arg myprivsvr=$myprivsvr $myminiserve/sys/base.tar.gz | tee basebuilder.log
