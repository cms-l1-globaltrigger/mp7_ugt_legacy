#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import argparse
import configparser
import logging
import os
import shutil
import sys
import tempfile
import tarfile

import toolbox as tb

EXIT_SUCCESS = 0
EXIT_FAILURE = 1

def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('config', help="build configuration file to read")
    parser.add_argument('--outdir', metavar="<path>", type=os.path.abspath, help="set location to write tarball")
    return parser.parse_args()

def main():
    """Main routine."""

    # Parse command line arguments.
    args = parse_args()

    # Setup console logging
    logging.basicConfig(format = '%(levelname)s: %(message)s', level = logging.DEBUG)

    # with tarfile

    config = configparser.RawConfigParser()
    config.read(args.config)

    for section in config.sections():
        print(section)
        for option in config.options(section):
            print(" ", option, "=", config.get(section, option))

    menu = config.get('menu', 'name')
    location = config.get('menu', 'location')
    build = tb.build_t(config.get('menu', 'build')) # format 'ffff'
    board = config.get('device', 'alias')
    buildarea = config.get('firmware', 'buildarea')
    menu_modules = int(config.get('menu', 'modules'))
    timestamp = tb.timestamp()

    # Definitions for name of IPBB 'proj' directory
    fw_type = config.get('firmware', 'type')
    device_name = config.get('device', 'name')

    basename = "{menu}_v{build}_{board}".format(**locals())
    basepath = os.path.dirname(args.config)

    # Custom output directory?
    if args.outdir:
        basepath = args.outdir
    filename = os.path.join(basepath, "{basename}-{timestamp}.tar.gz".format(**locals()))

    tmpdir = tempfile.mkdtemp()
    logging.info("Created temporary dircetory %s", tmpdir)

    # Check modules
    for i in range(menu_modules):
    #for i in range(len(glob.glob(os.path.join(buildarea, 'module_*')))):
        logging.info("collecting data from module %s", i)
        module_dir = 'module_{i}'.format(**locals())

        #proj_dir = 'proj/{}_{}_0x{}_{}'.format(device_name, fw_type, build, i)
        proj_dir = 'proj/{}'.format(module_dir)
        build_dir = os.path.join(tmpdir, module_dir, 'build')
        log_dir = os.path.join(tmpdir, module_dir, 'log')

        # for IPBB v0.5.2 directory structure
        proj_runs = '{0}/{0}.runs'.format(module_dir)
        #bit_file = '{}.bit'.format(module_dir)
        bit_file = 'top.bit'

        os.makedirs(build_dir)
        os.makedirs(log_dir)
        shutil.copy(os.path.join(buildarea, proj_dir, proj_runs, 'impl_1', bit_file),
            os.path.join(build_dir, 'gt_mp7_{board}_v{build}_module_{i}.bit'.format(**locals())))
        shutil.copy(os.path.join(buildarea, proj_dir, proj_runs, 'synth_1', 'runme.log'),
            os.path.join(log_dir, 'runme_synth_1.log'))
        shutil.copy(os.path.join(buildarea, proj_dir, proj_runs, 'impl_1', 'runme.log'),
            os.path.join(log_dir, 'runme_impl_1.log'))

    logging.info("adding build configuration: %s", args.config)
    shutil.copy(args.config, tmpdir)

    xml_file = os.path.join(buildarea, 'src', '{menu}.xml'.format(**locals()))
    logging.info("adding XML menu: %s", xml_file)
    shutil.copy(xml_file, tmpdir)

    logging.info("creating tarball: %s", filename)
    with tarfile.open(filename, "w:gz") as tar:
        logging.info("adding to tarball: %s", tmpdir)
        tar.add(tmpdir, arcname=basename, recursive=True)
    logging.info("closed tarball: %s", filename)

    logging.info("removing temporary directory %s.", tmpdir)
    shutil.rmtree(tmpdir)

    logging.info("done.")

if __name__ == '__main__':
    try:
        main()
    except RuntimeError as message:
        logging.error(message)
        sys.exit(EXIT_FAILURE)
    sys.exit(EXIT_SUCCESS)
