#!/usr/bin/env python2
# -*- coding: utf-8 -*-

from makeProject import BoardAliases
import toolbox as tb

import tarfile
import argparse
import logging
import shutil
import glob
import tempfile
import ConfigParser
import sys, os

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

    config = ConfigParser.RawConfigParser()
    config.read(args.config)

    for section in config.sections():
        print section
        for option in config.options(section):
            print " ", option, "=", config.get(section, option)

    menu = config.get('menu', 'name')
    location = config.get('menu', 'location')
    build = tb.build_t(config.get('menu', 'build')) # format 'ffff'
    board = config.get('device', 'alias')
    buildarea = config.get('firmware', 'buildarea')
    timestamp = tb.timestamp()

    basename = "{menu}_v{build}_{board}".format(**locals())
    basepath = os.path.dirname(args.config)

    # Custom output directory?
    if args.outdir:
        basepath = args.outdir
    filename = os.path.join(basepath, "{basename}-{timestamp}.tar.gz".format(**locals()))

    tmpdir = tempfile.mkdtemp()
    logging.info("Created temporary dircetory %s", tmpdir)

    for i in range(len(glob.glob(os.path.join(buildarea, 'module_*')))):
        logging.info("collecting data from module %s", i)
        module_dir = 'module_{i}'.format(**locals())
        build_dir = os.path.join(tmpdir, module_dir, 'build')
        log_dir = os.path.join(tmpdir, module_dir, 'log')
        os.makedirs(build_dir)
        os.makedirs(log_dir)
        shutil.copy(os.path.join(buildarea, module_dir, 'top', 'top.runs', 'impl_1', 'top.bit'),
            os.path.join(build_dir, 'gt_mp7_{board}_v{build}_module_{i}.bit'.format(**locals())))
        shutil.copy(os.path.join(buildarea, module_dir, 'vivado.log'), log_dir)

    logging.info("adding build configuration: %s", args.config)
    shutil.copy(args.config, tmpdir)

    xml_file = os.path.join(location, 'xml', '{menu}.xml'.format(**locals()))
    logging.info("adding XML menu: %s", xml_file)
    shutil.copy(xml_file, tmpdir)

    logging.info("creating tarball: %s", filename)
    tar = tarfile.open(filename, "w:gz")
    logging.info("adding to tarball: %s", tmpdir)
    tar.add(tmpdir, arcname=basename, recursive=True)
    logging.info("closing tarball: %s", filename)
    tar.close()

    logging.info("removing temporary directory %s.", tmpdir)
    shutil.rmtree(tmpdir)

    logging.info("done.")

if __name__ == '__main__':
    try:
        main()
    except RuntimeError, message:
        logging.error(message)
        sys.exit(EXIT_FAILURE)
    sys.exit(EXIT_SUCCESS)
