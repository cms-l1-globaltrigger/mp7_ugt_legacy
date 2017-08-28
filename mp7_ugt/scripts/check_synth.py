#!/usr/bin/env python
# Created by Philipp Wanggo, Jul 2017
# Extended by Bernhard Arnold, Aug 2017
#
# Validating synthesis builds.
#

import argparse
import ConfigParser
import logging
import re
import sys, os

# TTY color sequences
ColorWhiteRed = "\033[37;41;1m"
ColorYellowWhite = "\033[43;37;1m"
ColorReset = "\033[0m"

# TTY size
o, ts = os.popen('stty size', 'r').read().split()
ts = int(ts)

# Global message stack
messages = []

def log_info(message):
    messages.append(message)
    print message

def log_warning(message):
    messages.append(message)
    # Apply TTY colors
    if sys.stdout.isatty():
        message = "{}{}{}".format(ColorYellowWhite, message, ColorReset)
    print message

def log_error(message):
    messages.append(message)
    # Apply TTY colors
    if sys.stdout.isatty():
        message = "{}{}{}".format(ColorWhiteRed, message, ColorReset)
    print message

def find_errors(path, args, index):
    """gets path to a log file.""" # ???

    errors = 0
    warnings = 0
    crit_warnings = 0
    violated_counts = 0

    # opens file as .log
    with open("%s/vivado.log"  % path, "r+") as fp:
        for line in fp:
            line = line.lstrip()
            # checks in current ine if error is at the beginning
            if line.startswith("ERROR"):
                errors += 1
                # checks for args if -a or -e is an arg print error line
                if args.a or args.e:
                    log_info("-" * ts)
                    log_info(line)
                    log_info("-" * ts)
            # checks in current ine if warning is at the beginning
            elif line.startswith("WARNING"):
                warnings += 1
                # checks for args if -a or -w is an arg print warning line
                if args.a or args.w:
                    log_info("-" * ts)
                    log_info(line)
                    log_info("-" * ts)
            # checks in current ine if critical warning is at the beginning
            elif line.startswith("CRITICAL WARNING"):
                crit_warnings += 1
                # checks for args if -a or -c is an arg print critical warning line
                if args.a or args.c:
                    log_info("-" * ts)
                    log_info(line)
                    log_info("-" * ts)

    # Try to lacate timing summary, first try
    timing_summary = os.path.join(path, 'top', 'top.runs', 'impl_1', 'top_timing_summary_postroute_physopted.rpt')
    if not os.path.isfile(timing_summary):
        # else a second try
        timing_summary = os.path.join(path, 'top', 'top.runs', 'impl_1', 'top_timing_summary_routed.rpt')
        if not os.path.isfile(timing_summary):
            log_error("MISSING TIMING SUMMARY: failed to locate timing summary for module #{}".format(index))
            return

    # Parse timing summary
    with open(timing_summary, "r+") as fp:
        while True:
            line = fp.readline()
            # checks if line is empty (EOF)!
            if not line:
                break
            # checks for VIOLATED
            if "VIOLATED" in line:
                # adds 1 to counter if found
                violated_counts += 1
                # checks args for -v and -a
                if args.v or args.a:
                    log_info( "-" * ts)
                    log_info(line.strip(os.linesep))
                    additional_lines = 4
                    for _ in range(additional_lines):
                        log_info(fp.readline().strip(os.linesep))
                    log_info("-" * ts)

    # outputs sum of errors warnings and critical warnings if any accured it gets painted in color
    log_info("#" * ts)
    if errors:
        log_error("ERRORS: %d" % errors)
    else:
        log_info("ERRORS: %d" % errors)

    if warnings:
        log_warning("WARNINGS: %d" % warnings)
    else:
        log_info("WARNINGS: %d" % warnings)

    if crit_warnings:
        log_warning("CRITICAL WARNINGS: %d" % crit_warnings)
    else:
        log_info("CRITICAL WARNINGS: %d" % crit_warnings)

    if violated_counts:
        log_error("VIOLATED: %d" % violated_counts)
    else:
        log_info("VIOLATED: %d" % violated_counts)

    bit_filename = os.path.join(path, 'top', 'top.runs', 'impl_1', 'top.bit')

    if not os.path.isfile(bit_filename):
        log_error("MISSING BIT FILE: %s" % bit_filename)
        log_info("")
    log_info ("#" * ts)

def parse():
    parser = argparse.ArgumentParser(description="Output Log data info")
    parser.add_argument('path', help='synthesis base path (e.g. build_0x10af)', metavar='path')
    parser.add_argument('-m', action='store', type=int, metavar='module', help="input a number refering to a module in the folder; outputs the log of one module")
    parser.add_argument('-a', action='store_true', help="show all errors, warnings, critical warnings and timing violations")
    parser.add_argument('-c', action='store_true', help="show critical warnings")
    parser.add_argument('-e', action='store_true', help="show errors")
    parser.add_argument('-w', action='store_true', help="show warnings")
    parser.add_argument('-v', action='store_true', help="show timing violations")
    parser.add_argument('-o', action='store', metavar='path', help="dump output to logfile")
    return parser.parse_args()

def main():
    """Main routine."""

    # Parse command line arguments.
    args = parse()

    # Check for exisiting target path.
    if not os.path.isdir(args.path):
        raise RuntimeError("no such directory: {}".format(args.path))

    # Name of build directory.
    buildname = os.path.basename(os.path.abspath(args.path))

    # Read build configuration.
    config = ConfigParser.ConfigParser()
    filename = "{}.cfg".format(buildname)
    config.read(os.path.join(args.path, filename))
    menu_name = config.get('menu', 'name')
    menu_modules = int(config.get('menu', 'modules'))

    # Select only a single module
    if args.m != None:
        if not 0 <= args.m < menu_modules:
            raise RuntimeError("module %d not available. There are only %s modules registed" % (args.m, menu_modules))
        check_modules = [args.m]
    else:
        check_modules = range(menu_modules)

    # Check only a particular module
    for index in check_modules:
        module_id = "module_{}".format(index)
        module_path = os.path.join(args.path, menu_name, module_id)
        log_info("=" * ts)
        log_info(module_id)
        log_info("=" * ts)
        log_info("")
        find_errors(module_path, args, index)
        log_info("")

    if args.o:
        # Write log to file
        with open(os.path.abspath(args.o), 'w+') as ins:
            # Dump accumulated messages
            for message in messages:
                ins.write(message)
                ins.write(os.linesep)


# Run main function with passed arguments.
if __name__ == '__main__':
    sys.exit(main())

#eof
