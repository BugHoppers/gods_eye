#!/usr/bin/env python3

import os
import sys

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
            dir = find("config.ge", path)
            if dir is not False:
                with open(dir) as file:
                    sudoPassword = file.read()
                break
        if dir is False:
            raise FileNotFoundError("Couldnot find config file for God's Eye !")
            
    except Exception as e :
        print(str(e))
        quit()

    command = ' '.join(sys.argv[1:])

    os.system('echo %s|sudo -S %s' % (sudoPassword, command))


if __name__=='__main__':
    main() 