#!/usr/bin/env python3

import os
import sys
from encrypt import readPass, getPass
from pathlib import Path

print("This is God's Eye !\n")

def find(name, path):
    for root, dirs, files in os.walk(path):
        if name in files:
            return os.path.join(root, name)
    return False

def main():
    paths = os.get_exec_path()
    try :
        for path in paths :
            if "gods_eye" in path:
                dir = find(".tmp", path)
                if dir is not False:
                    sudoPassword = readPass("config.ge.enc")
                elif dir is False:
                    Path(path + "/.tmp").touch()
                    sudoPassword = getPass("config.ge")
                break
            else:
                continue
            
    except Exception as e :
        print(str(e))
        quit()

    command = ' '.join(sys.argv[1:])

    os.system('echo %s|sudo -S %s' % (sudoPassword, command))


if __name__=='__main__':
    main() 