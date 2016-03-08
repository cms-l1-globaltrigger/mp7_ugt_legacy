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
import sys, stat, os
import pwd
import socket

EXIT_SUCCESS = 0
EXIT_FAILURE = 1

BoardAliases = {
    'mp7_690es': 'r1',
    'mp7xe_690': 'xe',
}

def remove_file(filename):
    """Savely remove a file or a symbolic link."""
    if os.path.isfile(filename) or os.path.islink(filename):
        os.remove(filename)

def clear_file(filename):
    """Re-Create empty file."""
    open(filename, 'w').close()

#def count_modules(menu):
    #"""Returns count of modules of menu. *menu* is the path to the menu directory."""
    #pattern = os.path.join(menu, 'vhdl', 'module_*')
    #return len(glob.glob(pattern))

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
TARGET_PKG_TPL = os.path.join(uGTalgosPath, 'firmware/hdl/gt_top_pkg_tpl.vhd')
TARGET_PKG = os.path.join(uGTalgosPath, 'firmware/hdl/gt_top_pkg.vhd')

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
    parser.add_argument('-p', '--path', metavar = '<path>', required = True, type = os.path.abspath, help = "mp7fw tag")
    parser.add_argument('-b', '--build', metavar = '<version>', required = True, type = build_t, help = 'build version (eg. 0x1001)')
    return parser.parse_args()

