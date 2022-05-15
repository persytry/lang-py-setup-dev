#!/bin/bash

ln -s /opt/nvim-linux64/bin/nvim /usr/local/bin/vi
ln -s /usr/local/bin/proxychains4 /usr/local/bin/pc

cd /tmp

#会有`debconf: delaying package configuration, since apt-utils is not installed`的警告,但是没有关系,不用管它
apt-get install -y ./openssl_1.1.1n-0+deb11u1_amd64.deb ./apt-transport-https_2.2.4_all.deb ./ca-certificates_20210119_all.deb
rm ./openssl_1.1.1n-0+deb11u1_amd64.deb ./apt-transport-https_2.2.4_all.deb ./ca-certificates_20210119_all.deb

if [ $APT_SOURCE_VALUE = 1 ];then
echo -e "deb http://deb.debian.org/debian/ bullseye main non-free contrib \n\
deb http://deb.debian.org/debian/ bullseye-updates main non-free contrib \n\
deb http://deb.debian.org/debian/ bullseye-backports main contrib non-free \n\
deb http://deb.debian.org/debian-security/ bullseye-security main contrib non-free \n\
deb-src http://deb.debian.org/debian/ bullseye main non-free contrib \n\
deb-src http://deb.debian.org/debian/ bullseye-updates main non-free contrib \n\
deb-src http://deb.debian.org/debian/ bullseye-backports main contrib non-free \n\
deb-src http://deb.debian.org/debian-security/ bullseye-security main contrib non-free" > /etc/apt/sources.list
else
echo -e "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free \n\
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free \n\
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free \n\
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free \n\
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free \n\
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free \n\
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free \n\
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free" > /etc/apt/sources.list
fi
apt-get update
