#!/usr/bin/python3

import os
import os.path
import getpass
import pickle
from pathlib import Path
from os.path import isfile
from Crypto import Random
from Crypto.Cipher import AES

CRYPT_DIR = str(Path.home()) + "/.god"

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

def key():
    if os.path.isfile(CRYPT_DIR + "/" + "key"):
        with open(CRYPT_DIR + "/" + 'key', 'rb') as r:
            key = pickle.load(r)
    else:
        key = Random.get_random_bytes(32)
        with open(CRYPT_DIR + "/" + 'key', 'wb') as w:
            pickle.dump(key, w)
    return key

def readPass(file):
    enc = Encryptor(key())
    enc.decrypt_file(CRYPT_DIR + "/" + file)
    p = ''
    file = file[:-4]
    with open(CRYPT_DIR + "/" + file, "r") as f:
        p = f.readlines()
    decryptedPassword = p[0]
    enc.encrypt_file(CRYPT_DIR + "/" + file)
    return decryptedPassword

def getPass(file):
    os.system('clear')
    password = str(getpass.getpass("Setting up God's Eye. Enter your sudo password: "))
    os.mkdir(CRYPT_DIR)
    f = open(CRYPT_DIR + "/" + file, "w+")
    f.write(password)
    f.close()
    enc = Encryptor(key())
    enc.encrypt_file(CRYPT_DIR + "/" + file)    
    print("Password encrypted.")
    return password
