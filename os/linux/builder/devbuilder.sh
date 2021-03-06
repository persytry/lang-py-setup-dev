#!/bin/bash

# techs & notes
#在wsl上给root设置密码: `sudo passwd root`
#wsl注销后需要重启Windows系统

# 尽量安装deb安装包
cd /tmp/mytmp/dev

if [[ ! "$ismynasenv" == 'true' ]]; then
    ismynasenv=false
fi

if ! type sudo >/dev/null 2>&1; then
    apt-get install -y ./sudo_1.9.5p2-3_amd64.deb
fi
sudo_has_root=$(sudo -l | grep ALL)
if [ ! -n "$sudo_has_root" ]; then
    echo 'input root password:'
    su - root -c "sed -i -e \"s/^root.*ALL.*$/root    ALL=(ALL:ALL) ALL\n$USER   ALL=(ALL:ALL) ALL/\" /etc/sudoers"
    sudo usermod -a -G sudo $USER
fi

sudo sed -i -e "s/^.*deb cdrom:.*$//" /etc/apt/sources.list

# 修改时区
sudo sh -c 'echo "Asia/Shanghai" > /etc/timezone'
sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 安装一些系统基本工具(通常不需要最新版本)
#会有`debconf: delaying package configuration, since apt-utils is not installed`的警告,但是没有关系,不用管它
sudo apt-get install -y ./openssl_1.1.1n-0+deb11u2_amd64.deb ./apt-transport-https_2.2.4_all.deb ./ca-certificates_20210119_all.deb

#[get codename](https://unix.stackexchange.com/questions/180776/how-to-get-debian-codename-without-lsb-release)
mycodename=`grep -Po 'VERSION="[0-9]+ \(\K[^)]+' /etc/os-release`
if [[ $apt_source_switch == 1 ]]; then
echo -e "deb http://deb.debian.org/debian/ $mycodename main non-free contrib \n\
deb http://deb.debian.org/debian/ $mycodename-updates main non-free contrib \n\
deb http://deb.debian.org/debian/ $mycodename-backports main contrib non-free \n\
deb http://deb.debian.org/debian-security/ $mycodename-security main contrib non-free \n\
deb-src http://deb.debian.org/debian/ $mycodename main non-free contrib \n\
deb-src http://deb.debian.org/debian/ $mycodename-updates main non-free contrib \n\
deb-src http://deb.debian.org/debian/ $mycodename-backports main contrib non-free \n\
deb-src http://deb.debian.org/debian-security/ $mycodename-security main contrib non-free" > sources.list
elif [[ $apt_source_switch == 2 ]]; then
echo -e "deb http://mirrors.tencentyun.com/debian $mycodename main contrib non-free \n\
deb http://mirrors.tencentyun.com/debian $mycodename-updates main contrib non-free \n\
deb http://mirrors.tencentyun.com/debian-security $mycodename/updates main \n\
deb http://mirrors.tencentyun.com/debian $mycodename-backports main contrib non-free \n\
deb http://mirrors.tencentyun.com/debian $mycodename-proposed-updates main contrib non-free \n\
deb-src http://mirrors.tencentyun.com/debian $mycodename main contrib non-free \n\
deb-src http://mirrors.tencentyun.com/debian $mycodename-updates main contrib non-free \n\
deb-src http://mirrors.tencentyun.com/debian-security $mycodename/updates main \n\
deb-src http://mirrors.tencentyun.com/debian $mycodename-backports main contrib non-free \n\
deb-src http://mirrors.tencentyun.com/debian $mycodename-proposed-updates main contrib non-free" > sources.list
elif [[ $apt_source_switch == 3 ]]; then
echo -e "deb http://mirrors.aliyun.com/debian/ $mycodename main non-free contrib \n\
deb http://mirrors.aliyun.com/debian-security $mycodename/updates main \n\
deb http://mirrors.aliyun.com/debian/ $mycodename-updates main non-free contrib \n\
deb http://mirrors.aliyun.com/debian/ $mycodename-backports main non-free contrib \n\
deb-src http://mirrors.aliyun.com/debian-security $mycodename/updates main \n\
deb-src http://mirrors.aliyun.com/debian/ $mycodename main non-free contrib \n\
deb-src http://mirrors.aliyun.com/debian/ $mycodename-updates main non-free contrib \n\
deb-src http://mirrors.aliyun.com/debian/ $mycodename-backports main non-free contrib" > sources.list
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
if ! type systemctl >/dev/null 2>&1; then
    sudo apt-get install -y systemd
