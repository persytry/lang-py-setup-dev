#!/bin/bash

# 尽量安装deb安装包
cd /tmp/mytmp

if ! type sudo >/dev/null 2>&1; then
    apt-get install -y ./sudo_1.9.5p2-3_amd64.deb
fi

# 修改时区
sudo echo "Asia/Shanghai" > /etc/timezone
sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#会有`debconf: delaying package configuration, since apt-utils is not installed`的警告,但是没有关系,不用管它
sudo apt-get install -y ./openssl_1.1.1n-0+deb11u1_amd64.deb ./apt-transport-https_2.2.4_all.deb ./ca-certificates_20210119_all.deb

if [ $apt_source_switch = 1 ];then
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

sudo apt-get install -y zsh curl wget git netcat python3 gcc make ./nvim-linux64.deb
wget $myminiserve/docker_tar/ssh.tar.gz -O - | tar -xz -C $HOME/
chown $USER:$USER $HOME/.ssh $HOME/.ssh/id_rsa $HOME/.ssh/id_rsa.pub $HOME/.ssh/config $HOME/.ssh/authorized_keys $HOME/.ssh/known_hosts
chmod 600 $HOME/.ssh/id_rsa $HOME/.ssh/id_rsa.pub $HOME/.ssh/config

sudo ln -s `which nvim` /usr/local/bin/vi
sudo ln -s /usr/local/bin/proxychains4 /usr/local/bin/pc
sudo ln -s /usr/bin/python3 /usr/local/bin/python

# [ssh 登录出现Are you sure you want to continue connecting (yes/no)?解决方法](https://blog.csdn.net/mct_blog/article/details/52511314)
sudo sed -i -e "s/^#.*StrictHostKeyChecking.*$/    StrictHostKeyChecking no/" /etc/ssh/ssh_config

git clone git@github.com:persytry/lang-py-setup-dev.git $HOME/a/git/lang/py/setup/dev
#这种方式不大好,可能不会通过代理访问网络吧
#sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
mkdir myzsh
wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O myzsh
sudo sh ./myzsh/install.sh
sed -i -e 's/^# ZSH_THEME_RANDOM_CANDIDATES=.*$/DISABLE_AUTO_UPDATE="true"/' $HOME/.zshrc
echo -e "\nsource $HOME/a/git/lang/py/setup/dev/os/linux/cmn_profile.sh\nexport myminiserve=$myminiserve" >> $HOME/.zshrc
sudo chsh -s /usr/bin/zsh

wget https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
wget https://github.com/dandavison/delta/releases/download/0.13.0/git-delta_0.13.0_amd64.deb
sudo apt-get -y install fzf tmux ./ripgrep_13.0.0_amd64.deb tree autojump ./git-delta_0.13.0_amd64.deb vifm
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

wget https://github.com/jesseduffield/lazygit/releases/download/v0.34/lazygit_0.34_Linux_x86_64.tar.gz
mkdir lazygit
tar -xzf lazygit_0.34_Linux_x86_64.tar.gz -C lazygit
sudo mv lazygit/lazygit /usr/local/bin

wget https://github.com/samhocevar/rinetd/releases/download/v0.73/rinetd-0.73.tar.gz
tar -xzf rinetd-0.73.tar.gz
cd rinetd-0.73
./configure
make
sudo make install
cd ..

# 这个放到最后执行,因为setup.py会设置其他的代理方式,可能不大稳定
#python $HOME/a/git/lang/py/setup/dev/setup.py -ta

cd ..
rm -rf mytmp
sudo apt-get autoremove -y
sudo apt-get clean -y
sudo rm -rf /var/lib/apt/lists/*
