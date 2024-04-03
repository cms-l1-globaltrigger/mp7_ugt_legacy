"""Update IPbus VHDL creation timestamp, username and hostname (defined by
placeholder).

How to patch with current execution timestamp:

  $ pkgpatch src/sample_pkg.vhd src/sample_pkg_syn.vhd

How to use a given timestamp (eg. in makefiles):

  $ TIMESTAMP=`date +%s`
  $ pkgpatch src/sample_pkg.vhd src/sample_pkg_syn.vhd -t $TIMESTAMP

How to overwrite username and hostname (foo@bar):

  $ pkgpatch src/sample_pkg.vhd src/sample_pkg_syn.vhd --username foo --hostname bar

Supported replacement parameters:

  {{IPBUS_TIMESTAMP}}        32 bit UNIX timestamp placeholder (X"00000000")
  {{IPBUS_USERNAME}}         unix username 32 char string placeholder (X"...")
  {{IPBUS_HOSTNAME}}         machine hostname 32 char string placeholder (X"...")
  {{IPBUS_BUILD_VERSION}}    32 bit build version

"""

import argparse
import os
import sys
import time
import glob
import hashlib

from getpass import getuser  # for username
from socket import gethostname  # for machines hostname

# Set application name (script file name).
name = os.path.basename(__file__)


def build_t(value):
    """Custom build type validator for argparse."""
    try:
        return int(value, 16)
    except ValueError:
        raise TypeError("Invalid build version: `{0}'".format(value))


def unix_timestamp():
    """Returns current UNIX timestamp (integer)."""
    return int(time.time())


def hex_value(value, width=8):
    """Returns hex-value representation. width is the minimal with in characters.
    """
    return 'X"{0:0{1}x}"'.format(value, width)


def hex_timestamp(timestamp=None):
    """Returns hex-string representation of current UNIX timestamp.
    If no timestamp is give, the current time is used.
    """
    if not timestamp:
        timestamp = unix_timestamp()
    return hex_value(timestamp, width=8)


def hex_string(s, n=32):
    """Returns hex-string representationgiven string, cut down to *n* bytes length."""
    # take first n characters, reverse them and get ascii codes with ord()
    return 'X"{0:>0{1}}"'.format(''.join(['{0:x}'.format(ord(c)) for c in s[:n][::-1]]), n * 2)


def calc_fw_hash(path: str) -> str:
    """Calculate a SHA-256 hash value of the content of all source files at given path."""
    filenames = []
    # Collect all python modules and VHDL templates
    #for pattern in ["**/*.vhd", "**/*.dep", "**/*.xci", "**/*.mif", "**/*.tcl"]:
    for pattern in ["**/*.vhd"]:
        for filename in glob.glob(os.path.join(path, pattern), recursive=True):
            fname = filename.split("/")[-1]
            if fname != "gt_mp7_top_pkg.vhd":
                filenames.append(filename)

    hash_sha256 = hashlib.sha256()
    # Sort filenames for deterministic hash
    for filename in sorted(filenames):
        print(filename)
        with open(filename, "rb") as f:
            while True:
                # Reading is buffered, so we can read smaller chunks.
                chunk = f.read(hash_sha256.block_size)
                if not chunk:
                    break
                hash_sha256.update(chunk)
    return hash_sha256.hexdigest()


def parse_args():
    parser = argparse.ArgumentParser(
        prog=name,
        usage="{0} [options] <src> <dest>".format(name),
        description="Patch IPbus VHDL package with creation timestamp, username and hostname.",
        epilog="Report bugs to <bernhard.arnold@cern.ch>.",
        add_help=True
    )
    parser.add_argument('src', metavar='<src>', type=str, help='source template VHDL file eg. <target>_pkg_tpl.vhd')
    parser.add_argument('dest', metavar='<dest>', type=str, help='destination VHDL synthesis file eg. <target>_pkg.vhd')
    parser.add_argument('-t', '--timestamp', action="store", dest='timestamp', default=unix_timestamp(), type=int, help="UNIX timestamp (integer)")
    parser.add_argument('--username', action="store", dest='username', default=getuser(), type=str, help="overwrite machine username")
    parser.add_argument('--hostname', action="store", dest='hostname', default=gethostname(), type=str, help="overwrite machine hostname")
    parser.add_argument('-b', '--build', action="store", dest='build', required=True, type=build_t, help="set the menu build version")
    return parser.parse_args(sys.argv[1:])


def main():
    args = parse_args()

    if os.path.abspath(args.src) == os.path.abspath(args.dest):
        print("for safety reasons it is not allowed to overwrite the source template.")
        sys.exit(1)

    fw_dir = os.path.join(os.path.dirname(os.path.abspath(args.src)), '../..', "hdl")

    replace_map = {
        '{{IPBUS_TIMESTAMP}}': hex_timestamp(args.timestamp),
        '{{IPBUS_USERNAME}}': hex_string(args.username),
        '{{IPBUS_HOSTNAME}}': hex_string(args.hostname),
        '{{IPBUS_BUILD_VERSION}}': hex_value(args.build),
        '{{FW_HASH}}': calc_fw_hash(fw_dir),
    }

    # Read content of source file.
    with open(args.src) as src:
        lines = src.readlines()

    # Replace placeholders.
    for key, value in list(replace_map.items()):
        for i, line in enumerate(lines):
            if not line.strip().startswith('--'):
                lines[i] = line.replace(key, value)

    # Write content to destination file.
    with open(args.dest, 'w') as dest:
        dest.write(''.join(lines))


if __name__ == '__main__':
    main()
