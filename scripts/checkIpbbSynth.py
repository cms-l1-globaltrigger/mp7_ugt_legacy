# Created by Philipp Wanggo, Jul 2017
# Extended by Bernhard Arnold, Aug/Dec 2017
#
# Renamed and modified for IPBB by Herbert Bergauer, Apr 2019
#
# Validating synthesis builds.
#

import argparse
import configparser
import os
import sys

from collections import namedtuple
from typing import Dict, List

# TTY color sequences
ColorWhiteRed = "\033[37;41;1m"
ColorYellowWhite = "\033[43;37;1m"
ColorReset = "\033[0m"

UtilizationRow = namedtuple('UtilizationRow', 'site_type, used, fixed, available, percent')
"""Tuple holding utilization information."""


def parse_utilization(line: str) -> UtilizationRow:
    """Simple parser to read a single row from a utilization report table."""
    cols = [col.strip() for col in line.split("|")][1:-1]
    return UtilizationRow(*cols)


class Logger:
    """Custom message logger."""

    def __init__(self) -> None:
        self.messages: List[str] = []

    def info(self, message: str) -> None:
        self.messages.append(message)
        print(message)

    def warning(self, message: str) -> None:
        self.messages.append(message)
        # Apply TTY colors
        if sys.stdout.isatty():
            message = f"{ColorYellowWhite}{message}{ColorReset}"
        print(message)

    def error(self, message: str) -> None:
        self.messages.append(message)
        # Apply TTY colors
        if sys.stdout.isatty():
            message = f"{ColorWhiteRed}{message}{ColorReset}"
        print(message)

    def hr(self, pattern: str) -> None:
        """Print horizontal line to logger."""
        # TTY size
        with os.popen('stty size') as fp:
            o, ts = fp.read().split()
        self.info(pattern * int(ts))


