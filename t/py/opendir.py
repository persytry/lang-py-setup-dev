# -*- coding:utf-8 -*-
'''
@date 2022/05/06 15:32:02
@purpose opendir from inputed file
'''
import argparse
import os
import platform
import re

_verbose:bool = True;

def handlePaths(paths) -> None:
    for inPath in paths:
        handlePath(inPath if inPath.find(':') >= 0 else os.path.realpath(inPath))

# 若是想要最大的灵活性,就不要判断: os.path.isfile(inPath)
def handlePath(inPath: str):
    strsys = platform.system()
    isWin = strsys == 'Windows'
    if isWin or _isWsl():
        if not isWin:
            inPath = re.sub(r'^/mnt/(\w)/', r'\1:/', inPath, 1)
        inPath = inPath.replace(r'/', '\\')
        return _system(f'explorer.exe /select,"{inPath}"')
    elif strsys == 'Darwin':
        return _system(f'open -R "{inPath}"')
    else:
        return _system(f'nautilus --select "{inPath}"')

def _isWsl() -> bool:
    path = os.environ.get('PATH')
    if path is None:
        path = os.environ.get('path')
        if path is None:
            return False
    return path.lower().find('/mnt/c/windows') >= 0

def _system(cmd:str):
    if _verbose:
        print(f'opendir command: {cmd}')
    return os.system(cmd)

def main() -> None:
    global _verbose
    parser = argparse.ArgumentParser(description='opendir from inputed file')
    parser.add_argument('paths', metavar='path', nargs='+', default='', help='the inputed paths which need to open and select it')
    parser.add_argument('-v', '--verbose', default=_verbose, help='if verbose', action='store_true')
    args = parser.parse_args()
    _verbose = args.verbose
    handlePaths(args.paths)

if __name__ == '__main__':
    main()
