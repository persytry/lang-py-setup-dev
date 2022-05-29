# -*- coding:utf-8 -*-
'''
@author Persy
@date 2021/8/15 12:57
'''
import os
import shutil
import platform
import argparse
import glob
from typing import Optional, List, Dict
import filecmp

class FileItem:
    def __init__(self, f:str, win:Optional[str]=None, mac:Optional[str]=None, linux:Optional[str]=None, all:Optional[str]=None, unixLike:Optional[str]=None, root:bool=False, needCreate:bool=False, ignored:Optional[List[str]]=None, seds:Optional[Dict[str, Dict[str, str]]]=None):
        self.f = f
        self.win = win or all
        self.mac = mac or unixLike or all
        self.linux = linux or unixLike or all
        assert self.win or self.mac or self.linux
        self.root = root
        self.needCreate = needCreate
        self.ignored = ignored
        self.seds = seds

_seds:Dict[str, Dict[str, str]] = {
    'hk': {'63001':'63000', '63051':'63050'},
    'usagate': {'63000':'63001', '63050':'63051'},
}
_dummypath = '/dummypath'
_cur_dir:str = os.path.dirname(os.path.realpath(__file__))
_cur_dir = os.path.realpath(_cur_dir)
_os_file_list:List[FileItem] = [
    FileItem('vim/nvim', win='~/AppData/Local/nvim', unixLike='~/.config/nvim', needCreate=True, ignored=['plugged']),
    FileItem('vim/nvim/init.vim', all='~/.vimrc', needCreate=True),
    FileItem('vim/nvim/coc-settings.json', win='~/vimfiles/coc-settings.json', unixLike='~/.vim/coc-settings.json', needCreate=True),
    FileItem('vim/nvim/autoload', win='~/vimfiles/autoload', unixLike='~/.vim/autoload', needCreate=True),
    FileItem('vim/nvim/mycmd', win='~/vimfiles/mycmd', unixLike='~/.vim/mycmd', needCreate=True),
    FileItem('vim/vimspector.json', all=os.path.join(_cur_dir, '../../../../.vimspector.json'), needCreate=True),
    FileItem('os/win/terminal/settings.json', win='~/AppData/Local/Packages/Microsoft.WindowsTerminal_*/LocalState/settings.json'),
    FileItem('t/vifm/cmn.vifm', win='~/AppData/Roaming/Vifm/cmn.vifm', unixLike='~/.config/vifm/cmn.vifm', needCreate=True),
    FileItem('t/vifm/vifmrc-win', win='~/AppData/Roaming/Vifm/vifmrc', needCreate=True),
    FileItem('t/vifm/vifmrc-osx', mac='~/.config/vifm/vifmrc', needCreate=True),
    FileItem('t/vifm/vifmrc-linux', linux='~/.config/vifm/vifmrc', needCreate=True),
    FileItem('t/vifm/colors/Default.vifm', win='~/AppData/Roaming/Vifm/colors/Default.vifm', mac='~/.config/vifm/colors/Default.vifm', needCreate=True),
    FileItem('t/vifm/colors/Default-linux.vifm', linux='~/.config/vifm/colors/Default.vifm', needCreate=True),
    FileItem('t/vifm/colors/solarized-light.vifm', win='~/AppData/Roaming/Vifm/colors/solarized-light.vifm', unixLike='~/.config/vifm/colors/solarized-light.vifm', needCreate=True),
    # 需要拷贝文件: $HOME/.ssh/authorized_keys
    FileItem('net/ssh/sshd_config.conf', win='C:/ProgramData/ssh/sshd_config'),
    FileItem('net/ssh/config.conf', unixLike='~/.ssh/config', needCreate=True, seds=_seds),
    FileItem('net/ssh/config_win.conf', win='~/.ssh/config', needCreate=True, seds=_seds),
    # https://github.com/shunf4/proxychains-windows
    FileItem('net/proxychains.conf', win='~/.proxychains/proxychains.conf', unixLike='/usr/local/etc/proxychains.conf', root=True, needCreate=True, seds=_seds),
    FileItem('os/linux/cmn_profile.sh', win=_dummypath, seds=_seds),
    FileItem('net/w3m-config-mac.conf', mac='~/.w3m/config'),
    FileItem('net/w3m-config-linux.conf', linux='~/.w3m/config'),
    FileItem('net/lftprc.conf', all='~/.config/lftp/rc', needCreate=True),
    FileItem('t/lazygit-config.yml', win='%APPDATA%/lazygit/config.yml', mac='~/Library/Application Support/lazygit/config.yml', linux='~/.config/lazygit/config.yml', needCreate=True),
    FileItem('t/fbtermrc', linux='~/.fbtermrc', needCreate=True),
    FileItem('t/tmux.conf', unixLike='~/.tmux.conf', needCreate=True),
    FileItem('os/linux/terminator.config', linux='~/.config/terminator/config', needCreate=True),
    FileItem('vim/gtags.conf', all='~/.globalrc', needCreate=True),
    FileItem('os/linux/lightdm.conf', linux='/etc/lightdm/lightdm.conf', root=True),
    FileItem('os/linux/i3.config', linux='~/.config/i3/config', seds=_seds),
    FileItem('t/delta-themes.gitconfig', all='~/.config/delta/themes.gitconfig', needCreate=True),
    FileItem('t/ctags/ctags.d', all='~/.ctags.d', needCreate=True), # 这是Universal Ctags 5.9.0及以上的配置
    FileItem('t/vscode/settings.json', win='~/AppData/Roaming/Code/User/settings.json', mac='~/Library/Application Support/Code/User/settings.json'),
    FileItem('t/vscode/keybindings.json', win='~/AppData/Roaming/Code/User/keybindings.json', mac='~/Library/Application Support/Code/User/keybindings.json'),
    FileItem('t/lemonade/lemonade.toml', all='~/.config/lemonade.toml', needCreate=True),
    FileItem('t/lemonade/lemonade.service', linux='/lib/systemd/system/lemonade.service', root=True, needCreate=True),
    FileItem('t/ripgrep.conf', all='~/.config/ripgrep.conf', needCreate=True),
    FileItem('t/fdignore.conf', all='~/.config/fd/ignore', needCreate=True),
    FileItem('os/linux/etc/my_keymaps_tty', linux='/etc/my_keymaps_tty', root=True, needCreate=True),
    FileItem('os/linux/service/load_tty_keymaps.service', linux='/lib/systemd/system/load_tty_keymaps.service', root=True, needCreate=True),
    FileItem('os/linux/x11/keymap/altwin', linux='/usr/share/X11/xkb/symbols/altwin', root=True),
    FileItem('os/linux/x11/keymap/pc', linux='/usr/share/X11/xkb/symbols/pc', root=True),
]
_os_file_map:Dict[str, int] = {}
if len(_os_file_map) != len(_os_file_list):
    for i, v in enumerate(_os_file_list):
        _os_file_map[v.f] = i

