# -*- coding:utf-8 -*-
'''
@author Persy
@date 2022/4/20 21:34
'''
import argparse

def retabPaths(paths, verbose:bool) -> None:
    for p in paths:
        retabPath(p, verbose)

def retabPath(p: str, verbose:bool) -> None:
    if verbose:
        print(p)

def main() -> None:
    parser = argparse.ArgumentParser(description='retab the name is same as the command retab of vim, it is help to format files which contains \\t convert to 4 spaces, and delete all blank characters of blank line.')
    parser.add_argument('paths', metavar='path', nargs='+', default='', help='retab the file of the path if the path is a file of path, if the path is a directory, it will be retab all files in the directory recursively.')
    parser.add_argument('-v', '--verbose', default=True, help='if verbose', action='store_true')
    args = parser.parse_args()
    retabPaths(args.paths, args.verbose)

if __name__ == '__main__':
    main()
