#!/bin/bash

# 尽量安装deb安装包
cd /tmp/mytmp/dev

if ! type sudo >/dev/null 2>&1; then
    apt-get install -y ./sudo_1.9.5p2-3_amd64.deb
    if [ ! $USER = root ]; then
        sudo usermod -a -G sudo $USER
        sudo sh -c 'echo -e "\n$USER ALL=(ALL:ALL) ALL" >> /etc/sudoers'
    fi
fi

# 修改时区
sudo sh -c 'echo "Asia/Shanghai" > /etc/timezone'
sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 安装一些系统基本工具(通常不需要最新版本)
#会有`debconf: delaying package configuration, since apt-utils is not installed`的警告,但是没有关系,不用管它
sudo apt-get install -y ./openssl_1.1.1n-0+deb11u1_amd64.deb ./apt-transport-https_2.2.4_all.deb ./ca-certificates_20210119_all.deb

#[get codename](https://unix.stackexchange.com/questions/180776/how-to-get-debian-codename-without-lsb-release)
mycodename=`grep -Po 'VERSION="[0-9]+ \(\K[^)]+' /etc/os-release`
if [ $apt_source_switch = 1 ];then
echo -e "deb http://deb.debian.org/debian/ $mycodename main non-free contrib \n\
deb http://deb.debian.org/debian/ $mycodename-updates main non-free contrib \n\
deb http://deb.debian.org/debian/ $mycodename-backports main contrib non-free \n\
deb http://deb.debian.org/debian-security/ $mycodename-security main contrib non-free \n\
deb-src http://deb.debian.org/debian/ $mycodename main non-free contrib \n\
deb-src http://deb.debian.org/debian/ $mycodename-updates main non-free contrib \n\
deb-src http://deb.debian.org/debian/ $mycodename-backports main contrib non-free \n\
deb-src http://deb.debian.org/debian-security/ $mycodename-security main contrib non-free" > sources.list
else
echo -e "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ $mycodename main contrib non-free \n\
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ $mycodename-updates main contrib non-free \n\
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ $mycodename-backports main contrib non-free \n\
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security $mycodename-security main contrib non-free \n\
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ $mycodename main contrib non-free \n\
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ $mycodename-updates main contrib non-free \n\
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ $mycodename-backports main contrib non-free \n\
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security $mycodename-security main contrib non-free" > sources.list
fi
sudo sh -c "cat ./sources.list > /etc/apt/sources.list"
sudo apt-get update

# 通过apt软件源安装一些最基本的工具
sudo apt-get install -y zsh curl wget git netcat gcc make autoconf automake pkg-config openssh-server openssh-client wireguard ufw htop software-properties-common lftp vsftpd
wget $myminiserve/sys/ssh.tar.gz -O - | tar -xz -C $HOME/
chown $USER:$USER $HOME/.ssh $HOME/.ssh/id_rsa $HOME/.ssh/id_rsa.pub $HOME/.ssh/config $HOME/.ssh/authorized_keys $HOME/.ssh/known_hosts
chmod 600 $HOME/.ssh/id_rsa $HOME/.ssh/id_rsa.pub $HOME/.ssh/config
#[ssh 登录出现Are you sure you want to continue connecting (yes/no)?解决方法](https://blog.csdn.net/mct_blog/article/details/52511314)
sudo sed -i -e "s/^#.*StrictHostKeyChecking.*$/    StrictHostKeyChecking no/" /etc/ssh/ssh_config

ufw enable
ufw default deny
ufw allow from 10.0.0.0/24
ufw allow 22/tcp

sudo systemctl disable wg-quick@wg0 vsftpd

if [ ! "$ismynasenv" = 'true' ]; then
    ismynasenv=false
fi
#这种方式不大好,可能不会通过代理访问网络吧
#sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
mkdir myzsh
cd myzsh
wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh
chmod a+x install.sh
./install.sh
cd ..
sed -i -e 's/^# ZSH_THEME_RANDOM_CANDIDATES=.*$/DISABLE_AUTO_UPDATE="true"/' $HOME/.zshrc
echo -e "\nsource $HOME/a/git/lang/py/setup/dev/os/linux/cmn_profile.sh\n\
#0:清华源(默认), 1:官方源\n\
export apt_source_switch=$apt_source_switch\n\
export myminiserve=$myminiserve\n\
export myprivsvr=$myprivsvr\n\
export ismynasenv=$ismynasenv" >> $HOME/.zshrc
#sudo chsh -s `which zsh`

# 安装编程语言支持
sudo apt-get install -y python3

tar -xzf jdk-8u301-linux-x64.tar.gz
sudo mv jdk1.8.0_301 /opt/jdk8

# 通过apt软件源安装一些常用办公软件(office software)
sudo apt-get install -y fzf tmux tree autojump vifm fd-find ripgrep git-delta global

# 安装常用的工具(安装包一般比较大,或需要经常更新到最新版本,lastest version)
sudo apt-get install -y ./nvim-linux64.deb

