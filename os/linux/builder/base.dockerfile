# vim: filetype=dockerfile :
#from scratch
#from busybox
#from alpine
from debian:stable

MAINTAINER persy persytry@outlook.com

#0:清华源(默认), 1:官方源
arg apt_source_switch
arg myminiserve
arg myprivsvr
arg http_proxy

env apt_source_switch=$apt_source_switch
env myminiserve=$myminiserve
env myprivsvr=$myprivsvr
env http_proxy=$http_proxy
env https_proxy=$http_proxy
env HOME=/root
env USER=root
env isdockerenv=true

copy files/ /
copy basebuilder.sh /tmp/

run set -x; /tmp/basebuilder.sh \
    && rm /tmp/basebuilder.sh

WORKDIR $HOME
#ENTRYPOINT ["/usr/bin/zsh"]