def _isWindows() -> bool:
    return platform.system() == 'Windows'


def _isMac() -> bool:
    return platform.system() == 'Darwin'


def _makedirs(name:str) -> None:
    paths:List[str] = []
    uid = gid = mode = 0
    while True:
        if os.path.exists(name):
            s = os.stat(name)
            mode = s.st_mode
            uid = s.st_uid
            gid = s.st_gid
            break
        if name not in paths:
            paths.append(name)
        _name = os.path.dirname(name)
        if _name == name:
            break
        name = _name
    assert mode != 0
    assert len(paths) > 0
    paths.reverse()
    for v in paths:
        os.mkdir(v, mode)
        os.chown(v, uid=uid, gid=gid)

def _copy(srcPath: str, dstPath: str, item:FileItem, toSystem:bool) -> int:
    if os.path.exists(srcPath) and os.path.exists(dstPath) and filecmp.cmp(srcPath, dstPath): return 0
    if item.root and toSystem:
        os.system(f'rootrun cp {srcPath} {dstPath}')
    else:
        shutil.copy(srcPath, dstPath)
    print(f"file src:{srcPath}, dst:{dstPath}")
    return 1

def _copyFileImpl(srcPath: str, dstPath: str, item:FileItem, toSystem:bool) -> int:
    if not os.path.exists(srcPath):
        return 0
    if os.path.isfile(srcPath):
        dstDir = os.path.dirname(dstPath)
        if not os.path.exists(dstDir):
            _makedirs(dstDir)
        return _copy(srcPath, dstPath, item, toSystem)
    if not os.path.exists(dstPath):
        _makedirs(dstPath)
    srcList = os.listdir(srcPath)

    cnt = 0
    for src in srcList:
        if item.ignored and src in item.ignored:
            continue
        p = os.path.join(srcPath, src)
        dst = os.path.join(dstPath, src)
        if os.path.isdir(p):
            cnt += _copyFileImpl(p, dst, item, toSystem)
        else:
            if src.startswith('.') and src not in _os_file_map:
                continue
            cnt += _copy(p, dst, item, toSystem)
    return cnt


