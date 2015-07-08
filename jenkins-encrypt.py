#!/usr/bin/env python

# Kudos to https://github.com/tweksteen/jenkins-decrypt

import re
import sys
import base64
from hashlib import sha256
from binascii import hexlify, unhexlify
from Crypto.Cipher import AES

MAGIC = "::::MAGIC::::"
MASTER_KEY="/var/jenkins_home/secrets/master.key"
SECRET="/var/jenkins_home/secrets/hudson.util.Secret"
BS = 16

pad = lambda s: s + (BS - len(s) % BS) * chr(BS - len(s) % BS)
unpad = lambda s : s[:-ord(s[len(s)-1:])]

def main():
  password=''
  if len(sys.argv) == 2:
    password = pad(sys.argv[1]+MAGIC)
  else:
    password = pad(MAGIC)

  master_key = open(MASTER_KEY).read()
  hudson_secret_key = open(SECRET).read()

  hashed_master_key = sha256(master_key).digest()[:16]
  o = AES.new(hashed_master_key, AES.MODE_ECB)
  x = o.decrypt(hudson_secret_key)
  assert MAGIC in x

  k = x[:-16]
  k = k[:16]
  o = AES.new(k, AES.MODE_ECB)
  x =  base64.b64encode(o.encrypt(password))
  print x


if __name__ == '__main__':
  main()