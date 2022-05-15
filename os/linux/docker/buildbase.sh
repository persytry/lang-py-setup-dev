#!/bin/bash

docker build -f ./base.docker -t base:latest --build-arg myminiserve=$myminiserve --build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy $myminiserve/docker_tar/base.tar.gz
