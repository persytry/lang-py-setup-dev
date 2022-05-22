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


_cur_dir = os.path.dirname(os.path.realpath(__file__))
_cur_dir = os.path.realpath(_cur_dir)
# name  win mac linux
_os_file_list = [
    ['vim/nvim', '~/AppData/Local/nvim', '~/.config/nvim', '~/.config/nvim'],
    ['vim/nvim/init.vim', '~/.vimrc', '~/.vimrc', '~/.vimrc'],
    ['vim/nvim/coc-settings.json', '~/vimfiles/coc-settings.json', '~/.vim/coc-settings.json', '~/.vim/coc-settings.json'],
    ['vim/nvim/autoload', '~/vimfiles/autoload', '~/.vim/autoload', '~/.vim/autoload'],
    ['vim/nvim/mycmd', '~/vimfiles/mycmd', '~/.vim/mycmd', '~/.vim/mycmd'],
    ['vim/vimspector.json', os.path.join(_cur_dir, '../../../../.vimspector.json'), os.path.join(_cur_dir, '../../../../.vimspector.json'), os.path.join(_cur_dir, '../../../../.vimspector.json')],
    ['os/win/terminal/settings.json', '~/AppData/Local/Packages/Microsoft.WindowsTerminal_*/LocalState/settings.json', None, None],
    ['t/vifm/cmn.vifm', '~/AppData/Roaming/Vifm/cmn.vifm', '~/.config/vifm/cmn.vifm', '~/.config/vifm/cmn.vifm'],
    ['t/vifm/vifmrc-win', '~/AppData/Roaming/Vifm/vifmrc', None, None],
    ['t/vifm/vifmrc-osx', None, '~/.config/vifm/vifmrc', None],
    ['t/vifm/vifmrc-linux', None, None, '~/.config/vifm/vifmrc'],
    ['t/vifm/colors/Default.vifm', '~/AppData/Roaming/Vifm/colors/Default.vifm', '~/.config/vifm/colors/Default.vifm', None],
    ['t/vifm/colors/Default-linux.vifm', None, None, '~/.config/vifm/colors/Default.vifm'],
    ['t/vifm/colors/solarized-light.vifm', '~/AppData/Roaming/Vifm/colors/solarized-light.vifm', '~/.config/vifm/colors/solarized-light.vifm', '~/.config/vifm/colors/solarized-light.vifm'],
    # 需要拷贝文件: $HOME/.ssh/authorized_keys
    ['net/ssh/sshd_config.conf', 'C:/ProgramData/ssh/sshd_config', None, None],
    ['net/ssh/config.conf', None, '~/.ssh/config', '~/.ssh/config'],
    ['net/ssh/config_win.conf', '~/.ssh/config', None, None],
    # https://github.com/shunf4/proxychains-windows
    ['net/proxychains.conf', '~/.proxychains/proxychains.conf', '/usr/local/etc/proxychains.conf', '/usr/local/etc/proxychains.conf'],
    ['net/w3m-config-mac.conf',None,'~/.w3m/config',None],
    ['net/w3m-config-linux.conf',None,None,'~/.w3m/config'],
    ['net/lftprc.conf','~/.config/lftp/rc','~/.config/lftp/rc','~/.config/lftp/rc'],
    ['t/lazygit-config.yml', '~/.config/jesseduffield/lazygit/config.yml', '~/Library/Application Support/jesseduffield/lazygit/config.yml', '~/Library/Application Support/jesseduffield/lazygit/config.yml'],
    ['t/fbtermrc',None,None,'~/.fbtermrc'],
    ['t/tmux.conf',None,'~/.tmux.conf','~/.tmux.conf'],
    ['os/linux/terminator/config',None,None,'~/.config/terminator/config'],
    # ['os/linux/cmn_profile.sh',None,'~/.cmn_profile.sh','~/.cmn_profile.sh'],
    # mac和linux下不需要拷贝这个文件了,因为已经在环境变量和init.vim中配置过了
    ['vim/gtags.conf','~/.globalrc','~/.globalrc','~/.globalrc'],
    ['os/linux/i3/config', None, None, '~/.config/i3/config'],
    ['t/delta-themes.gitconfig','~/.config/delta/themes.gitconfig','~/.config/delta/themes.gitconfig','~/.config/delta/themes.gitconfig'],
    # ['t/ctags/ctags','~/.ctags','~/.ctags','~/.ctags'], # 这是Exuberant Ctags 5.8的配置
    ['t/ctags/ctags.d','~/.ctags.d','~/.ctags.d','~/.ctags.d'], # 这是Universal Ctags 5.9.0及以上的配置
    ['t/vscode/settings.json','~/AppData/Roaming/Code/User/settings.json','~/Library/Application Support/Code/User/settings.json',None],
    ['t/vscode/keybindings.json','~/AppData/Roaming/Code/User/keybindings.json','~/Library/Application Support/Code/User/keybindings.json',None],
    # 不要忘记lemonade.service的存在
    ['t/lemonade/lemonade.toml','~/.config/lemonade.toml','~/.config/lemonade.toml','~/.config/lemonade.toml'],
    ['t/ripgrep.conf','~/.config/ripgrep.conf','~/.config/ripgrep.conf','~/.config/ripgrep.conf'],
    ['t/fdignore.conf','~/.config/fd/ignore','~/.config/fd/ignore','~/.config/fd/ignore']
]
_os_file_map = {}
if len(_os_file_map) != len(_os_file_list):
    for i, v in enumerate(_os_file_list):
        _os_file_map[v[0]] = i

