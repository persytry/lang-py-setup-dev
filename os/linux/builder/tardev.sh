#!/bin/bash
# 2022/05/21 10:29:10

mkdir mysshtmp && cd mysshtmp
cp -r ~/.ssh ./
cp ~/.git-credentials ./
echo '' > .ssh/known_hosts
sed -i -e "s/63051/63050/" .ssh/config
rm ~/share/web/sys/ssh.tar.gz
tar -czf ~/share/web/sys/ssh.tar.gz .
cd ..
rm -rf mysshtmp

mkdir mydevtmp && cd mydevtmp
ln -s ~/data/software/sys/linux/dev ./
ln -s ~/a/git/lang/py/setup/dev/os/linux/builder/devbuilder.sh ./
rm ~/share/web/sys/dev.tar.gz
tar -czhf ~/share/web/sys/dev.tar.gz .
cd ..
rm -rf mydevtmp
