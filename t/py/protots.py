# -*- coding:utf-8 -*-
'''
@author Persy
@date 2022/04/25 13:45:39
'''
import argparse
import os

_verbose:bool = True;

def handlePaths(paths) -> None:
    if len(paths) != 2:
        print('must input two path, first path is input proto file or directory, second path is output directory')
        return
    inPath:str = paths[0]
    outDir:str = paths[1]
    cnt:int = handlePath(inPath, outDir)
    if _verbose:
        print(f'handle file count: {cnt}')

def handlePath(inPath: str, outDir: str) -> int:
    if os.path.isfile(inPath):
        return handleFile(inPath, outDir)
    cnt:int = 0
    for root, _, files in os.walk(inPath):
        for f in files:
            cnt += handleFile(os.path.join(root, f), outDir)
    return cnt

def handleFile(inFile: str, outDir: str) -> int:
    if not os.path.exists(outDir):
        os.makedirs(outDir)
    res = os.system(f'protoc --plugin=/opt/nodejs/bin/protoc-gen-ts_proto --ts_proto_out={outDir} {inFile}')
    if res != 0:
        print(f'has error: {res}')
        return 0
    if _verbose:
        print(f'handled the file: {inFile}')
    return 1

def main() -> None:
    global _verbose
    parser = argparse.ArgumentParser(description='generate protobuf for typescript')
    parser.add_argument('paths', metavar='path', nargs='+', default='', help='input proto file or directory, and the second path is output directory')
    parser.add_argument('-v', '--verbose', default=_verbose, help='if verbose', action='store_true')
    args = parser.parse_args()
    _verbose = args.verbose
    handlePaths(args.paths)

if __name__ == '__main__':
    main()
