# -*- coding:utf-8 -*-
'''
@author Persy
@date 2022/4/20 21:34
'''
import argparse
import os
import re

_verbose:bool = True;

def retabPaths(paths) -> None:
    cnt:int = 0
    for p in paths:
        cnt += retabPath(p)
    if _verbose:
        print(f'retab file count: {cnt}')

def retabPath(p: str) -> int:
    if os.path.isfile(p):
        return retabFile(p)
    cnt:int = 0
    for root, _, files in os.walk(p):
        for f in files:
            cnt += retabFile(os.path.join(root, f))
    return cnt

def retabFile(p: str) -> int:
    changed = 0
    with open(p, 'r+', encoding='utf-8') as f:
        lines = f.readlines()
        for i, line in enumerate(lines):
            newLine = re.sub('^[ \t\r\n]+$', '\n', line)
            if newLine != line:
                lines[i] = newLine
                changed = 1
                continue
            newLine = line.replace('\r', '')
            newLine = newLine.replace('\t', '    ')
            if newLine != line:
                lines[i] = newLine
                changed = 1
        if changed > 0:
            if _verbose:
                print(f'retab the file: {p}')
            f.seek(0)
            f.truncate()
            f.writelines(lines)
    return changed

def main() -> None:
    global _verbose
    parser = argparse.ArgumentParser(description='retab the name is same as the command retab of vim, it is help to format files which contains \\t convert to 4 spaces, and delete all blank characters of blank line.')
    parser.add_argument('paths', metavar='path', nargs='+', default='', help='retab the file of the path if the path is a file of path, if the path is a directory, it will be retab all files in the directory recursively.')
    parser.add_argument('-v', '--verbose', default=_verbose, help='if verbose', action='store_true')
    args = parser.parse_args()
    _verbose = args.verbose
    retabPaths(args.paths)

if __name__ == '__main__':
    main()
