#!/usr/bin/env python3

import os
import sys
from encrypt import readPass, getPass, CRYPT_DIR
from pathlib import Path

print("This is God's Eye !\n")

def main():
    try:
        dir = os.path.isfile(CRYPT_DIR + "/" + "config.ge.enc")             # search if sudo password is saved
        if dir is True:
            sudoPassword = readPass("config.ge.enc")                        # decrypt and fetch password
        else:
            sudoPassword = getPass("config.ge")                             # get password and encrypt password

    except Exception as e:
        print(str(e))
        quit()

    command=' '.join(sys.argv[1:])

    os.system('echo %s|sudo -S %s' % (sudoPassword, command))               # execute the sudo command needed


if __name__ == '__main__':
    main()