fi
sudo apt-get install -y python3 zsh curl wget git netcat gcc make autoconf automake pkg-config openssh-server openssh-client htop lftp vsftpd gnupg2
#在docker环境下会提示警告: W: Possible missing firmware /lib/firmware/rtl_nic/rtl8168d-1.fw for module r8169
sudo apt-get install -y wireguard
#在docker环境下会这样的输出,貌似没什么影响: Failed to open connection to "system" message bus: Failed to connect to socket /run/dbus/system_bus_socket: No such file or directory
sudo apt-get install -y software-properties-common
wget $myminiserve/sys/ssh.tar.gz -O - | tar -xz -C $HOME/
#下面这两行命令用来创建新用户
#useradd username
#passwd username 接下来需要: 1. apt install sudo && vi /etc/sudoers 2. cp /root/somefile /home/username 3. chown -R username:username /home/username 4. chsh -s /bin/bash
chown -R $USER:$USER $HOME/.ssh
chmod 600 $HOME/.ssh/*
chmod 700 $HOME/.ssh
#[ssh 登录出现Are you sure you want to continue connecting (yes/no)?解决方法](https://blog.csdn.net/mct_blog/article/details/52511314)
sudo sed -i -e "s/^#.*StrictHostKeyChecking.*$/    StrictHostKeyChecking no/" /etc/ssh/ssh_config

git config --global http.sslVerify false
git config --global credential.helper store

sudo systemctl disable wg-quick@wg0 vsftpd

#官方软件源中的软件都比较旧,而清华软件源的比较新
#sudo apt-get install -y --only-upgrade python3
sudo ln -s `which python3` /usr/local/bin/python
sudo ln -s `which python3` /usr/local/bin/p

# 安装编程语言支持
sudo apt-get install -y python3-pip
sudo ln -s `which pip3` /usr/local/bin/pip
pip install pynvim
#2022/06/07 13:01:31, 最好用apt的方式去安装pandas, 而不是用pip的方式,因为有的服务器用pip的方式安装不成功. pandas依赖numpy,所以安装pandas也会把numpy安装上的. [Install Python Pandas on Windows, Linux & Mac OS](https://sparkbyexamples.com/pandas/install-python-pandas-on-windows-linux-mac-os/)
#sudo apt-get install -y python3-pandas
#pip install numpy -i https://pypi.douban.com/simple
#pip install pandas -i https://pypi.douban.com/simple

#https://github.com/nodesource/distributions/blob/master/README.md#debinstall
#wget https://deb.nodesource.com/setup_18.x
#sudo ./setup_18.x
#sudo apt-get install -y nodejs npm
#用这种方式安装的话, coc-sh启动bash-language-server会失败3次,非常奇怪,搞不明白
#sudo apt-get install -y ./nodejs_18.2.0-deb-1nodesource1_amd64.deb
if ! type node >/dev/null 2>&1; then
    #https://nodejs.org/zh-cn/download/
    mkdir -p /tmp/mytmp/nodejs
    tar -xJf node-v16.15.1-linux-x64.tar.xz -C /tmp/mytmp/nodejs
    sudo mv /tmp/mytmp/nodejs/node-v16.15.1-linux-x64 /opt/nodejs
fi
export PATH=/opt/nodejs/bin:$PATH

npm install -g typescript yarn neovim bash-language-server wsl-open

#https://www.oracle.com/cn/java/technologies/javase/javase8-archive-downloads.html
tar -xzf jdk-8u301-linux-x64.tar.gz
sudo mv jdk1.8.0_301 /opt/jdk8
export JAVA_HOME=/opt/jdk8
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=$JAVA_HOME/bin:$PATH

# docker env
if [[ "$isdockerenv" == 'true' ]]; then
    echo 'isdockerenv=true'
else
    if ! type docker >/dev/null 2>&1; then
        #下面这一条命令即可安装docker
        #sudo curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
        #[如何在 debian 10 中安装和使用 Docker](https://kalasearch.cn/community/tutorials/how-to-install-and-use-docker-on-debian-10/)
        #wget https://download.docker.com/linux/debian/gpg
        #sudo apt-key add gpg
        #sudo add-apt-repository "deb https://download.docker.com/linux/debian $(lsb_release -cs) stable"
        #sudo apt-get update
        #sudo apt-get install -y docker-ce
        sudo apt-get install -y ./containerd.io_1.6.4-1_amd64.deb ./docker-ce-cli_5%3a20.10.16~3-0~debian-bullseye_amd64.deb ./docker-ce_5%3a20.10.16~3-0~debian-bullseye_amd64.deb
        sudo systemctl disable docker
    fi

    sudo apt-get install -y ufw
    #在docker环境下会出错
    sudo ufw default deny
    sudo ufw allow from 10.0.0.0/24
    sudo ufw allow 22/tcp
    #sudo ufw enable
    sudo ufw disable
fi

# 通过apt软件源安装一些常用办公软件(office software)
sudo apt-get install -y fzf tmux tree autojump vifm fd-find ripgrep global
sudo ln -s `which fdfind` /usr/local/bin/fd

# 安装常用的工具(安装包一般比较大,或需要经常更新到最新版本,lastest version)
sudo apt-get install -y ./nvim-linux64.deb
sudo ln -s `which nvim` /usr/local/bin/vi

#https://github.com/dandavison/delta
sudo apt-get install -y ./git-delta_0.13.0_amd64.deb

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
tar -xzf syncthing-linux-amd64-v1.20.2.tar.gz
sudo mv syncthing-linux-amd64-v1.20.2/syncthing /usr/local/bin

#https://github.com/unlock-music/cli
chmod a+x um-linux-amd64
sudo mv um-linux-amd64 /usr/local/bin/unlock_music

chmod a+x win32yank
sudo mv win32yank /usr/local/bin

#https://github.com/persytry/lang-go-t-lemonade
tar -xzf lemonade-linux64.tar.gz
chmod a+x lemonade
sudo mv lemonade /usr/local/bin

#https://github.com/persytry/lang-rs-t-wsl_pathable
tar -xzf linux64-wsl_pathable.tar.gz
chmod a+x wsl_pathable
sudo mv wsl_pathable /usr/local/bin

#https://github.com/persytry/lang-rs-t-auto_commit
tar -xzf linux64-auto_commit.tar.gz
chmod a+x auto_commit
sudo mv auto_commit /usr/local/bin

#https://github.com/persytry/lang-rs-t-wg_ddns
tar -xzf linux64-wg_ddns.tar.gz
chmod a+x wg_ddns
sudo mv wg_ddns /usr/local/bin

#https://github.com/jesseduffield/lazygit
mkdir lazygit
tar -xzf lazygit_0.34_Linux_x86_64.tar.gz -C lazygit
sudo mv lazygit/lazygit /usr/local/bin
sudo ln -s `which lazygit` /usr/local/bin/lg

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
sudo ln -s `which proxychains4` /usr/local/bin/pc

#https://github.com/svenstaro/miniserve
sudo mv miniserve-v0.19.5-x86_64-unknown-linux-musl /usr/local/bin/miniserve
chmod a+x /usr/local/bin/miniserve

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

    if [[ "$ismynasenv" == 'true' ]]; then
        #[minidlna](https://sourceforge.net/projects/minidlna/)
        #[MiniDLNA 1.2.1编译 添加对rmvb格式的支持](https://www.cxybb.com/article/JOYIST/79191765)
        sudo apt-get install -y minidlna
        sudo systemctl disable minidlna
        tar -xzf minidlna-1.3.0.tar.gz
        cd minidlna-1.3.0
        python3 $HOME/a/git/lang/py/setup/dev/setup.py --minidlna_src .
        sudo apt-get install -y autopoint
        sudo apt-get update
        sudo apt-get install -y autopoint gettext libflac-dev libavutil-dev libavcodec-dev libavformat-dev libjpeg-dev libsqlite3-dev libexif-dev libid3tag0-dev libvorbis-dev
        ./autogen.sh
        ./configure
        make
        sudo make install
        cd ..
        python3 $HOME/a/git/lang/py/setup/priv_svr/setup.py -t --minidlna
        # 第一次启动使用-d –v选项看有没有出错
        #sudo /usr/local/sbin/minidlnad -d -v
        sudo usermod -a -G $USER minidlna

        sudo apt-get install -y hd-idle samba
        sudo systemctl disable hd-idle samba
        sudo smbpasswd -a $USER
    fi

    $HOME/a/git/lang/py/setup/priv_svr/install.sh
    python3 $HOME/a/git/lang/py/setup/priv_svr/setup.py -ta
fi

# build桌面环境
if [ -n "$DESKTOP_SESSION" ]; then
    sudo apt-get install -y lightdm i3 terminator dconf-editor ibus ibus-table-wubi xdg-utils xclip

    #wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    #[安装chrome谷歌浏览器依赖Fonts-Liberation的问题](https://cloud.tencent.com/developer/article/1667871)
    sudo apt-get install -y fonts-liberation
    sudo apt-get update
    sudo apt-get install -y fonts-liberation ./google-chrome-stable_current_amd64.deb
fi

#oh-my-zsh放到最后再执行,因为它改变了某些系统环境,有可能导致其它软件包安装不成功,比如nodejs
if [ ! -d "$ZSH" ]; then
    #这种方式不大好,可能不会通过代理访问网络吧
    #sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    mkdir myzsh
    cd myzsh
    wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh
    chmod a+x install.sh
    #安装oh-my-zsh的时候会提示是否切换到zsh, 按y确认,然后会进入到zsh的命令行界面,按<C-d>退出zsh后就能继续执行此脚本了
    ./install.sh
    cd ..
    sed -i -e 's/^# ZSH_THEME_RANDOM_CANDIDATES=.*$/DISABLE_AUTO_UPDATE="true"/' $HOME/.zshrc
    echo -e "\nsource $HOME/a/git/lang/py/setup/dev/os/linux/cmn_profile.sh\n\
#0:清华源(默认), 1:官方源, 2:腾讯源, 3:阿里源\n\
export apt_source_switch=$apt_source_switch\n\
export myminiserve=$myminiserve\n\
export myprivsvr=$myprivsvr\n\
export ismynasenv=$ismynasenv" >> $HOME/.zshrc
    #sudo chsh -s `which zsh`
fi

# 系统清理
cd /tmp
rm -rf mytmp
sudo apt-get autoremove -y
sudo apt-get clean -y
sudo rm -rf /var/lib/apt/lists/*

python3 $HOME/a/git/lang/py/setup/dev/setup.py -ta
