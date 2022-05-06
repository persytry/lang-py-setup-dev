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
    cnt = 0
    for inPath in paths:
        cnt += handlePath(inPath)
    if _verbose:
        print(f'handled file count:{cnt}')

def _getOpendirBat() -> str:
    return os.path.abspath('~/a/git/lang/py/setup/dev/os/win/sh/opendir.bat')

def handlePath(inPath: str) -> int:
    isWin = platform.system() == 'Windows'
    if isWin or _isWsl():
        pathOld = inPath
        if not isWin:
            inPath = re.sub(r'^/mnt/(\w)/', r'\1:/', inPath, 1)
        inPath = inPath.replace(r'/', r'\\')
        if os.path.isfile(pathOld):
            return 0 == os.system(f'{_getOpendirBat()} "{inPath}"')
        else:
            return 0 == os.system(f'{_getOpendirBat()} "{inPath}" 1')
    else:
        if os.path.isfile(inPath):
            return 0 == os.system(f'open -R "{inPath}"')
        else:
            return 0 == os.system(f'open "{inPath}"')

def _isWsl() -> bool:
    path = os.environ.get('PATH')
    if path is None:
        path = os.environ.get('path')
        if path is None:
            return False
    return path.lower().find('/mnt/c/windows') >= 0

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