def _copyFileItem(toSystem: bool, item: FileItem) -> int:
    if _isWindows():
        if item.win is None:
            return 0
        sysPath = os.path.expandvars(os.path.expanduser(item.win))
    elif _isMac():
        if item.mac is None:
            return 0
        sysPath = os.path.expandvars(os.path.expanduser(item.mac))
    else:
        if item.linux is None:
            return 0
        sysPath = os.path.expandvars(os.path.expanduser(item.linux))
    sysPath = os.path.realpath(sysPath)
    _sysPath = glob.glob(sysPath)
    if len(_sysPath) != 0:
        sysPath = _sysPath[0]
    curPath = os.path.realpath(os.path.join(_cur_dir, item.f))
    if toSystem:
        if not item.needCreate and not os.path.exists(sysPath): return 0
        cnt = _copyFileImpl(curPath, sysPath, item, toSystem)
    else:
        cnt = _copyFileImpl(sysPath, curPath, item, toSystem)
    return cnt


def _copyFileItemByName(toSystem: bool, itemName: str) -> int:
    item = _os_file_list[_os_file_map[itemName]]
    return _copyFileItem(toSystem, item)


def copyVimCfg(toSystem: bool, isNvim: bool) -> int:
    cnt = 0
    cnt += _copyFileItemByName(toSystem, 'vim/gtags.conf')
    if isNvim:
        cnt += _copyFileItemByName(toSystem, 'vim/nvim')
        print(f'copy nvim config {cnt} files')
    else:
        cnt += _copyFileItemByName(toSystem, 'vim/nvim/init.vim')
        cnt += _copyFileItemByName(toSystem, 'vim/nvim/coc-settings.json')
        cnt += _copyFileItemByName(toSystem, 'vim/nvim/autoload')
        cnt += _copyFileItemByName(toSystem, 'vim/nvim/mycmd')
        print(f'copy vim config {cnt} files')
    return cnt


def copyTerminalCfg(toSystem: bool) -> int:
    cnt = 0
    cnt += _copyFileItemByName(toSystem, 'os/win/terminal/settings.json')
    cnt += _copyFileItemByName(toSystem, 'os/linux/terminator.config')
    print(f'copy terminal config {cnt} files')
    return cnt


def copyVifmCfg(toSystem: bool) -> int:
    cnt = 0
    cnt += _copyFileItemByName(toSystem, 't/vifm/cmn.vifm')
    cnt += _copyFileItemByName(toSystem, 't/vifm/vifmrc-win')
    cnt += _copyFileItemByName(toSystem, 't/vifm/vifmrc-osx')
    cnt += _copyFileItemByName(toSystem, 't/vifm/vifmrc-linux')
    cnt += _copyFileItemByName(toSystem, 't/vifm/colors/Default.vifm')
    cnt += _copyFileItemByName(toSystem, 't/vifm/colors/Default-linux.vifm')
    cnt += _copyFileItemByName(toSystem, 't/vifm/colors/solarized-light.vifm')
    print(f'copy vifm config {cnt} files')
    return cnt


def copySshdCfg(toSystem: bool) -> int:
    cnt = 0
    cnt += _copyFileItemByName(toSystem, 'net/ssh/sshd_config.conf')
    print(f'copy sshd config {cnt} files')
    return cnt


def copySshCfg(toSystem: bool) -> int:
    cnt = 0
    cnt += _copyFileItemByName(toSystem, 'net/ssh/config.conf')
    cnt += _copyFileItemByName(toSystem, 'net/ssh/config_win.conf')
    print(f'copy ssh config {cnt} files')
    return cnt


def _setGitCfgItem(item: str) -> int:
    res = os.system(f'git config --global {item}')
    if res != 0:
        print(f'git config item error, error res:{res}, config item: {item}')
        return 0
    print(f'git config item be setted: {item}')
    return 1