class Analyzer:
    """Synthesis log file analyzer."""

    def __init__(self) -> None:
        self.logger: Logger = Logger()
        self.utilization: Dict[int, List[UtilizationRow]] = {}
        # Options
        self.show_all = False
        self.show_criticals = False
        self.show_errors = False
        self.show_warnings = False
        self.show_violations = False

    def find_errors(self, module_path: str, module_id: int) -> None:
        """Parse log files."""

        errors: int = 0
        warnings: int = 0
        crit_warnings: int = 0
        violated_counts: int = 0

        #
        # Parse Vivado log file
        #

        # uses runme.log files for checks (vivado.log do not exist with IPBB)
        proj_name = f'module_{module_id}'
        runs = os.path.join(proj_name, f'{proj_name}.runs')
        synth_path = os.path.join(module_path, runs, 'synth_1')
        impl_path = os.path.join(module_path, runs, 'impl_1')
        runme_log_synth = os.path.join(synth_path, 'runme.log')
        runme_log_impl = os.path.join(impl_path, 'runme.log')

        self.logger.hr("=")
        self.logger.info(f"Module #{module_id}")
        self.logger.hr("=")
        self.logger.info("")

        # opens file as .log
        with open(runme_log_synth) as fp:
            for line in fp:
                line = line.lstrip()
                # checks in current line if error is at the beginning
                if line.startswith("ERROR"):
                    errors += 1
                    # checks for args if -a or -e is an arg print error line
                    if self.show_all or self.show_errors:
                        self.logger.hr("-" )
                        self.logger.info(line)
                        self.logger.hr("-")
                # checks in current line if warning is at the beginning
                elif line.startswith("WARNING"):
                    warnings += 1
                    # checks for args if -a or -w is an arg print warning line
                    if self.show_all or self.show_warnings:
                        self.logger.hr("-")
                        self.logger.info(line)
                        self.logger.hr("-")
                # checks in current line if critical warning is at the beginning
                elif line.startswith("CRITICAL WARNING"):
                    crit_warnings += 1
                    # checks for args if -a or -c is an arg print critical warning line
                    if self.show_all or self.show_criticals:
                        self.logger.hr("-")
                        self.logger.info(line)
                        self.logger.hr("-")

        # opens file as .log
        with open(runme_log_impl) as fp:
            for line in fp:
                line = line.lstrip()
                # checks in current line if error is at the beginning
                if line.startswith("ERROR"):
                    errors += 1
                    # checks for args if -a or -e is an arg print error line
                    if self.show_all or self.show_errors:
                        self.logger.hr("-" )
                        self.logger.info(line)
                        self.logger.hr("-")
                # checks in current line if warning is at the beginning
                elif line.startswith("WARNING"):
                    warnings += 1
                    # checks for args if -a or -w is an arg print warning line
                    if self.show_all or self.show_warnings:
                        self.logger.hr("-")
                        self.logger.info(line)
                        self.logger.hr("-")
                # checks in current line if critical warning is at the beginning
                elif line.startswith("CRITICAL WARNING"):
                    crit_warnings += 1
                    # checks for args if -a or -c is an arg print critical warning line
                    if self.show_all or self.show_criticals:
                        self.logger.hr("-")
                        self.logger.info(line)
                        self.logger.hr("-")

        #
        # Parse timing summary\
        #

        # Try to locate timing summary, first try
        timing_summary = os.path.join(impl_path, 'top_timing_summary_postroute_physopted.rpt')
        if not os.path.isfile(timing_summary):
            # else a second try
            timing_summary = os.path.join(impl_path, 'top_timing_summary_routed.rpt')
            if not os.path.isfile(timing_summary):
                self.logger.error(f"MISSING TIMING SUMMARY: failed to locate timing summary for module #{module_id}")
                return

        # Parse timing summary
        with open(timing_summary) as fp:
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
                    if self.show_all or self.show_violations:
                        self.logger.hr("-")
                        self.logger.info(line.strip(os.linesep))
                        additional_lines = 4
                        for _ in range(additional_lines):
                            self.logger.info(fp.readline().strip(os.linesep))
                        self.logger.hr("-")

        # outputs sum of errors warnings and critical warnings if any accured it gets painted in color
        self.logger.hr("#")

        message = f"ERRORS: {errors}"
        self.logger.error(message) if errors else self.logger.info(message)

        message = f"WARNINGS: {warnings}"
        self.logger.warning(message) if warnings else self.logger.info(message)

        message = f"CRITICAL WARNINGS: {crit_warnings}"
        self.logger.warning(message) if crit_warnings else self.logger.info(message)

        message = f"VIOLATED: {violated_counts}"
        self.logger.error(message) if violated_counts else self.logger.info(message)

        self.get_utilization(impl_path, module_id)
        self.check_bitfile(impl_path, module_id)

        self.logger.hr("#")
        self.logger.info("")

    def get_utilization(self, impl_path, module_id):
        """Parse utilization report (dump later)"""
        utilization_placed = os.path.join(impl_path, 'top_utilization_placed.rpt')

        if module_id in self.utilization:
            raise KeyError(f"module id already analyzed: {module_id}")

        self.utilization[module_id] = []

        with open(utilization_placed) as fp:
            for line in fp:
                if line.startswith("| Slice LUTs"):
                    self.utilization[module_id].append(parse_utilization(line))
                if line.startswith("| Block RAM"):
                    self.utilization[module_id].append(parse_utilization(line))
                if line.startswith("| DSPs"):
                    self.utilization[module_id].append(parse_utilization(line))


    def check_bitfile(self, impl_path, module_id):
        """Check for existing bitfile."""
        bit_file = f'module_{module_id}.bit'
        bit_filename = os.path.join(impl_path, 'top.bit')

        if not os.path.isfile(bit_filename):
            self.logger.error(f"MISSING BIT FILE: {bit_filename}")
            self.logger.info("")

    def dump_utilization_report(self) -> None:
        """Dumps utilization summary table."""
        self.logger.info("+------------------------------------------------------------------------------------+")
        self.logger.info("|                                                                                    |")
        self.logger.info("|                            Utilization Design Summary                              |")
        self.logger.info("|                                                                                    |")
        self.logger.info("+--------+---------------------------+-----------------------+-----------------------+")
        self.logger.info("|        |         Slice LUTs        |          BRAMs        |           DSPs        |")
        self.logger.info("| Module +----------------+----------+------------+----------+------------+----------+")
        self.logger.info("|        | Used/Available | Percent  | Used/Avail | Percent  | Used/Avail | Percent  |")
        self.logger.info("+--------+----------------+----------+------------+----------+------------+----------+")
        for module_id, utils in self.utilization.items():
            row = f"| {module_id:>6} "
            for util in utils:
                ratio = f"{util.used}/{util.available}"
                if util.site_type == 'Slice LUTs':
                    row += f"| {ratio:>14} | {util.percent:>6} % "
                else:
                    row += f"| {ratio:>10} | {util.percent:>6} % "
            row += "|"
            self.logger.info(row)
        self.logger.info("+--------+----------------+----------+------------+----------+------------+----------+")
        self.logger.info("")

    def write_logifle(self, filename: str) -> None:
        with open(os.path.abspath(filename), 'w+') as fp:
            for message in self.logger.messages:
                fp.write(message)
                fp.write(os.linesep)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Check synthesis result logs")
    parser.add_argument('config', metavar='config', help="synthesis build configuration file, eg. build_0x10af.cfg")
    parser.add_argument('-m', type=int, metavar='<id>', help="check only a single module ID")
    parser.add_argument('-a', '--all', action='store_true', help="show all errors, warnings, critical warnings and timing violations")
    parser.add_argument('-c', '--criticals', action='store_true', help="show critical warnings")
    parser.add_argument('-e', '--errors', action='store_true', help="show errors")
    parser.add_argument('-w', '--warnings', action='store_true', help="show warnings")
    parser.add_argument('-v', '--violations', action='store_true', help="show timing violations")
    parser.add_argument('-o', metavar='<filename>', help="dumps output to file")
    return parser.parse_args()


def main() -> None:
    """Main routine."""

    # Parse command line arguments.
    args = parse_args()

    # Check for exisiting config file.
    if not os.path.isfile(args.config):
        raise RuntimeError(f"no such file: {args.config}")

    # Read build configuration.
    config = configparser.ConfigParser()
    config.read(args.config)
    menu_name = config.get('menu', 'name')
    menu_modules = int(config.get('menu', 'modules'))

    # Definitions for name of IPBB 'proj' directory
    fw_type = config.get('firmware', 'type')
    device_name = config.get('device', 'name')
    menu_build = config.get('menu', 'build')
    build_path = config.get('firmware', 'buildarea')

    # Select only a single module
    if args.m is not None:
        if not 0 <= args.m < menu_modules:
            raise RuntimeError(f"module {args.m} not available. There are only {menu_modules} modules registered")
        check_modules = [args.m]
    else:
        check_modules = list(range(menu_modules))

    analyzer = Analyzer()
    analyzer.show_all = args.all
    analyzer.show_criticals = args.criticals
    analyzer.show_errors = args.errors
    analyzer.show_warnings = args.warnings
    analyzer.show_violations = args.violations

    # Check modules
    for index in check_modules:
        # IPBB 'proj' directory
        project_path = os.path.join(build_path, 'proj', f'module_{index}')
        analyzer.find_errors(project_path, index)

    analyzer.dump_utilization_report()

    if args.o:
        analyzer.write_logifle(args.o)


if __name__ == '__main__':
    main()
