#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import argparse
import datetime
import urllib
import logging
import shutil
from distutils.dir_util import copy_tree
import subprocess
import glob
import ConfigParser
import sys, os
import stat
import pwd
import socket
import patchFiles
from os.path import expanduser

EXIT_SUCCESS = 0
EXIT_FAILURE = 1

# Set correct FW_TYPE and BOARD_TYPE for each project!
FW_TYPE = 'ugt'
BOARD_TYPE = 'mp7'

BoardAliases = {
    'mp7_690es': 'r1',
    'mp7xe_690': 'xe',
}

## HB 2018-02-22: changed default fwdir because of changes in patchFiles.py
#DEFAULT_FW_DIR = expanduser("~/work/fwdir")
DEFAULT_FW_DIR = expanduser("~/work/fwdir_2018")

def remove_file(filename):
    """Savely remove a file or a symbolic link."""
    if os.path.isfile(filename) or os.path.islink(filename):
        os.remove(filename)

def clear_file(filename):
    """Re-Create empty file."""
    open(filename, 'w').close()

def read_file(filename):
    """Returns contents of a file."""
    with open(filename, 'rb') as fp:
        return fp.read()

def make_executable(filename):
    """Set executable flag for file."""
    st = os.stat(filename)
    os.chmod(filename, st.st_mode | stat.S_IEXEC)

def template_replace(template, replace_map, result):
    """Load template by replacing keys from dictionary and writing to result
    file. The function ignores VHDL escaped lines.

    Example:
    >>> template_replace('sample.tpl.vhd', {'name': "title"}, 'sample.vhd')

    """
    # Read content of source file.
    with open(template, 'rb') as fp:
        lines = fp.readlines()
    # Replace placeholders.
    for key, value in replace_map.items():
        for i, line in enumerate(lines):
            if not line.strip().startswith('--'):
                lines[i] = line.replace(key, value)
    # Write content to destination file.
    with open(result, 'wb') as fp:
        fp.write(''.join(lines))

def count_modules(menu):
    """Returns count of modules of menu. *menu* is the path to the menu directory."""
    pattern = os.path.join(menu, 'vhdl', 'module_*')
    return len(glob.glob(pattern))

def get_timestamp():
    return datetime.datetime.now().strftime("%Y-%m-%d-T%H-%M-%S")

def hostname():
    """@returns UNIX machine hostname."""
    return socket.gethostname()

def username():
    """@returns UNIX login name."""
    login = 0
    return pwd.getpwuid(os.getuid())[login]

# Some other paths.
scripts_dir = os.getcwd()
uGTalgosPath = os.path.abspath(os.path.join(scripts_dir, '..'))

# Target VHDL package and it's template must be defined.
TARGET_PKG_TPL = os.path.join(uGTalgosPath, 'firmware', 'hdl', 'gt_mp7_top_pkg_tpl.vhd')
TARGET_PKG = os.path.join(uGTalgosPath, 'firmware', 'hdl', 'gt_mp7_top_pkg.vhd')

def build_t(value):
    """Custom build type validator for argparse."""
    try: return "{0:04x}".format(int(value, 16))
    except ValueError: raise TypeError("Invalid build version: `{0}'".format(value))

def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('-t', '--tag', metavar = '<tag>', required = True, help = "mp7fw tag")
    parser.add_argument('--unstable', action = 'store_true', help = "use unstable tag (default is stable)")
    parser.add_argument('-o', '--old', action = 'store_true', help = "use the old ProjectManager.py commands")
    parser.add_argument('--board', metavar = '<type>', default = 'mp7xe_690', choices = BoardAliases.keys(), help = "set board type (default is `mp7xe_690')")
    parser.add_argument('-u', '--user', metavar = '<username>', required = True, help = "username for SVN")
    parser.add_argument('-p', '--path', metavar = '<path>', default = DEFAULT_FW_DIR, type = os.path.abspath, help = "fw build path")
    parser.add_argument('-m', '--menu', metavar = '<menu>', required = True, type = os.path.abspath, help = "path to L1Menu_ directory")
    parser.add_argument('-b', '--build', metavar = '<version>', required = True, type = build_t, help = 'menu build version (eg. 0x1001)')
    return parser.parse_args()

