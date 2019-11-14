#!/usr/bin/env python2
# -*- coding: utf-8 -*-

"""startSynth.py -- starting module synthesis using screens
"""

import subprocess
import argparse
import logging
import ConfigParser
import sys, os, re

VIVADO_BASE_DIR = '/opt/xilinx/Vivado'
"""Default Xilinx Vivado installation location."""

EXIT_SUCCESS = 0
EXIT_FAILURE = 1

def run_command(*args):
    command = ' '.join(args)
    logging.info(">$ %s", command)
    os.system(command)

def vivado_t(version):
    """Validates Xilinx Vivado version number."""
    if not re.match(r'^\d{4}\.\d+$', version):
        raise ValueError("not a xilinx vivado version: '{version}'".format(**locals()))
    return version

def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('vivado', type=vivado_t, help="xilinx vivado version to run, eg. '2016.4'")
    parser.add_argument('config', type=os.path.abspath, help="build configuration file to read")
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

    logging.info("contents of config file '%s'", args.config)
    for section in config.sections():
        for option in config.options(section):
            logging.info(" %s.%s: %s", section, option, config.get(section, option))

    menu = config.get('menu', 'name')
    build = config.get('menu', 'build')
    modules = int(config.get('menu', 'modules'))
    buildarea = config.get('firmware', 'buildarea')

    logging.info("preparing to start synthesis for menu '%s' ...", menu)

    # settings filename
    settings64 = os.path.join(VIVADO_BASE_DIR, args.vivado, 'settings64.sh')
    if not os.path.isfile(settings64):
        raise RuntimeError(
            "no such Xilinx Vivado settings file '{settings64}'\n" \
            "  check if Xilinx Vivado {args.vivado} is installed on this machine.".format(**locals())
        )

    for i in range(modules):
        # screen session name for module
        session = "build_{build}_{i}".format(**locals())
        # module build directory inside build area
        builddir = os.path.join(buildarea, 'module_{i}'.format(**locals()))
        # command to be executed inside module screen session
        command = 'bash -c "source {settings64}; cd {builddir}; make project && make bitfile"'.format(**locals())
        # run screen command
        logging.info("starting screen session '%s' for module %s ...", session, i)
        run_command('screen', '-dmS', session, command)

    # list runnign screen sessions
    run_command('screen', '-ls')

    logging.info("done.")

if __name__ == '__main__':
    try:
        main()
    except RuntimeError as e:
        logging.error(format(e))
        sys.exit(EXIT_FAILURE)
    sys.exit(EXIT_SUCCESS)
