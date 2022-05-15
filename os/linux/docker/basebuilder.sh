#!/bin/bash

cd /tmp

if ! type sudo >/dev/null 2>&1; then
    apt-get install -y ./sudo_1.9.5p2-3_amd64.deb
    rm ./sudo_1.9.5p2-3_amd64.deb
fi

#会有`debconf: delaying package configuration, since apt-utils is not installed`的警告,但是没有关系,不用管它
sudo apt-get install -y ./openssl_1.1.1n-0+deb11u1_amd64.deb ./apt-transport-https_2.2.4_all.deb ./ca-certificates_20210119_all.deb
rm ./openssl_1.1.1n-0+deb11u1_amd64.deb ./apt-transport-https_2.2.4_all.deb ./ca-certificates_20210119_all.deb

if [ $APT_SOURCE_VALUE = 1 ];then
sudo echo -e "deb http://deb.debian.org/debian/ bullseye main non-free contrib \n\
deb http://deb.debian.org/debian/ bullseye-updates main non-free contrib \n\
deb http://deb.debian.org/debian/ bullseye-backports main contrib non-free \n\
deb http://deb.debian.org/debian-security/ bullseye-security main contrib non-free \n\
deb-src http://deb.debian.org/debian/ bullseye main non-free contrib \n\
deb-src http://deb.debian.org/debian/ bullseye-updates main non-free contrib \n\
deb-src http://deb.debian.org/debian/ bullseye-backports main contrib non-free \n\
deb-src http://deb.debian.org/debian-security/ bullseye-security main contrib non-free" > /etc/apt/sources.list
else
sudo echo -e "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free \n\
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free \n\
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free \n\
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free \n\
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free \n\
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free \n\
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free \n\
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free" > /etc/apt/sources.list
fi
sudo apt-get update

sudo apt-get install -y zsh curl wget git netcat python3
sudo chsh -s /bin/zsh
wget $myminiserve/docker_tar/ssh.tar.gz -O - | tar -xz -C $myhome/
chown $myname:$myname $myhome/.ssh $myhome/.ssh/id_rsa $myhome/.ssh/id_rsa.pub $myhome/.ssh/config $myhome/.ssh/authorized_keys $myhome/.ssh/known_hosts
chmod 600 $myhome/.ssh/id_rsa $myhome/.ssh/id_rsa.pub $myhome/.ssh/config

sudo ln -s /opt/nvim-linux64/bin/nvim /usr/local/bin/vi
sudo ln -s /usr/local/bin/proxychains4 /usr/local/bin/pc
sudo ln -s /usr/bin/python3 /usr/local/bin/python

# [ssh 登录出现Are you sure you want to continue connecting (yes/no)?解决方法](https://blog.csdn.net/mct_blog/article/details/52511314)
sudo sed -i -e "s/^#.*StrictHostKeyChecking.*$/    StrictHostKeyChecking no/" /etc/ssh/ssh_config

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sed -i -e 's/^# ZSH_THEME_RANDOM_CANDIDATES=.*$/DISABLE_AUTO_UPDATE="true"/' $myhome/.zshrc
echo -e "\nsource $myhome/.cmn_profile.sh" >> $myhome/.zshrc

mkdir -p $myhome/a/git/lang/py/setup/
git clone git@github.com:persytry/lang-py-setup-dev.git $myhome/a/git/lang/py/setup/dev
python $myhome/a/git/lang/py/setup/dev/setup.py -ta