#https://github.com/cheat/cheat
gzip -d cheat-linux-amd64.gz
mv cheat-linux-amd64 cheat
chmod a+x cheat
sudo mv cheat /usr/local/bin

#https://github.com/universal-ctags/ctags
tar -xzf p5.9.20220522.0.tar.gz
cd ctags-p5.9.20220522.0
./autogen.sh
#ctags会放到`/usr/local/bin`下面的
./configure --prefix=/usr/local
make
sudo make install
cd ..

#https://github.com/protocolbuffers/protobuf
unzip protoc-3.20.1-linux-x86_64.zip -d protoc
sudo mv protoc/bin/protoc /usr/local/bin

#https://github.com/syncthing/syncthing
tar -xzf syncthing-linux-amd64-v1.20.1.tar.gz
sudo mv syncthing-linux-amd64-v1.20.1/syncthing /usr/local/bin
sudo chown $USER:$USER /usr/local/bin/syncthing

#https://github.com/unlock-music/cli
chmod a+x um-linux-amd64
sudo mv um-linux-amd64 /usr/local/bin/unlock_music

sudo mv win32yank /usr/local/bin

#https://github.com/persytry/lang-go-t-lemonade
tar -xzf lemonade-linux64.tar.gz
sudo mv lemonade /usr/local/bin

#https://github.com/persytry/lang-rs-t-wsl_pathable
tar -xzf linux64-wsl_pathable.tar.gz
sudo mv wsl_pathable /usr/local/bin

#https://github.com/persytry/lang-rs-t-auto_commit
tar -xzf linux64-auto_commit.tar.gz
sudo mv auto_commit /usr/local/bin

#https://github.com/persytry/lang-rs-t-wg_ddns
tar -xzf linux64-wg_ddns.tar.gz
sudo mv wg_ddns /usr/local/bin

#https://github.com/jesseduffield/lazygit
mkdir lazygit
tar -xzf lazygit_0.34_Linux_x86_64.tar.gz -C lazygit
sudo mv lazygit/lazygit /usr/local/bin

#https://github.com/samhocevar/rinetd
#从0.70版本开始rinetd已经支持UDP转发
tar -xzf rinetd-0.73.tar.gz
cd rinetd-0.73
./configure
make
sudo make install
cd ..
sudo systemctl disable rinetd

#https://github.com/rofl0r/proxychains-ng
tar -xJf proxychains-ng-4.16.tar.xz
cd proxychains-ng-4.16
./configure
make
sudo make install
cd ..

#https://github.com/svenstaro/miniserve
sudo mv miniserve-v0.19.5-x86_64-unknown-linux-musl /usr/local/bin/miniserve

# 下载各种源码
git clone git@github.com:persytry/lang-py-setup-dev.git $HOME/a/git/lang/py/setup/dev
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

# 通过wget下载并安装各种工具
#nothing now

# build myprivsvr
if [ -n "$myprivsvr" ]; then
    git clone $myprivsvr/lang/py/setup/priv_svr.git $HOME/a/git/lang/py/setup/priv_svr

    #用的是java8, gitblit-1.9.1.tar.gz用的是高版本java,貌似有点问题不好解决
    tar -xzf gitblit-1.8.0.tar.gz
    sudo mv gitblit-1.8.0 /opt/gitblit

    if [ "$ismynasenv" = 'true' ]; then
        #minidlna
        #sudo apt-get install -y gettext autopoint libflac-dev
        mv minidlnad_v1.3.0_for_rmvb_by_persy minidlnad
        chmod a+x minidlnad
        sudo mv minidlnad /usr/local/sbin
        sudo usermod -a -G $USER minidlna

        sudo apt-get install -y hd-idle samba
        sudo systemctl disable hd-idle samba
        sudo smbpasswd -a $USER
    fi

    $HOME/a/git/lang/py/setup/priv_svr/install.sh
    python3 $HOME/a/git/lang/py/setup/priv_svr/setup.py -ta
fi

# docker env
if [ "$isdockerenv" = 'true' ]; then
    echo 'isdockerenv=true'
else
    sudo curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
    sudo systemctl disable docker
fi

# build桌面环境
if [ -n "$DESKTOP_SESSION" ]; then
    sudo apt-get install -y lightdm i3 terminator dconf-editor ibus ibus-table-wubi xdg-utils xclip
fi

# 系统清理
cd /tmp
rm -rf mytmp
sudo apt-get autoremove -y
sudo apt-get clean -y
sudo rm -rf /var/lib/apt/lists/*

# 建立各种软链接
sudo ln -s `which nvim` /usr/local/bin/vi
sudo ln -s `which proxychains4` /usr/local/bin/pc
sudo ln -s `which python3` /usr/local/bin/python
sudo ln -s `which python3` /usr/local/bin/p
sudo ln -s `which lazygit` /usr/local/bin/lg

# 这个放到最后执行,因为setup.py会设置其他的代理方式,可能不大稳定
#python3 $HOME/a/git/lang/py/setup/dev/setup.py -ta
