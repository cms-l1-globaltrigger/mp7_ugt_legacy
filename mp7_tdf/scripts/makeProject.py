#!/usr/bin/env python2
# -*- coding: utf-8 -*-

# modified for TDF usage - JW 25.05.2015

import argparse
import urllib
import logging
import shutil
import subprocess
import glob
import sys, stat, os

EXIT_SUCCESS = 0
EXIT_FAILURE = 1

def remove_file(filename):
    """Savely remove a file or a symbolic link."""
    if os.path.isfile(filename) or os.path.islink(filename):
        os.remove(filename)

def clear_file(filename):
    """Re-Create empty file."""
    open(filename, 'w').close()

# Some other paths.
scripts_dir = os.getcwd()
TDFalgosPath = os.path.abspath(os.path.join(scripts_dir, '..'))

# Target VHDL package and it's template must be defined.
TARGET_PKG_TPL = os.path.join(TDFalgosPath, 'tdf_algos/firmware/hdl/tdf_mp7_top_pkg_tpl.vhd')
TARGET_PKG = os.path.join(TDFalgosPath, 'tdf_algos/firmware/hdl/tdf_mp7_top_pkg.vhd')

def build_t(value):
    """Custom build type validator for argparse."""
    try: return "{0:04x}".format(int(value, 16))
    except ValueError: raise TypeError("Invalid build version: `{0}'".format(value))

