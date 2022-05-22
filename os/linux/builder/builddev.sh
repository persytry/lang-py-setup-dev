#!/bin/bash

export http_proxy=http://proxy.izds.top:63000

mytmppath=/tmp/mytmp
mkdir -p $mytmppath
wget $myminiserve/sys/dev.tar.gz -O $mytmppath
if [ -f "$mytmppath/dev.tar.gz" ]; then
    tar -xzf $mytmppath/dev.tar.gz -C $mytmppath
    #所需参数去参考dev.dockerfile
    ./devbuilder.sh | tee devbuilder.log
else
    rm -rf $mytmppath
fi