def main():
    """Main routine."""

    # Parse command line arguments.
    args = parse_args()

    # Setup console logging
    logging.basicConfig(format = '%(levelname)s: %(message)s', level = logging.DEBUG)

    # Feth current timestamp.
    timestamp = get_timestamp()

    logging.info("Creating ExtCond build area...")
    logging.info("tag: %s (%s)", args.tag, "unstable" if args.unstable else "stable")
    logging.info("user: %s", args.user)
    logging.info("path: %s", args.path)
    logging.info("build: 0x%s", args.build)
    logging.info("board type: %s", args.board)


    mp7path = os.path.join(args.path, args.tag)

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
        if args.old:
            release_mode = 'unstable' if args.unstable else 'stable'
            url = "https://svnweb.cern.ch/trac/cactus/browser/tags/mp7/{release_mode}/firmware/mp7fw_v1_6_0/cactusupgrades/scripts/firmware/ProjectManager.py?format=txt".format(**locals())
            logging.info("retrieving %s", url)
            urllib.urlretrieve(url, filename)
        else:
            release_mode = 'unstable' if args.unstable else 'stable'
            url = "https://svnweb.cern.ch/trac/cactus/browser/tags/mp7/{release_mode}/firmware/{args.tag}/cactusupgrades/scripts/firmware/ProjectManager.py?format=txt".format(**locals())
            logging.info("retrieving %s", url)
            urllib.urlretrieve(url, filename)

        # Make executable
        st = os.stat(filename)
        os.chmod(filename, st.st_mode | stat.S_IEXEC)


        logging.info("checkout AMC502 base firmware...")
        path = os.path.join('tags', 'mp7', 'unstable' if args.unstable else 'stable', 'firmware', args.tag)
        path_amc502 = os.path.join('trunk', 'cactusupgrades', 'boards', 'amc502')
        subprocess.check_call(['python', 'ProjectManager.py', 'create', path, '-u', args.user]) #changes in ProjectManager.py, have to differ between older and newer versions
        subprocess.check_call(['rm', '-rf', 'cactusupgrades/boards/amc502']) #maybe change to svn switch?!
        subprocess.check_call(['svn', 'co', "https://{args.user}@svn.cern.ch/reps/cactus/trunk/cactusupgrades/boards/amc502".format(**locals())])
        subprocess.check_call(['mv', 'amc502', 'cactusupgrades/boards/'])

        os.chdir(args.path)

        logging.info("creating link to current tag: mp7fw_current -> %s", mp7path)
        mp7currDir = 'mp7fw_current'
        remove_file(mp7currDir)
        os.symlink(mp7path, mp7currDir)
        mp7currPath = os.path.join(args.path, mp7currDir)

        os.chdir(mp7currPath)

    else:
        os.chdir(mp7path)

        subprocess.check_call(['rm', '-rf', 'cactusupgrades/boards/amc502']) #maybe change to svn switch?!
        subprocess.check_call(['svn', 'co', "https://{args.user}@svn.cern.ch/reps/cactus/trunk/cactusupgrades/boards/amc502".format(**locals())])
        subprocess.check_call(['mv', 'amc502', 'cactusupgrades/boards/'])

        # included in the else, to preserve the path structure
        os.chdir(args.path)
        ######################################################

        logging.info("creating link to current tag: mp7fw_current -> %s", mp7path)
        mp7currDir = 'mp7fw_current'
        remove_file(mp7currDir)
        os.symlink(mp7path, mp7currDir)
        mp7currPath = os.path.join(args.path, mp7currDir)

        os.chdir(mp7currPath)

        ######################################################


    cwd = os.getcwd()
    os.chdir(mp7path)

    #
    #  Fetching projects from cactus
    #
    #print os.path.join("cactusupgrades/projects/examples", args.board)
    #sys.exit()
    #if not os.path.isdir(os.path.join("cactusupgrades/projects/examples", args.board)):
        #logging.info("fetching project firmware...")
        #subprocess.check_call(['python', 'ProjectManager.py', 'fetch', os.path.join('projects/examples', args.board)])

    #
    #  Patching VHDL
    #
    logging.info("patch the target package with current UNIX timestamp/username/hostname...")
    subprocess.check_call(['python', os.path.join(scripts_dir, 'pkgpatch.py'), '--build', args.build ,TARGET_PKG_TPL, TARGET_PKG])

    #
    #  Creating build areas
    #
    logging.info("creating build areas...")
    build_area_dir = ''.join(('extcond_build_0x', args.build))

    if os.path.isdir(build_area_dir):
        raise RuntimeError("build area alredy exists: {build_area_dir}".format(**locals()))

    module_dir = os.path.join(build_area_dir, 'amc502_extcond')
    os.makedirs(module_dir)

    local_fw_dir = os.path.abspath(os.path.join(module_dir, 'fw'))
    os.makedirs(local_fw_dir)

    copy_tree(os.path.join(uGTalgosPath, 'firmware', 'cfg'), os.path.join(local_fw_dir, 'firmware', 'cfg'))
    copy_tree(os.path.join(uGTalgosPath, 'firmware', 'hdl'), os.path.join(local_fw_dir, 'firmware', 'hdl'))
    #copy_tree(os.path.join(uGTalgosPath, 'firmware', 'ngc'), os.path.join(local_fw_dir, 'firmware', 'ngc'))
    copy_tree(os.path.join(uGTalgosPath, 'firmware', 'ucf'), os.path.join(local_fw_dir, 'firmware', 'ucf'))
    subprocess.check_call(['python', 'ProjectManager.py', 'vivado', uGTalgosPath, '-w', module_dir])

    os.chdir(cwd)



    #filename = os.path.join(uGTalgosPath, 'firmware/cfg/uGT_board.dep')
    #with open(filename, 'w') as f:
        #f.write("src -c projects/examples/{args.board} top_decl.vhd\n".format(**locals())) # Babak changed based on Dave suggesstion
        #f.write("src top_decl_ugt_local.vhd\n".format(**locals())) # Babak changed based on Dave suggesstion
        #f.write("src -c boards/mp7/base_fw/{args.board} mp7_brd_decl.vhd\n".format(**locals()))
        #f.write("src {args.board}.vhd\n".format(**locals()))

    logging.info("linking mp7_ugt into cactusupgrades/components...")
    cwd = os.getcwd()
    os.chdir('cactusupgrades/components/')
    remove_file("mp7_ugt")
    os.symlink(uGTalgosPath, "mp7_ugt")

    os.chdir(cwd)

    #logging.info("removing constraints for null algo...")
    #filename = 'cactusupgrades/components/mp7_null_algo/firmware/ucf/mp7_null_algo.tcl'
    ## Clear and touch
    #clear_file(filename)

    # Do for every module of the menu...
    #for i in range(modules):
        #logging.info("setting up build area")
        #module_dir = os.path.join(build_area_dir, menu_name, 'module_{i}'.format(**locals()))
        #os.chdir(module_dir)
        #remove_file("runAll.sh")
        #os.symlink(os.path.join(uGTalgosPath, 'runAll.sh'),  'runAll.sh')

    #logging.info("replacing the original top file with the modified uGT one...")
    #shutil.copyfile(
        #os.path.join(uGTalgosPath, 'firmware/hdl/{args.board}.vhd'.format(**locals())),
        #os.path.join(mp7currPath, 'cactusupgrades/boards/mp7/base_fw/{args.board}/firmware/hdl/{args.board}.vhd'.format(**locals()))
    #)

    # Go to build area root directory.
    os.chdir(mp7path)
    os.chdir(build_area_dir)

    # Creating configuration file.
    config = ConfigParser.RawConfigParser()
    config.add_section('environment')
    config.set('environment', 'timestamp', timestamp)
    config.set('environment', 'hostname', hostname())
    config.set('environment', 'username', username())

    #config.add_section('menu')
    #config.set('menu', 'build', args.build)
    #config.set('menu', 'name', menu_name)
    #config.set('menu', 'location', args.menu)
    #config.set('menu', 'modules', modules)

    config.add_section('firmware')
    config.set('firmware', 'tag', args.tag)
    config.set('firmware', 'stable', str(not args.unstable))
    config.set('firmware', 'buildarea', os.path.join(mp7path, build_area_dir, 'amc502_extcond'))

    config.add_section('device')
    config.set('device', 'type', args.board)
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
