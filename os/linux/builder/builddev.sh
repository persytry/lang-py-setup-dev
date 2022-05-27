#!/bin/bash

#要用`export`导出的变量, 才是环境变量, 被执行的脚本(比如./devbuilder.sh)才能识别该环境变量
export http_proxy=http://proxy.izds.top:63000
export https_proxy=$http_proxy

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
