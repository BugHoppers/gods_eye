#!/usr/bin/python3

import os
import os.path
import getpass
from Crypto import Random
from Crypto.Cipher import AES


class Encryptor:
    def __init__(self, key):
        self.key = key

    def pad(self, s):
        return s + b"\0" * (AES.block_size - len(s) % AES.block_size)

    def encrypt(self, message, key, key_size=256):
        message = self.pad(message)
        iv = Random.new().read(AES.block_size)
        cipher = AES.new(key, AES.MODE_CBC, iv)
        return iv + cipher.encrypt(message)

    def encrypt_file(self, file_name):
        with open(file_name, 'rb') as fo:
            plaintext = fo.read()
        enc = self.encrypt(plaintext, self.key)
        with open(file_name + ".enc", 'wb') as fo:
            fo.write(enc)
        os.remove(file_name)

    def decrypt(self, ciphertext, key):
        iv = ciphertext[:AES.block_size]
        cipher = AES.new(key, AES.MODE_CBC, iv)
        plaintext = cipher.decrypt(ciphertext[AES.block_size:])
        return plaintext.rstrip(b"\0")

    def decrypt_file(self, file_name):
        with open(file_name, 'rb') as fo:
            ciphertext = fo.read()
        dec = self.decrypt(ciphertext, self.key)
        with open(file_name[:-4], 'wb') as fo:
            fo.write(dec)
        os.remove(file_name)


key = b'[EX\xc8\xd5\xbfI{\xa2$\x05(\xd5\x18\xbf\xc0\x85)\x10nc\x94\x02)j\xdf\xcb\xc4\x94\x9d(\x9e'
enc = Encryptor(key)


def clear(): return os.system('clear')


def readPass(file):
    enc.decrypt_file(file)
    p = ''
    file = file[:-4]
    with open(file, "r") as f:
        p = f.readlines()
    decryptedPassword = p[0]
    enc.encrypt_file(file)
    return decryptedPassword

def getPass(file):
    clear()
    password = str(getpass.getpass("Setting up God's Eye. Enter your sudo password: "))
    f = open("./" + file, "w+")
    f.write(password)
    f.close()
    enc.encrypt_file(file)
    print("Password encrypted.")
    return password
