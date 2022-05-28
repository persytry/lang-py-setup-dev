#!/bin/bash

export ismynasenv=false
export http_proxy=http://proxy.izds.top:63000
export https_proxy=$http_proxy
export apt_source_switch=0
#export myminiserve=
#export myprivsvr=
#export DESKTOP_SESSION=true

mytmppath=/tmp/mytmp
mkdir -p $mytmppath
if type wget >/dev/null 2>&1; then
    wget $myminiserve/sys/dev.tar.gz
    mv dev.tar.gz $mytmppath
else
    cp dev.tar.gz $mytmppath
fi

if [ -f "$mytmppath/dev.tar.gz" ]; then
    tar -xzf $mytmppath/dev.tar.gz -C $mytmppath
    ./devbuilder.sh | tee devbuilder.log
else
    echo "error: cannot find the file: $mytmppath/dev.tar.gz"
    rm -rf $mytmppath
fi
