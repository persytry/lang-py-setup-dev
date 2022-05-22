#!/bin/bash
# 2022/05/21 10:29:10

mkdir ssh
cp -r ~/.ssh ssh
cp ~/.git-credentials ssh
echo '' > ssh/.ssh/known_hosts
sed -i -e "s/63051/63050/" ssh/.ssh/config
cd ssh
rm ~/share/web/sys/ssh.tar.gz
tar -czf ~/share/web/sys/ssh.tar.gz .
cd ..
rm -rf ssh

cd ~/data/software/sys/linux/dev
rm ~/share/web/sys/dev.tar.gz
tar -czf ~/share/web/sys/dev.tar.gz .