def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('-t', '--tag', metavar = '<tag>', required = True, help = "mp7fw tag")
    parser.add_argument('--unstable', action = 'store_true', help = "use unstable tag (default is stable)")
    parser.add_argument('--board', metavar = '<type>', default = 'mp7xe_690', help = "set board type (default is `mp7xe_690')")
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

    logging.info("Creating TDF build area...")
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
        url = "https://svnweb.cern.ch/trac/cactus/browser/trunk/cactusupgrades/scripts/firmware/ProjectManager.py?format=txt"
        logging.info("retrieving %s", url)
        urllib.urlretrieve(url, filename)
        # Make executable
        st = os.stat(filename)
        os.chmod(filename, st.st_mode | stat.S_IEXEC)


        logging.info("checkout MP7 base firmware...")
        path = os.path.join('tags', 'mp7', 'unstable' if args.unstable else '', 'firmware', args.tag)
        subprocess.check_call(['python', 'ProjectManager.py', 'checkout', path, '-u', args.user])

        #logging.info("fetching project firmware...")
        #subprocess.check_call(['python', 'ProjectManager.py', 'fetch', os.path.join('projects/examples', args.board)])

        os.chdir(args.path)

        logging.info("creating link to current tag: mp7fw_current -> %s", mp7path)
        mp7currDir = 'mp7fw_current'
        remove_file(mp7currDir)
        os.symlink(mp7path, mp7currDir)
        mp7currPath = os.path.join(args.path, mp7currDir)

        os.chdir(mp7currPath)

        # FOR FUTURE USE: copy original null_algo.dep to a tmp, create new null_algo.dep with current link to algo block (ugt/tdf), so every time, a clean null_algo.dep is generated

        logging.info("adding dependency file for the TDF to the null algo dep file...")
        cwd = os.getcwd()
        os.chdir('cactusupgrades/components/mp7_null_algo/firmware/cfg/')
        shutil.copy('mp7_null_algo.dep', 'mp7_null_algo.dep.orig')
        # Prepend a line to mp7_null_algo.dep
        with open('mp7_null_algo.dep.orig', 'r') as fi:
            with open('mp7_null_algo.dep.tmp', 'w') as fo:
                fo.write("include -c components/tdf_algos tdf_algo.dep\n")
                fo.write(fi.read())
        shutil.move('mp7_null_algo.dep.tmp', 'mp7_null_algo.dep')

        os.chdir(cwd)

    else:

        # included in the else, to preserve the path structure
        os.chdir(args.path)
        ######################################################

        logging.info("creating link to current tag: mp7fw_current -> %s", mp7path)
        mp7currDir = 'mp7fw_current'
        remove_file(mp7currDir)
        os.symlink(mp7path, mp7currDir)
        mp7currPath = os.path.join(args.path, mp7currDir)

        os.chdir(mp7currPath)

        logging.info("adding dependency file for the TDF to the null algo dep file...")
        cwd = os.getcwd()
        os.chdir('cactusupgrades/components/mp7_null_algo/firmware/cfg/')
        # Prepend a line to mp7_null_algo.dep
        with open('mp7_null_algo.dep.orig', 'r') as fi:
            with open('mp7_null_algo.dep.tmp', 'w') as fo:
                fo.write("include -c components/tdf_algos tdf_algo.dep\n")
                fo.write(fi.read())
        shutil.move('mp7_null_algo.dep.tmp', 'mp7_null_algo.dep')

        os.chdir(cwd)

        ######################################################


    cwd = os.getcwd()
    os.chdir(mp7path)

    #
    #  Fetching projects from cactus
    #
    #print os.path.join("cactusupgrades/projects/examples", args.board)
    #sys.exit()
    if not os.path.isdir(os.path.join("cactusupgrades/projects/examples", args.board)):
        logging.info("fetching project firmware...")
        subprocess.check_call(['python', 'ProjectManager.py', 'fetch', os.path.join('projects/examples', args.board)])


    #
    #  Creating build areas
    #

    logging.info("creating working areas...")

    build_area_dir = ''.join(('build_0x', args.build))

    if os.path.isdir(build_area_dir):
        raise RuntimeError("build area alredy exists: {build_area_dir}".format(**locals()))

    subprocess.check_call(['python', 'ProjectManager.py', 'vivado', os.path.join('projects/examples', args.board), '-w', build_area_dir])

    os.chdir(cwd)

    #
    #  Patching VHDL
    #

    logging.info("patch the target package with current UNIX timestamp/username/hostname...")
    subprocess.check_call(['python', os.path.join(scripts_dir, 'pkgpatch.py'), '--build', args.build ,TARGET_PKG_TPL, TARGET_PKG])


    filename = os.path.join(TDFalgosPath, 'tdf_algos/firmware/cfg/tdf_board.dep')
    with open(filename, 'w') as f:
        f.write("src -c projects/examples/{args.board} top_decl.vhd\n".format(**locals()))
        f.write("src -c boards/mp7/base_fw/{args.board} mp7_brd_decl.vhd\n".format(**locals()))
        f.write("src {args.board}.vhd\n".format(**locals()))
        f.write("src mp7_ttc.vhd\n".format(**locals()))

    logging.info("linking tdf_algos into cactusupgrades/components...")
    cwd = os.getcwd()
    os.chdir('cactusupgrades/components/')
    remove_file("tdf_algos")
    os.symlink(os.path.join(TDFalgosPath, 'tdf_algos'), "tdf_algos")

    os.chdir(cwd)

    logging.info("removing constraints for null algo...")
    filename = 'cactusupgrades/components/mp7_null_algo/firmware/ucf/mp7_null_algo.tcl'
    # Clear and touch
    clear_file(filename)

    # Do for every module of the menu...
    #for i in range(modules):
        #logging.info("setting up build area for %s of %s...", i, menu_name)
        #module_dir = os.path.join(build_area_dir, menu_name, 'module_{i}'.format(**locals()))
        #os.chdir(module_dir)
        #remove_file("runAll.sh")
        #os.symlink(os.path.join(TDFalgosPath, 'runAll.sh'),  'runAll.sh')

    logging.info("replacing the original top file with the modified TDF one...")
    shutil.copyfile(
        os.path.join(TDFalgosPath, 'tdf_algos/firmware/hdl/{args.board}.vhd'.format(**locals())),
        os.path.join(mp7currPath, 'cactusupgrades/boards/mp7/base_fw/{args.board}/firmware/hdl/{args.board}.vhd'.format(**locals()))
    )

    logging.info("finished with success.")

if __name__ == '__main__':
    try:
        main()
    except RuntimeError, message:
        logging.error(message)
        sys.exit(EXIT_FAILURE)
    sys.exit(EXIT_SUCCESS)