def main():
    """Main routine."""

    # Parse command line arguments.
    args = parse_args()

    # Setup console logging
    logging.basicConfig(format = '%(levelname)s: %(message)s', level = logging.DEBUG)

    # Feth current timestamp.
    timestamp = get_timestamp()


    fw_build_dir = os.path.join(args.path, "{}_{}".format(BOARD_TYPE, FW_TYPE))

    # Fetch menu name from path.
    menu_name = os.path.basename(args.menu)

    if not menu_name.startswith('L1Menu_'):
        raise RuntimeError("Menu contains no modules")

    # Fetch number of menu modules.
    modules = count_modules(args.menu)

    if not modules:
        raise RuntimeError("Menu contains no modules")

    logging.info("Creating uGT build area...")
    logging.info("tag: %s (%s)", args.tag, "unstable" if args.unstable else "stable")
    logging.info("user: %s", args.user)
    logging.info("path: %s", fw_build_dir)
    logging.info("menu file: %s", args.menu)
    logging.info("menu name: %s", menu_name)
    logging.info("menu modules: %s", modules)
    logging.info("build: 0x%s", args.build)
    logging.info("board type: %s", args.board)

    if not os.path.isdir(args.menu):
        raise RuntimeError("menu directory does not exist: {args.menu}".format(**locals()))

    mp7path = os.path.join(fw_build_dir, args.tag)

    #
    # Create build area
    #

    if not os.path.isdir(mp7path):

        logging.info("creating directory %s", mp7path)
        os.makedirs(mp7path)

        # Check out mp7fw
        cwd = os.getcwd()
        os.chdir(mp7path)

        logging.info("downloading project manager...")
        filename = "ProjectManager.py"
        # Remove existing file.
        remove_file(filename)
        # Download file
        release_mode = 'unstable' if args.unstable else 'stable'
        url = "https://svnweb.cern.ch/trac/cactus/browser/tags/mp7/{release_mode}/firmware/{args.tag}/cactusupgrades/scripts/firmware/ProjectManager.py?format=txt".format(**locals())
        logging.info("retrieving %s", url)
        urllib.urlretrieve(url, filename)
        make_executable(filename)

        logging.info("checkout MP7 base firmware...")
        path = os.path.join('tags', 'mp7', 'unstable' if args.unstable else 'stable', 'firmware', args.tag)
        if args.old:
            subprocess.check_call(['python', 'ProjectManager.py', 'checkout', path, '-u', args.user])
        else:
            subprocess.check_call(['python', 'ProjectManager.py', 'create', path, '-u', args.user]) #changes in ProjectManager.py, have to differ between older and newer versions

        os.chdir(fw_build_dir)

        logging.info("creating link to current tag: mp7fw_current -> %s", mp7path)
        mp7currDir = 'mp7fw_current'
        remove_file(mp7currDir)
        os.symlink(mp7path, mp7currDir)
        mp7currPath = os.path.join(fw_build_dir, mp7currDir)

        patchFiles.patch_all(os.path.join(mp7path,'cactusupgrades'))

        os.chdir(mp7currPath)

    else:

        # included in the else, to preserve the path structure
        os.chdir(fw_build_dir)
        ######################################################

        logging.info("creating link to current tag: mp7fw_current -> %s", mp7path)
        mp7currDir = 'mp7fw_current'
        remove_file(mp7currDir)
        os.symlink(mp7path, mp7currDir)
        mp7currPath = os.path.join(fw_build_dir, mp7currDir)

        os.chdir(mp7currPath)

        ######################################################

    cwd = os.getcwd()
    os.chdir(mp7path)

    #
    #  Patching top VHDL
    #
    logging.info("patch the target package with current UNIX timestamp/username/hostname...")
    subprocess.check_call(['python', os.path.join(scripts_dir, 'pkgpatch.py'), '--build', args.build ,TARGET_PKG_TPL, TARGET_PKG])

    #
    #  Creating build areas
    #
    logging.info("creating build areas...")
    build_area_dir = ''.join(('build_0x', args.build))

    if os.path.isdir(build_area_dir):
        raise RuntimeError("build area alredy exists: {build_area_dir}".format(**locals()))

    # Create build directory for fw synthesis...
    project_dir = os.path.abspath(os.path.join(build_area_dir, menu_name))
    os.makedirs(project_dir)

    # Do for every module of the menu...
    for i in range(modules):
        module_dir = os.path.join(build_area_dir, menu_name, 'module_{i}'.format(**locals()))
        local_fw_dir = os.path.abspath(os.path.join(module_dir, 'mp7_ugt'))

        # Creat module build area
        os.makedirs(local_fw_dir)

        # Copy sources to module build area
        copy_tree(os.path.join(uGTalgosPath, 'firmware', 'cfg'), os.path.join(local_fw_dir, 'firmware', 'cfg'))
        copy_tree(os.path.join(uGTalgosPath, 'firmware', 'hdl'), os.path.join(local_fw_dir, 'firmware', 'hdl'))
        copy_tree(os.path.join(uGTalgosPath, 'firmware', 'ngc'), os.path.join(local_fw_dir, 'firmware', 'ngc'))
        copy_tree(os.path.join(uGTalgosPath, 'firmware', 'ucf'), os.path.join(local_fw_dir, 'firmware', 'ucf'))

        # Read generated VHDL snippets
        src_dir = os.path.join(args.menu, 'vhdl', 'module_{i}'.format(**locals()), 'src')

        replace_map = {
            '{{algo_index}}': read_file(os.path.join(src_dir, 'algo_index.vhd')),
            '{{ugt_constants}}': read_file(os.path.join(src_dir, 'ugt_constants.vhd')),
            '{{gtl_module_signals}}': read_file(os.path.join(src_dir, 'gtl_module_signals.vhd')),
            '{{gtl_module_instances}}': read_file(os.path.join(src_dir, 'gtl_module_instances.vhd')),
        }

        gtl_fdl_wrapper_dir = os.path.join(local_fw_dir, 'firmware', 'hdl', 'gt_mp7_core', 'gtl_fdl_wrapper')
        gtl_dir = os.path.join(gtl_fdl_wrapper_dir, 'gtl')
        fdl_dir = os.path.join(gtl_fdl_wrapper_dir, 'fdl')

        # Patch VHDL files
        template_replace(os.path.join(fdl_dir, 'algo_mapping_rop_tpl.vhd'), replace_map, os.path.join(fdl_dir, 'algo_mapping_rop.vhd'))
        template_replace(os.path.join(gtl_dir, 'gtl_pkg_tpl.vhd'), replace_map, os.path.join(gtl_dir, 'gtl_pkg.vhd'))
        template_replace(os.path.join(gtl_dir, 'gtl_module_tpl.vhd'), replace_map, os.path.join(gtl_dir, 'gtl_module.vhd'))

        # Run project manager
        subprocess.check_call(['python', 'ProjectManager.py', 'vivado', local_fw_dir, '-w', module_dir])
    os.chdir(cwd)

    # Go to build area root directory.
    os.chdir(mp7path)
    os.chdir(build_area_dir)

    # Creating configuration file.
    config = ConfigParser.RawConfigParser()
    config.add_section('environment')
    config.set('environment', 'timestamp', timestamp)
    config.set('environment', 'hostname', hostname())
    config.set('environment', 'username', username())

    config.add_section('menu')
    config.set('menu', 'build', args.build)
    config.set('menu', 'name', menu_name)
    config.set('menu', 'location', args.menu)
    config.set('menu', 'modules', modules)

    config.add_section('firmware')
    config.set('firmware', 'tag', args.tag)
    config.set('firmware', 'stable', str(not args.unstable))
    config.set('firmware', 'type', FW_TYPE)
    config.set('firmware', 'buildarea', os.path.join(mp7path, build_area_dir, menu_name))

    config.add_section('device')
    config.set('device', 'type', args.board)
    config.set('device', 'name', BOARD_TYPE)
    config.set('device', 'alias', BoardAliases[args.board])

    # Writing our configuration file to 'example.cfg'
    with open('.'.join((build_area_dir, 'cfg')), 'wb') as configfile:
        config.write(configfile)

    logging.info("finished with success.")

if __name__ == '__main__':
    try:
        main()
    except RuntimeError, message:
        logging.error(message)
        sys.exit(EXIT_FAILURE)
    sys.exit(EXIT_SUCCESS)
