# -*- coding:utf-8 -*-
'''
@date 2022/05/04 13:49:08
@purpose run commands forever
'''
import argparse
import asyncio
from datetime import datetime
import builtins

_verbose:bool = True;
_sleepSeconds = 10

__old_print = builtins.print
__num_of_print = 0
def __print_num(*args, **kwargs):
    global __num_of_print
    __num_of_print += 1
    __old_print(__num_of_print, datetime.now(), *args, **kwargs)
builtins.print = __print_num

async def runOne(cmd:str):
    if _verbose:
        print(f'begin run the command:{cmd}')
    while True:
        proc = await asyncio.create_subprocess_shell(cmd)
        await proc.communicate()
        if _verbose:
            print(f'{cmd!r} exited with {proc.returncode}, and then restart the command after {_sleepSeconds} seconds')
        await asyncio.sleep(_sleepSeconds)

async def run(commands):
    fns = []
    for cmd in commands:
        fns.append(runOne(cmd))
    await asyncio.wait(fns)

def main() -> None:
    global _verbose
    parser = argparse.ArgumentParser(description='run file any ancestral path')
    parser.add_argument('commands', metavar='commands', nargs='+', default='', help='input commands to run forever')
    parser.add_argument('-v', '--verbose', default=_verbose, help='if verbose', action='store_true')
    args = parser.parse_args()
    _verbose = args.verbose
    asyncio.run(run(args.commands))

if __name__ == '__main__':
    main()

