
## introduce

This repository is a develop environment myself, I love minimalism and automation, the repository to realize my love.

If you like it, you can fork it or use the repository directly, I would upgrade forever, because workflow is not perfect which need improve forever.

I use python3 to setup and restore my workflow, The repository which has much configuration present my workflow.

`python setup.py -h`:
```
usage: setup.py [-h] [-t] [-a] [--nvim] [--vim] [--dbg] [--te] [--vifm]
                [--sshd] [--ssh] [--git] [--tool] [--tmux] [--fbterm] [--w3m]
                [--profile] [--i3] [--net] [--lemonade]

this is not only the configuration of vim, also have other software
configuration

optional arguments:
  -h, --help      show this help message and exit
  -t, --toSystem  if True then copy config files from git to system path
  -a, --all       enable all option
  --nvim
  --vim
  --dbg
  --te
  --vifm
  --sshd
  --ssh
  --git
  --tool
  --tmux
  --fbterm
  --w3m
  --profile
  --i3
  --net
  --lemonade
```
The option 't' means 'toSystem', that would copy configuration from `dev/xxx` to system path. If has not option 't', it would copy configuration from system path to `dev/xxx` as default.

My configuration is across platform(Windows, linux, macox, wsl).

The [neovim](https://github.com/neovim/neovim) is the best, welcome to join the world of neovim.

Copy all configuration to system path.
```shell
python setup.py -ta
```

Copy/Store all configuration from system path.
```shell
python setup.py -a
```

## 配置

### debian

#### 需要安装的一些软件

- proxychains-ng:
  - `brew install proxychains-ng`
  - [编译安装 proxychains-ng proxychains4](https://www.cnblogs.com/xuyaowen/p/proxychians4.html), debian下只能编译了
- lightdm
- i3wm
- `apt install dconf-editor`
- terminator
- zsh
- oh-my-zsh: `sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`  
  禁止自动更新，可以把这行的注释取消: `# DISABLE_AUTO_UPDATE="true"`
- fbterm, tmux
- ibus五笔输入法, 已由[ZFVimIM](https://github.com/ZSaberLv0/ZFVimIM)方案代替
- xclip
- fzf,fd,rg,tree
- autojump
- cheat
- delta
- htop
- hd-idle, 系统休眠
- 当前使用的gtags/global的版本(mac和linux都是这个版本)是global-6.6.8.tar.gz, [global/gtags官方下载地址](https://ftp.gnu.org/pub/gnu/global/)
- lemonade

#### 配置文件

- 开启`rc-local`服务,开机启动之
- 把`./os/linux`下的各个配置文件复制到系统相应目录上
- `/etc/fstab`添加mount硬盘:
  - lsblk -f: 查看设备的挂载情况
  ```sh
  # f disk mount
  /dev/sdd1	/media/persy/f	ntfs	defaults,nofail	0	0
  # 还是用下面这行比较好. ps. 空白字符分隔符必须是tab,而不能是空格
  UUID=D4FA828F299D817A	/media/persy/f	ntfs	rw	0	2
  ```
- 在`~/.zshrc`或其他shrc文件中添加如下配置:
  ```sh
  alias share_files2='sudo mount -t cifs -o username="Administrator",password="xxxxx" //192.168.0.2/share_files /media/xxx/share_files2'
  ```
- sudo权限:
  - `sudo usermod -a -G sudo xxx`
  - vim /etc/sudoers
  - `root ALL=(ALL:ALL) ALL`下面添加一行: `xxx ALL=(ALL:ALL) ALL`

#### debian下修改按键映射

- tty下的keymap:
  - 把`./os/linux/etc/my_keymaps_tty`复制到`/etc`
  - 把`./os/linux/etc/rc.local`复制到`/etc`,并使之具有执行权限
- xwindow下的keymap: 
  - 修改`/usr/share/X11/xkb/symbols/pc: `把`include "altwin(meta_alt)"`变成`include "altwin(ctrl_alt_win)"`
  - 修改`/usr/share/X11/xkb/symbols/altwin`: 把"ctrl_alt_win"里的`modifier_map Mod1 { <LWIN>, <RWIN> };`修改成以下两行
    ```
    key <MENU> { [ Alt_R, Meta_R ] };
    modifier_map Mod1 { <LWIN>, <RWIN>, <MENU> };
    ```

## tech

### wls挂载/mount u盘

mkdir /mnt/k

mount -t drvfs K: /mnt/k

umount /mnt/k

## gist

- [chrome cvimrc](https://gist.github.com/persytry/624425819f11e9f937328c19396966d9)
