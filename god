#!/usr/bin/env python3

import os
import sys
from encrypt import readPass, getPass, CRYPT_DIR
from pathlib import Path
from FaceRec import capture, matchFace

print("This is God's Eye !\n")

def main():
    try:
        dir = os.path.isfile(CRYPT_DIR + "/" + "config.ge.enc")             # search if sudo password is saved
        if dir is True:
            found = matchFace(CRYPT_DIR + "/capture")
            if found :
                sudoPassword = readPass("config.ge.enc")                        # decrypt and fetch password
            else :
                print("No match!!")
                quit()
        else:
            sudoPassword = getPass("config.ge")                             # get password and encrypt password
            name = str(input("Name:"))
            os.mkdir(CRYPT_DIR + "/capture")
            capture(CRYPT_DIR + "/capture/" + name)

    except Exception as e:
        print(str(e))
        quit()

    command=' '.join(sys.argv[1:])

    os.system('echo %s|sudo -S %s' % (sudoPassword, command))               # execute the sudo command needed


if __name__ == '__main__':
    main()
