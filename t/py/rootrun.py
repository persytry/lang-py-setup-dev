# -*- coding:utf-8 -*-
'''
@date 2022/05/29 13:45:59
@purpose run commands as root
'''
import os, sys, subprocess

def main() -> None:
    args = sys.argv[1:]
    if os.geteuid():
        os.execlp('sudo', 'sudo', *args)
    else:
        subprocess.run(args)

if __name__ == '__main__':
    main()

