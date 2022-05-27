#!/bin/bash

export ismynasenv=false
export http_proxy=http://proxy.izds.top:63000
export https_proxy=$http_proxy
export apt_source_switch=0
#export myminiserve=
#export myprivsvr=

mytmppath=/tmp/mytmp
mkdir -p $mytmppath
if type wget >/dev/null 2>&1; then
    wget $myminiserve/sys/dev.tar.gz -O $mytmppath
fi
if [ -f "$mytmppath/dev.tar.gz" ]; then
    tar -xzf $mytmppath/dev.tar.gz -C $mytmppath
    #所需参数去参考dev.dockerfile
    ./devbuilder.sh | tee devbuilder.log
else
    rm -rf $mytmppath
fi
