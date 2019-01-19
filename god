#!/usr/bin/env python3

import os
import sys
import glob
from encrypt import readPass, getPass, CRYPT_DIR
from pathlib import Path
from FaceRec import capture, matchFace

print("This is God's Eye !\n")

def find_brightness():
        bright_dir = glob.glob(os.path.abspath(os.sep)+'sys/class/backlight/' + '*')[0]
        max_bright_dir = open(bright_dir + "/max_brightness")
        curr_bright_dir = open(bright_dir + "/brightness")
        max_bright = int(max_bright_dir.read())
        curr_bright = int(curr_bright_dir.read())
        max_bright_dir.close()
        curr_bright_dir.close()
        temp = (curr_bright/max_bright) * 100
        return temp

def setMaxBrightness():
    os.system('gdbus call --session --dest org.gnome.SettingsDaemon.Power --object-path /org/gnome/SettingsDaemon/Power --method org.freedesktop.DBus.Properties.Set org.gnome.SettingsDaemon.Power.Screen Brightness "<int32 100>" >/dev/null')

def setBrightness(bright_percent):
    os.system('gdbus call --session --dest org.gnome.SettingsDaemon.Power --object-path /org/gnome/SettingsDaemon/Power --method org.freedesktop.DBus.Properties.Set org.gnome.SettingsDaemon.Power.Screen Brightness "<int32 %d>" >/dev/null' % (bright_percent))

def main():
    try:
        init_bright_percent = find_brightness()                             # find the current brightness
        dir = os.path.isfile(CRYPT_DIR + "/" + "config.ge.enc")             # search if sudo password is saved
        if dir is True:
            setMaxBrightness()
            found = matchFace(CRYPT_DIR + "/capture")
            setBrightness(init_bright_percent)
            if found :
                sudoPassword = readPass("config.ge.enc")                    # decrypt and fetch password
            else :
                print("No match!!")
                quit()
        else:
            sudoPassword = getPass("config.ge")                             # get password and encrypt password
            name = str(input("Name:"))
            os.mkdir(CRYPT_DIR + "/capture")
            setMaxBrightness()            
            capture(CRYPT_DIR + "/capture/" + name)
            setBrightness(init_bright_percent)
        
    except Exception as e:
        print(str(e))
        quit()

    command=' '.join(sys.argv[1:])

    os.system('echo %s | sudo -S %s' % (sudoPassword, command))               # execute the sudo command needed

if __name__ == '__main__':
    main()
