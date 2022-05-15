#!/bin/bash

docker build -f ./base.docker -t base:latest $myminiserve/docker_tar/base.tar.gz
