"""Generates hash value of all files in a given directory (including all subdirectories) 
"""

import argparse
import os
import hashlib
from glob import glob

def hash_bytestr_iter(bytesiter, hasher, ashexstr=False):
    for block in bytesiter:
        hasher.update(block)
    return hasher.hexdigest() if ashexstr else hasher.digest()

def file_as_blockiter(afile, blocksize=65536):
    with afile:
        block = afile.read(blocksize)
        while len(block) > 0:
            yield block
            block = afile.read(blocksize)

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('dir_path', help="path to directory")
    return parser.parse_args()

args = parse_args()

path_files = args.dir_path+"/**/*"
temp_file = os.path.join(os.getcwd(), "temp.txt")

file_hashes = open(temp_file, "w")
for filename in glob(path_files, recursive=True):   
    if os.path.isfile(filename):     
        hash_val = hash_bytestr_iter(file_as_blockiter(open(filename, 'rb')), hashlib.sha256(), True)
        file_hashes.write(hash_val)
file_hashes.close()

hash_val_all = hash_bytestr_iter(file_as_blockiter(open(temp_file, 'rb')), hashlib.sha256(), True)
print("hash value of all files in '{}' (and all subdirectories): \n{}".format(args.dir_path, hash_val_all))

os.remove(temp_file)

