# -*- coding:utf-8 -*-
"""
batch operators of git
@date: 2021/9/21 19:36
@author: persy
"""
import subprocess
import os
import argparse
import asyncio

def isInsideWorkTree(path: str) -> bool:
    if path is None:
        path = os.getcwd()
    else:
        path = os.path.expanduser(path)
        path = os.path.realpath(path)
        if not os.path.exists(path): return False
    return _isInsideWorkTree(path)


def hasDiff(path: str) -> bool:
    if path is None:
        path = os.getcwd()
    else:
        path = os.path.expanduser(path)
        path = os.path.realpath(path)
        if not os.path.exists(path): return False
    return _hasDiff(path)

def hasStaged(path: str) -> bool:
    if path is None:
        path = os.getcwd()
    else:
        path = os.path.expanduser(path)
        path = os.path.realpath(path)
        if not os.path.exists(path): return False
    return _hasStaged(path)

def pushable(path: str) -> bool:
    if path is None:
        path = os.getcwd()
    else:
        path = os.path.expanduser(path)
        path = os.path.realpath(path)
        if not os.path.exists(path): return False
    return _pushable(path)


def walkRepo(path: str):
    if path is None:
        path = os.getcwd()
    else:
        path = os.path.expanduser(path)
        path = os.path.realpath(path)
    if _isInsideWorkTree(path):
        yield path
        return
    yield from _walkRepo(path)


def walkRepoDiff(path: str):
    for repo in walkRepo(path):
        if _hasDiff(repo):
            yield repo

def walkRepoStaged(path: str):
    for repo in walkRepo(path):
        if _hasStaged(repo):
            yield repo

def walkRepoPushable(path: str):
    for repo in walkRepo(path):
        if _pushable(repo):
            yield repo


def commitAll(comment: str, path: str) -> None:
    if comment is None or len(comment) == 0:
        print('must input comment to commit')
        return
    for repo in walkRepoStaged(path):
        print(repo)
        res = subprocess.run(['git', 'commit', '-m', f'{comment}'], check=False, timeout=60, text=True, shell=False, cwd=repo, universal_newlines=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        print(res.stdout)
        print(res.stderr)

async def _asyncOne(cmd:str, repo:str):
    print(repo)
    proc = await asyncio.create_subprocess_shell(cmd, cwd=repo)
    await asyncio.wait_for(proc.communicate(), timeout=60)

def pullAllSync(path: str) -> None:
    for repo in walkRepo(path):
        print(repo)
        res = subprocess.run(['git', 'pull'], check=False, timeout=60, text=True, shell=False, cwd=repo, universal_newlines=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        print(res.stdout)
        print(res.stderr)

def pullAll(path: str) -> None:
    fns = []
    for repo in walkRepo(path):
        fns.append(_asyncOne('git pull', repo))
    asyncio.run(asyncio.wait(fns))

def pushAllSync(path: str) -> None:
    for repo in walkRepoPushable(path):
        print(repo)
        res = subprocess.run(['git', 'push'], check=False, timeout=60, text=True, shell=False, cwd=repo, universal_newlines=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        print(res.stdout)
        print(res.stderr)

def pushAll(path: str) -> None:
    fns = []
    for repo in walkRepoPushable(path):
        fns.append(_asyncOne('git push', repo))
    if len(fns) == 0: return;
    asyncio.run(asyncio.wait(fns))


def printRepo(path: str) -> None:
    for repo in walkRepo(path):
        print(repo)


def printRepoDiff(path: str) -> None:
    for repo in walkRepoDiff(path):
        print(repo)

def printRepoStaged(path: str) -> None:
    for repo in walkRepoStaged(path):
        print(repo)

def printRepoPushable(path: str) -> None:
    for repo in walkRepoPushable(path):
        print(repo)


def _isInsideWorkTree(path: str) -> bool:
    res = subprocess.run(['git', 'rev-parse', '--is-inside-work-tree'], check=False, timeout=60, text=True, shell=False, cwd=path, stdout=subprocess.PIPE, universal_newlines=True, stderr=subprocess.DEVNULL)
    if res.returncode != 0: return False
    return res.stdout.strip() == 'true'


def _hasDiff(path: str) -> bool:
    res = subprocess.run(['git', 'diff', '--quiet'], check=False, timeout=60, text=True, shell=False, cwd=path, stdout=subprocess.DEVNULL, universal_newlines=True, stderr=subprocess.DEVNULL)
    return res.returncode == 1


def _hasStaged(path: str) -> bool:
    res = subprocess.run(['git', 'diff', '--staged', '--quiet'], check=False, timeout=60, text=True, shell=False, cwd=path, stdout=subprocess.DEVNULL, universal_newlines=True, stderr=subprocess.DEVNULL)
    return res.returncode == 1

def _pushable(path: str) -> bool:
    res = subprocess.run(['git', 'cherry', '-v'], check=False, timeout=60, text=True, shell=False, cwd=path, stdout=subprocess.PIPE, universal_newlines=True, stderr=subprocess.DEVNULL)
    if res.returncode != 0: return False
    return len(res.stdout) != 0


def _walkRepo(path: str):
    for d in os.listdir(path):
        dir = os.path.join(path, d)
        if not os.path.isdir(dir): continue
        if _isInsideWorkTree(dir):
            yield dir
            continue
        yield from _walkRepo(dir)


def main() -> None:
    parser = argparse.ArgumentParser(description='')
    parser.add_argument('--path', type=str, default=None, help='current directory as default')
    sub_parser = parser.add_subparsers(help='sub-commands')
    sub_parser.add_parser('repo', help='print all git repo').set_defaults(func=lambda a: printRepo(a.path))
    sub_parser.add_parser('diff', help='print unstage repo').set_defaults(func=lambda a: printRepoDiff(a.path))
    sub_parser.add_parser('staged', help='print unstage repo').set_defaults(func=lambda a: printRepoStaged(a.path))
    sub_parser.add_parser('pushable', help='print pushable repo').set_defaults(func=lambda a: printRepoPushable(a.path))
    sub = sub_parser.add_parser('commit', help='commit all repo which committable(staged repo)')
    sub.add_argument('m', nargs='+')
    sub.set_defaults(func=lambda a: commitAll(' '.join(a.m), a.path))
    sub_parser.add_parser('pull', help='pull async').set_defaults(func=lambda a: pullAll(a.path))
    sub_parser.add_parser('pulls', help='pull sync').set_defaults(func=lambda a: pullAllSync(a.path))
    sub_parser.add_parser('push', help='push async').set_defaults(func=lambda a: pushAll(a.path))
    sub_parser.add_parser('pushs', help='push sync').set_defaults(func=lambda a: pushAllSync(a.path))
    args = parser.parse_args()
    fn = getattr(args, 'func', None)
    if fn is not None:
        fn(args)


if __name__ == '__main__':
    main()
