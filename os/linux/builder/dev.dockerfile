# vim: filetype=dockerfile :
#from scratch
#from busybox
#from alpine
from debian:stable

MAINTAINER persy persytry@outlook.com

arg apt_source_switch
arg myminiserve
arg myprivsvr
arg ismynasenv
arg http_proxy

env apt_source_switch=$apt_source_switch
env myminiserve=$myminiserve
env myprivsvr=$myprivsvr
env ismynasenv=$ismynasenv
env http_proxy=$http_proxy
env https_proxy=$http_proxy
env HOME=/root
env USER=root
env isdockerenv=true

copy files/ /
copy devbuilder.sh /tmp/

run set -x; /tmp/devbuilder.sh \
    && rm /tmp/devbuilder.sh

WORKDIR $HOME
#ENTRYPOINT ["/usr/bin/zsh"]
