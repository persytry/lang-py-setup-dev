# -*- coding:utf-8 -*-
'''
@date 2022/05/02 15:47:55
@purpose generate .d.ts file from as3 files
'''
import argparse
import os
import re
from typing import Optional

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

class JsonParser:
    globals:dict
    mudulePath:dict

    def __init__(self):
        self.globals = {}
        self.modulePath = {}
        self.modules = []

    def parse(self, jsonPath:str) -> bool:
        if not os.path.exists(jsonPath):
            print(f'the json file is not exists: {jsonPath}')
            return False
        with open(jsonPath, 'r', encoding='utf-8') as f:
            maps = eval(''.join(f.readlines()))
            for k, v in maps['globals'].items():
                self.globals[k] = v
            for v in maps['modules']:
                self.modules.append(v)
            for k, v in maps['modulePath'].items():
                self.modulePath[k] = v
        return True

    def getGlobalType(self, astype:str) -> str:
        res = self.globals.get(astype)
        if res is None: return astype
        return res

    def isModule(self, type:str) -> bool:
        return type in self.modules

    def hasModulePath(self, type:str) -> bool:
        return type in self.modulePath

    def getModulePath(self, module:str) -> str:
        path = self.modulePath.get(module)
        if path is None: return f'./{module}'
        return path

class AsClass:
    _modules:set
    name:str
    base:str

    def __init__(self, name:str, base:str):
        self._modules = set()
        self.name = name
        self.base = base
        self.vars = []
        self.methods = []

    def parseModules(self) -> bool:
        if not jsonParser.isModule(self.name): return False
        self.addModule(self.base)
        for v in self.vars:
            v.addModuleToClass(self)
        for v in self.methods:
            v.addModuleToClass(self)
        return True

    def addModule(self, type:str):
        if jsonParser.isModule(type) or jsonParser.hasModulePath(type):
            self._modules.add(type)

    def writeTo(self, f, spaceN:int, isModule:bool):
        modulePaths = {}
        for module in self._modules:
            modulePath = jsonParser.getModulePath(module)
            arr = modulePaths.get(modulePath)
            if arr is None:
                modulePaths[modulePath] = [module]
                continue
            arr.append(module)
        for modulePath, arrClasses in modulePaths.items():
            arrClasses.sort()
            f.write(f'import {{ {", ".join(arrClasses)} }} from "{modulePath}";\n')
        if isModule is True:
            f.write('\n')
            default = 'default '
        else:
            default = ''
        if self.base is None:
            f.write(f'{" " * spaceN}export {default}class {self.name}\n{" " * spaceN}{{\n')
        else:
            f.write(f'{" " * spaceN}export {default}class {self.name} extends {self.getType(self.base)}\n{" " * spaceN}{{\n')
        for var in self.vars:
            var.writeTo(f, self, spaceN + 4)
        if len(self.methods) > 0:
            f.write('\n')
            for method in self.methods:
                method.writeTo(f, self, spaceN + 4)
        f.write(f'{" " * spaceN}}}\n\n')

    def getType(self, type:str) -> str:
        if type in self._modules:
            return type
        return jsonParser.getGlobalType(type)

class AsVar:
    scope:str
    name:str
    type:str

    def __init__(self, scope:str, name:str, type:str):
        self.scope = scope
        self.name = name
        self.type = type

    def writeTo(self, f, cls:AsClass, spaceN:int):
        s = f'{" " * spaceN}'
        if self.scope != 'public':
            s += f'{self.scope} '
        s += f'{self.name}:{cls.getType(self.type)};\n'
        f.write(s)

    def addModuleToClass(self, cls:AsClass):
        cls.addModule(self.type)

class AsMethodBase:
    def parseLine(self, line:str) -> bool:
        line = line
        return False

    def writeTo(self, f, cls:AsClass, spaceN:int):
        f = f
        cls = cls
        spaceN = spaceN