def copyGitCfg(toSystem: bool, vimName: str) -> int:
    cnt = 0
    cnt += _copyFileItemByName(toSystem, 't/lazygit-config.yml')
    cnt += _copyFileItemByName(toSystem, 't/delta-themes.gitconfig')
    if toSystem:
        cnt += _setGitCfgItem(f'http.sslVerify false')
        cnt += _setGitCfgItem(f'core.editor {vimName}')
        cnt += _setGitCfgItem(f'diff.tool {vimName}')
        cnt += _setGitCfgItem(f'difftool.prompt false')
        cnt += _setGitCfgItem(f'mergetool.prompt false')
        cnt += _setGitCfgItem(f'mergetool.keepBackup false')
        # cnt += _setGitCfgItem(f'merge.tool {vimName}')
        cnt += _setGitCfgItem(f'merge.tool gdiff') # Plug 'tpope/vim-fugitive'
        cnt += _setGitCfgItem(f'mergetool.{vimName}.trustExitCode true')
        cnt += _setGitCfgItem(f'mergetool.gdiff.trustExitCode true')
        cnt += _setGitCfgItem(f'user.name persy')
        cnt += _setGitCfgItem(f'user.email persytry@outlook.com')
        cnt += _setGitCfgItem(f'pull.rebase false')
        if _isWindows():
            cnt += _setGitCfgItem(r'difftool.'+vimName+r'.cmd "'+vimName+r' -d $REMOTE $LOCAL"')
            cnt += _setGitCfgItem("mergetool."+vimName+".cmd \""+vimName+" -d $BASE $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J' -c '$wincmd w' -c 'wincmd ='\"")
            cnt += _setGitCfgItem('mergetool.gdiff.cmd \"'+vimName+' -f -c \\"Gdiffsplit!\\" \\"$MERGED\\"\"')
        else:
            # -d: 左右竖屏. -o: 上下横屏, ps. 这个模式好像不能同步,有问题
            cnt += _setGitCfgItem(r'difftool.'+vimName+r'.cmd '+vimName+r'\ -d\ \$REMOTE\ \$LOCAL')
            cnt += _setGitCfgItem(r"mergetool."+vimName+r".cmd "+vimName+r"\ -d\ \$BASE\ \$LOCAL\ \$REMOTE\ \$MERGED\ -c\ \'\$wincmd\ w\'\ -c\ \'wincmd\ J\'\ -c\ \'\$wincmd\ w\'\ -c\ \'wincmd\ =\'")
            cnt += _setGitCfgItem(r'mergetool.gdiff.cmd '+vimName+r'\ -f\ -c\ \"Gdiffsplit!\"\ \"\$MERGED\"')
        # git delta
        cnt += _setGitCfgItem('core.pager delta')
        cnt += _setGitCfgItem('pager.diff delta')
        cnt += _setGitCfgItem('pager.log delta')
        cnt += _setGitCfgItem('pager.reflog delta')
        cnt += _setGitCfgItem('pager.show delta')
        cnt += _setGitCfgItem('include.path ~/.config/delta/themes.gitconfig')
        cnt += _setGitCfgItem('delta.features coracias-caudatus')
        cnt += _setGitCfgItem('delta.navigate true')
        cnt += _setGitCfgItem('credential.helper store')
    print(f'copy lazygit or git config {cnt} files or items')
    return cnt


def copyToolCfg(toSystem: bool, vimName: str) -> int:
    cnt = 0
    cnt += _copyFileItemByName(toSystem, 't/fbtermrc')
    cnt += _copyFileItemByName(toSystem, 't/tmux.conf')
    cnt += _copyFileItemByName(toSystem, 't/ctags/ctags.d')
    cnt += _copyFileItemByName(toSystem, 't/vscode/settings.json')
    cnt += _copyFileItemByName(toSystem, 't/vscode/keybindings.json')
    cnt += copyGitCfg(toSystem, vimName)
    cnt += _copyFileItemByName(toSystem, 't/ripgrep.conf')
    cnt += _copyFileItemByName(toSystem, 't/fdignore.conf')
    print(f'copy tool config {cnt} files or items')
    return cnt

def copyDbgToDir(path:str) -> int:
    if path is None or len(path) == 0:
        path = os.getcwd()
    elif not os.path.exists(path):
        print(f'the path is not exists: {path}')
        return 0
    return _copyFileItem(True, FileItem('vim/vimspector.json', all=os.path.join(path, '.vimspector.json'), needCreate=True))

def sedConfig(sed:str) -> None:
    cnt = 0
    for item in _os_file_list:
        if item.seds is None: continue
        sedItem = item.seds.get(sed)
        if sedItem is None: continue
        changed = 0
        with open(os.path.join(_cur_dir, item.f), 'r+', encoding='utf-8') as f:
            lines = f.readlines()
            for i, line in enumerate(lines):
                for k, v in sedItem.items():
                    newLine = line.replace(k, v)
                    if newLine != line:
                        lines[i] = newLine
                        line = newLine
                        changed = 1
            if changed > 0:
                f.seek(0)
                f.truncate()
                f.writelines(lines)
                cnt += 1
                print(f'sed the config file: {item.f}')
    print(f'sed config file total count: {cnt}')

