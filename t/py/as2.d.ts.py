# -*- coding:utf-8 -*-
'''
@date 2022/05/02 15:47:55
@purpose generate .d.ts file from as3 files
'''
import argparse
import os
import re

asTsTypeMap = {}
_verbose:bool = True;

def handlePaths(paths) -> None:
    if len(paths) != 2:
        print('must input two path, second path is input as3 file or directory, first path is output directory')
        return
    outDir:str = paths[0]
    inPath:str = paths[1]
    cnt:int = handlePath(inPath)
    if _verbose:
        print(f'parse file count: {cnt}')
    if not os.path.exists(outDir):
        os.makedirs(outDir)
    asParser.output(outDir)

def handlePath(inPath: str) -> int:
    if os.path.isfile(inPath):
        return handleFile(inPath)
    cnt:int = 0
    for root, _, files in os.walk(inPath):
        for f in files:
            cnt += handleFile(os.path.join(root, f))
    return cnt

def handleFile(inFile: str) -> int:
    if not asParser.parseFile(inFile):
        print(f'parse the file has error: {inFile}')
        return 0
    return 1

def asType2TsType(astype:str) -> str:
    res = asTsTypeMap.get(astype)
    if res is None: return astype
    return res

def parseTypeMapFromJson(json:str) -> bool:
    if not os.path.exists(json):
        print(f'the json file is not exists: {json}')
        return False
    with open(json, 'r') as f:
        maps = eval(''.join(f.readlines()))
        for k, v in maps.items():
            asTsTypeMap[k] = v
    return True

class AsClass:
    name:str
    base:str

    def __init__(self, name:str, base:str):
        self.name = name
        self.base = base
        self.vars = []

    def writeTo(self, f):
        if self.base is None:
            f.write(f'    class {self.name}\n    {{')
        else:
            f.write(f'    class {self.name} extends {asType2TsType(self.base)}\n    {{\n')
        for var in self.vars:
            var.writeTo(f)
        f.write('    }\n')


class AsVar:
    scope:str
    name:str
    type:str

    def __init__(self, scope:str, name:str, type:str):
        self.scope = scope
        self.name = name
        self.type = type

    def writeTo(self, f):
        s = '        '
        if self.scope != 'public':
            s += f'{self.scope} '
        s += f'{self.name}:{asType2TsType(self.type)};\n'
        f.write(s)

AsClassNull = AsClass('', '')
ArrayNull = []

class AsParser:
    packages:dict

    def __init__(self):
        self.packages = {}

    def parseFile(self, path:str) -> bool:
        arrClasses = ArrayNull
        hasPackage = False
        theCls = AsClassNull
        with open(path, 'r') as f:
            for line in f.readlines():
                package = re.findall(r'^\s*package\s+([\w\.]+)', line);
                if len(package) == 1:
                    arrClasses = self.packages.get(package[0])
                    if not arrClasses:
                        arrClasses = self.packages[package[0]] = []
                    hasPackage = True
                    continue
                cls = re.findall(r'^\s*(?:public\s+)?class\s+(\w+)\s+extends\s+(\w+)', line)
                if len(cls) == 1:
                    cls = cls[0]
                    theCls = AsClass(cls[0], cls[1])
                    arrClasses.append(theCls)
                    continue
                var = re.findall(r'^\s*(\w+)\s+var\s+(\w+)\s*:\s*(\w+)', line)
                if len(var) == 1:
                    var = var[0]
                    theCls.vars.append(AsVar(var[0], var[1], var[2]))
        return hasPackage

    def output(self, path:str) -> None:
        clsCnt = 0
        for package, classes in self.packages.items():
            clsCnt += len(classes)
            with open(f'{os.path.join(path, package.split(".")[-1])}.d.ts', 'w') as f:
                f.write(f'declare namespace {package}\n{{\n')
                for cls in classes:
                    cls.writeTo(f)
                f.write('\n}')
                if _verbose:
                    print(f'generated package:{package}, class count:{len(classes)}')
        if _verbose:
            print(f'generated package count:{len(self.packages)}, class total count:{clsCnt}')
asParser = AsParser()

def main() -> None:
    global _verbose
    parser = argparse.ArgumentParser(description='generate .d.ts file from as3 files')
    parser.add_argument('paths', metavar='path', nargs='+', default='', help='the second path is inputed as3 file or directory, and the first path is output directory')
    parser.add_argument('-v', '--verbose', default=_verbose, help='if verbose', action='store_true')
    parser.add_argument('-j', '--json', default='', help='input json file as as3 type map to typescript type')
    args = parser.parse_args()
    _verbose = args.verbose
    if args.json != '' and parseTypeMapFromJson(args.json) is not True:
        return
    handlePaths(args.paths)

if __name__ == '__main__':
    main()