def _isWindows() -> bool:
    return platform.system() == 'Windows'


def _isMac() -> bool:
    return platform.system() == 'Darwin'


def _copyFileImpl(srcPath: str, dstPath: str) -> int:
    if not os.path.exists(srcPath):
        return 0
    if os.path.isfile(srcPath):
        dstDir = os.path.dirname(dstPath)
        if not os.path.exists(dstDir):
            os.makedirs(dstDir)
        shutil.copy(srcPath, dstPath)
        print(f"file src:{srcPath}, dst:{dstPath}")
        return 1
    if not os.path.exists(dstPath):
        os.makedirs(dstPath)
    srcList = os.listdir(srcPath)

    cnt = 0
    for src in srcList:
        if src == 'plugged':
            continue
        p = os.path.join(srcPath, src)
        dst = os.path.join(dstPath, src)
        if os.path.isdir(p):
            cnt += _copyFileImpl(p, dst)
        else:
            if src.startswith('.') and src not in _os_file_map:
                continue
            shutil.copy(p, dst)
            print(f"file src:{p}, dst:{dst}")
            cnt += 1
    return cnt


def _copyFileItem(toSystem: bool, item: list, chmod: int) -> int:
    assert len(item) == 4
    if _isWindows():
        if item[1] is None:
            return 0
        sysPath = os.path.expanduser(item[1])
    elif _isMac():
        if item[2] is None:
            return 0
        sysPath = os.path.expanduser(item[2])
    else:
        if item[3] is None:
            return 0
        sysPath = os.path.expanduser(item[3])
    sysPath = os.path.realpath(sysPath)
    _sysPath = glob.glob(sysPath)
    if len(_sysPath) != 0:
        sysPath = _sysPath[0]
    curPath = os.path.realpath(os.path.join(_cur_dir, item[0]))
    if toSystem:
        cnt = _copyFileImpl(curPath, sysPath)
        if chmod > 0:
            os.system(f'chmod {chmod} {sysPath}')
            print(f'chmod {chmod} {sysPath}')
    else:
        cnt = _copyFileImpl(sysPath, curPath)
    return cnt


def _copyFileItemByName(toSystem: bool, itemName: str, chmod: int = 0) -> int:
    item = _os_file_list[_os_file_map[itemName]]
    return _copyFileItem(toSystem, item, chmod)


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
    cnt += _copyFileItemByName(toSystem, 'os/linux/terminator/config')
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
    cnt += _copyFileItemByName(toSystem, 'net/ssh/config.conf', 600)
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
    print(f'copy lazygit or git config {cnt} files or items')
    return cnt


def copyToolCfg(toSystem: bool, vimName: str) -> int:
    cnt = 0
    cnt += _copyFileItemByName(toSystem, 't/fbtermrc')
    cnt += _copyFileItemByName(toSystem, 't/tmux.conf')
    # cnt += _copyFileItemByName(toSystem, 't/ctags/ctags')
    cnt += _copyFileItemByName(toSystem, 't/ctags/ctags.d')
    cnt += _copyFileItemByName(toSystem, 't/vscode/settings.json')
    cnt += _copyFileItemByName(toSystem, 't/vscode/keybindings.json')
    cnt += copyGitCfg(toSystem, vimName)
    cnt += _copyFileItemByName(toSystem, 't/ripgrep.conf')
    cnt += _copyFileItemByName(toSystem, 't/fdignore.conf')
    print(f'copy tool config {cnt} files or items')
    return cnt


def main() -> None:
    parser = argparse.ArgumentParser(description='this is not only the configuration of vim, also have other software configuration')
    parser.add_argument('-t', '--toSystem', default=False, help='if True then copy config files from git to system path', action='store_true')
    parser.add_argument('-a', '--all', default=False, help='enable all option', action='store_true')
    parser.add_argument('--nvim', default=False, action='store_true')
    parser.add_argument('--vim', default=False, action='store_true')
    parser.add_argument('--dbg', default=False, action='store_true')
    parser.add_argument('--te', default=False, action='store_true')
    parser.add_argument('--vifm', default=False, action='store_true')
    parser.add_argument('--sshd', default=False, action='store_true')
    parser.add_argument('--ssh', default=False, action='store_true')
    parser.add_argument('--git', default=False, action='store_true')
    parser.add_argument('--tool', default=False, action='store_true')
    parser.add_argument('--tmux', default=False, action='store_true')
    parser.add_argument('--fbterm', default=False, action='store_true')
    parser.add_argument('--w3m', default=False, action='store_true')
    # parser.add_argument('--profile', default=False, action='store_true')
    parser.add_argument('--i3', default=False, action='store_true')
    parser.add_argument('--net', default=False, action='store_true')
    parser.add_argument('--lemonade', default=False, action='store_true')
    args = parser.parse_args()

    cnt = 0
    toSystem = args.toSystem
    all = args.all
    vimName = 'nvim'
    vimCnt = 0
    if all or args.vim:
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
    # if all or args.profile:
        # cnt += _copyFileItemByName(toSystem, 'os/linux/cmn_profile.sh')
    if all or args.i3:
        cnt += _copyFileItemByName(toSystem, 'os/linux/i3/config')
    if all or args.net:
        cnt += _copyFileItemByName(toSystem, 'net/proxychains.conf')
        cnt += _copyFileItemByName(toSystem, 'net/lftprc.conf')
    if all or args.lemonade:
        cnt += _copyFileItemByName(toSystem, 't/lemonade/lemonade.toml')
    print(f'copy total {cnt} file done')


if __name__ == '__main__':
    main()