def main() -> None:
    # [add_argument() 方法](https://docs.python.org/zh-cn/3/library/argparse.html#argparse.ArgumentParser.add_argument)
    parser = argparse.ArgumentParser(description='this is not only the configuration of vim, also have other software configuration')
    parser.add_argument('-t', '--toSystem', default=False, help='if True then copy config files from git to system path', action='store_true')
    parser.add_argument('-a', '--all', default=False, help='enable all option', action='store_true')
    parser.add_argument('--sed', default=None, nargs='?', choices=('hk', 'usagate'), const='hk')
    parser.add_argument('--nvim', default=False, action='store_true')
    parser.add_argument('--vim', default=False, action='store_true')
    parser.add_argument('--dbg', default=False, action='store_true')
    parser.add_argument('--cpdbg', default=None, nargs='?', const='')
    parser.add_argument('--te', default=False, action='store_true')
    parser.add_argument('--vifm', default=False, action='store_true')
    parser.add_argument('--sshd', default=False, action='store_true')
    parser.add_argument('--ssh', default=False, action='store_true')
    parser.add_argument('--git', default=False, action='store_true')
    parser.add_argument('--tool', default=False, action='store_true')
    parser.add_argument('--tmux', default=False, action='store_true')
    parser.add_argument('--fbterm', default=False, action='store_true')
    parser.add_argument('--w3m', default=False, action='store_true')
    parser.add_argument('--lightdm', default=False, action='store_true')
    parser.add_argument('--i3', default=False, action='store_true')
    parser.add_argument('--net', default=False, action='store_true')
    parser.add_argument('--lemonade', default=False, action='store_true')
    parser.add_argument('--keymap', default=False, action='store_true')
    args = parser.parse_args()

    if args.sed:
        sedConfig(args.sed)

    cnt = 0
    toSystem = args.toSystem
    all = args.all
    vimName = 'nvim'
    vimCnt = 0
    if args.vim:
        cnt += copyVimCfg(toSystem, False)
        vimName = 'vim'
        vimCnt += 1
    if all or args.nvim:
        cnt += copyVimCfg(toSystem, True)
        vimName = 'nvim'
        vimCnt += 1
    if vimCnt != 1:
        vifm_vicmd = os.environ.get('VIFM_VICMD')
        if vifm_vicmd is not None:
            vimName = vifm_vicmd
    if all or args.dbg:
        cnt += _copyFileItemByName(toSystem, 'vim/vimspector.json')
    if args.cpdbg is not None:
        cnt += copyDbgToDir(args.cpdbg)
    if all or args.te:
        cnt += copyTerminalCfg(toSystem)
    if all or args.vifm:
        cnt += copyVifmCfg(toSystem)
    if all or args.sshd:
        cnt += copySshdCfg(toSystem)
    if all or args.ssh:
        cnt += copySshCfg(toSystem)
    if all or args.git:
        cnt += copyGitCfg(toSystem, vimName)
    if all or args.tool:
        cnt += copyToolCfg(toSystem, vimName)
    if all or args.tmux:
        cnt += _copyFileItemByName(toSystem, 't/tmux.conf')
    if all or args.fbterm:
        cnt += _copyFileItemByName(toSystem, 't/fbtermrc')
    if all or args.w3m:
        cnt += _copyFileItemByName(toSystem, 'net/w3m-config-mac.conf')
        cnt += _copyFileItemByName(toSystem, 'net/w3m-config-linux.conf')
    if all or args.i3:
        cnt += _copyFileItemByName(toSystem, 'os/linux/i3.config')
    if all or args.lightdm:
        cnt += _copyFileItemByName(toSystem, 'os/linux/lightdm.conf')
    if all or args.net:
        cnt += _copyFileItemByName(toSystem, 'net/proxychains.conf')
        cnt += _copyFileItemByName(toSystem, 'net/lftprc.conf')
    if all or args.lemonade:
        cnt += _copyFileItemByName(toSystem, 't/lemonade/lemonade.toml')
        cnt += _copyFileItemByName(toSystem, 't/lemonade/lemonade.service')
    if all or args.keymap:
        cnt += _copyFileItemByName(toSystem, 'os/linux/service/load_tty_keymaps.service')
        cnt += _copyFileItemByName(toSystem, 'os/linux/etc/my_keymaps_tty')
        cnt += _copyFileItemByName(toSystem, 'os/linux/x11/keymap/altwin')
        cnt += _copyFileItemByName(toSystem, 'os/linux/x11/keymap/pc')
        if toSystem:
            os.system('systemctl enable load_tty_keymaps')
    print(f'copy total {cnt} file done')


if __name__ == '__main__':
    main()
