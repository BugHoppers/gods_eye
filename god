#!/usr/bin/env python3

import os
import sys
from encrypt import readPass, getPass
from pathlib import Path

print("This is God's Eye !\n")

def main():
    try:
        dir=(os.path.exists(str(Path.home()) + "/.god"))
        if dir is not False:
            sudoPassword=readPass("config.ge.enc")
        elif dir is False:
            sudoPassword=getPass("config.ge")

    except Exception as e:
        print(str(e))
        quit()

    command=' '.join(sys.argv[1:])

    os.system('echo %s|sudo -S %s' % (sudoPassword, command))


if __name__ == '__main__':
    main()
    