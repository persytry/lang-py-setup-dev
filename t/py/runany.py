# -*- coding:utf-8 -*-
'''
@date 2022/05/02 19:20:14
@purpose run file any ancestral path
'''
import argparse
import os
import subprocess

_verbose:bool = True;

def handleFile(file: str):
    dir = os.path.abspath(os.path.dirname(os.getcwd()))
    while True:
        p = os.path.join(dir, file)
        if os.path.exists(p):
            subprocess.run(p, cwd=dir)
            break;
        _dir = os.path.abspath(os.path.join(dir, '../'))
        if _dir == dir: break
        dir = _dir

def main() -> None:
    global _verbose
    parser = argparse.ArgumentParser(description='run file any ancestral path')
    parser.add_argument('file', metavar='file', nargs='+', default='', help='in put a file to run, the file could exists at ancestral path')
    parser.add_argument('-v', '--verbose', default=_verbose, help='if verbose', action='store_true')
    args = parser.parse_args()
    _verbose = args.verbose
    handleFile(args.file[0])

if __name__ == '__main__':
    main()

