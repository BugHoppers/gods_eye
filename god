#!/usr/bin/env python3

import os
import sys
import glob
import subprocess
from pathlib import Path
from FaceRec import capture, matchFace
from encrypt import readPass, getPass, CRYPT_DIR

print("This is God's Eye !\n")


def find_brightness():
    bright_dir = glob.glob(os.path.abspath(os.sep) + 'sys/class/backlight/' + '*')[0]
    max_bright_dir = open(bright_dir + "/max_brightness")
    curr_bright_dir = open(bright_dir + "/brightness")
    max_bright = int(max_bright_dir.read())
    curr_bright = int(curr_bright_dir.read())
    max_bright_dir.close()
    curr_bright_dir.close()
    temp = (curr_bright / max_bright) * 100
    return temp


def set_brightness(bright_percent):
    os.system('gdbus call --session --dest org.gnome.SettingsDaemon.Power --object-path '
              '/org/gnome/SettingsDaemon/Power --method org.freedesktop.DBus.Properties.Set '
              'org.gnome.SettingsDaemon.Power.Screen Brightness "<int32 %d>" >/dev/null' % (bright_percent))

def run_command(command, sudo_pass):
    command = command.split()

    pass_cmd = subprocess.Popen(['echo', sudo_pass], stdout=subprocess.PIPE)
    p = subprocess.Popen(['sudo','-S'] + command, stdin=pass_cmd.stdout, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

    while True:
        retcode = p.poll()
        line = p.stdout.readline().decode()
        yield line
        if retcode is not None:
            yield '\n'
            break


def main():
    try:
        init_bright_percent = find_brightness()  # find the current brightness
        dir = os.path.isfile(CRYPT_DIR + "/" + "config.ge.enc")  # search if sudo password is saved
        if dir is True:
            set_brightness(100)
            found = matchFace(CRYPT_DIR + "/capture")
            set_brightness(init_bright_percent)
            if found:
                sudo_password = readPass("config.ge.enc")  # decrypt and fetch password
            else:
                print("No match!!")
                quit()
        else:
            sudo_password = getPass("config.ge")  # get password and encrypt password
            name = str(input("Name:"))
            os.mkdir(CRYPT_DIR + "/capture")
            set_brightness(100)
            capture(CRYPT_DIR + "/capture/" + name)
            set_brightness(init_bright_percent)

    except Exception as e:
        print(str(e))
        quit()

    command = ' '.join(sys.argv[1:])

    for line in run_command(command, sudo_password):
        print(line, end=" ")


if __name__ == '__main__':
    main()
