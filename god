#!/usr/bin/env python3

import os
import sys

print("This is God's Eye !\n")

with open('config.ge') as file:
    sudoPassword = file.read()

command = ' '.join(sys.argv[1:])

os.system('echo %s|sudo -S %s' % (sudoPassword, command))