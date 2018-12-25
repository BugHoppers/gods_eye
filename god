#!/usr/bin/env python3

import os
import sys
from encrypt import readPass, getPass, CRYPT_DIR
from pathlib import Path

print("This is God's Eye !\n")

def main():
    try:
        dir = os.path.isfile(CRYPT_DIR + "/" + "config.ge.enc")
        if dir is True:
            sudoPassword = readPass("config.ge.enc")
        else:
            sudoPassword = getPass("config.ge")

    except Exception as e:
        print(str(e))
        quit()

    command=' '.join(sys.argv[1:])

    os.system('echo %s|sudo -S %s' % (sudoPassword, command))


if __name__ == '__main__':
    main()