class AsMethod_createChildren(AsMethodBase):
    def __init__(self):
        self.components = []

    def parseLine(self, line:str) -> bool:
        pattern = re.findall(r'^\s*View\.regComponent\s*\(\s*"(\S+)"\s*,\s*(\w+)', line)
        if len(pattern) != 1: return False
        self.components.append(pattern[0])
        return True

    def writeTo(self, f, cls:AsClass, spaceN:int):
        f.write(f'{" " * spaceN}protected override createChildren():void\n{" " * spaceN}{{\n')
        _spaceN = spaceN + 4
        for t in self.components:
            f.write(f'{" " * _spaceN}{cls.name}.regComponent("{t[0]}", {cls.getType(t[1])});\n')
        f.write(f'{" " * _spaceN}super.createChildren();\n{" " * _spaceN}this.loadScene("{cls.name[:-2]}");\n')
        f.write(f'{" " * spaceN}}}\n')

    def addModuleToClass(self, cls:AsClass):
        for t in self.components:
            cls.addModule(t[1])

def parseAsMethod(line:str, method:Optional[AsMethodBase]) -> Optional[AsMethodBase]:
    func = re.findall(r'^.*function\s+(\w+)', line)
    if len(func) != 1: return method
    func = func[0]
    if func == 'createChildren':
        return AsMethod_createChildren()
    return method

class AsParser:
    packages:dict[str, list[AsClass]]

    def __init__(self):
        self.packages = {}

    def parseFile(self, path:str) -> bool:
        arrClasses:Optional[list[AsClass]] = None
        hasPackage = False
        theCls:Optional[AsClass] = None
        methodOld:Optional[AsMethodBase] = None
        method:Optional[AsMethodBase] = None
        isParseMethod = False
        with open(path, 'r', encoding='utf-8') as f:
            for line in f.readlines():
                package = re.findall(r'^\s*package\s+([\w\.]+)', line)
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
                    if arrClasses is not None:
                        arrClasses.append(theCls)
                    isParseMethod = jsonParser.isModule(theCls.name)
                    continue
                var = re.findall(r'^\s*(\w+)\s+var\s+(\w+)\s*:\s*(\w+)', line)
                if len(var) == 1:
                    var = var[0]
                    if theCls is not None:
                        theCls.vars.append(AsVar(var[0], var[1], var[2]))
                    continue
                if isParseMethod:
                    method = parseAsMethod(line, method)
                    if method is not None:
                        if method is not methodOld:
                            methodOld = method
                            if theCls is not None:
                                theCls.methods.append(method)
                        if method.parseLine(line):
                            continue
        return hasPackage

    def output(self, path:str) -> None:
        clsCnt = 0
        for package, classes in self.packages.items():
            clsCnt += len(classes)
            modules = []
            classesBundle = []
            for cls in classes:
                if cls.parseModules():
                    modules.append(cls)
                else:
                    classesBundle.append(cls)
            for module in modules:
                with open(f'{os.path.join(path, module.name)}.ts', 'w', encoding='utf-8') as f:
                    module.writeTo(f, 0, True)
            if _verbose:
                print(f'generated module count:{len(modules)}')
            if len(classesBundle) == 0:
                continue
            with open(f'{os.path.join(path, package.split(".")[-1])}.d.ts', 'w', encoding='utf-8') as f:
                f.write(f'declare namespace {package}\n{{\n')
                for cls in classesBundle:
                    cls.writeTo(f, 4, False)
                f.write('}')
                if _verbose:
                    print(f'generated package:{package}, class count:{len(classesBundle)}')
        if _verbose:
            print(f'generated package count:{len(self.packages)}, class total count:{clsCnt}')

asParser = AsParser()
jsonParser = JsonParser()

def main() -> None:
    global _verbose
    parser = argparse.ArgumentParser(description='generate .d.ts file from as3 files')
    parser.add_argument('paths', metavar='path', nargs='+', default='', help='the second path is inputed as3 file or directory, and the first path is output directory')
    parser.add_argument('-v', '--verbose', default=_verbose, help='if verbose', action='store_true')
    parser.add_argument('-j', '--json', default='', help='input json file as as3 type map to typescript type')
    args = parser.parse_args()
    _verbose = args.verbose
    if args.json != '' and jsonParser.parse(args.json) is not True:
        return
    handlePaths(args.paths)

if __name__ == '__main__':
    main()
