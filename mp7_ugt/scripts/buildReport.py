# Creates textile formatted snippets for build issues
# and bitfile table in redmine.
#

import ConfigParser
import argparse
import subprocess
import re
import sys, os

USERDICT = {}

def detect_vhdl_producer_version(filename):
    needle = "-- vhdl producer version"
    with open(filename) as fp:
        prev = ""
        for line in fp:
            if prev.startswith(needle):
                return line.strip(' -v').strip()
            prev = line.strip().lower()

def detect_gtl_versions(filename):
    versions = {}
    regex = re.compile(r'^\s*\w+\s+(\w+)_(\w+)_VERSION.*\:\=\s*(\d+)')
    with open(filename) as fp:
        for line in fp:
            m = regex.match(line)
            if m:
                key = m.group(1)
                if key not in versions:
                    versions[key] = {}
                versions[key][m.group(2)] = m.group(3)
    for k, v in versions.iteritems():
        versions[k] = "{MAJOR}.{MINOR}.{REV}".format(**v)
    return versions

def detect_vivado_version(filename):
    regex = re.compile(r'^.*\s*Vivado\s+v(\d+\.\d+)')
    with open(filename) as fp:
        for line in fp:
            m = regex.match(line)
            if m:
                return m.group(1)

def detect_menu_url(dirname):
    try:
        return subprocess.check_output(['svn', 'info', '--show-item=url', dirname]).strip()
    except subprocess.CalledProcessError as e:
        return ""

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('filename', help="build config file (*.cfg)")
    return parser.parse_args()

def main():
    args = parse_args()

    config = ConfigParser.ConfigParser()
    config.read(args.filename)

    menu_dir = config.get('menu', 'location')
    buildarea_dir = config.get('firmware', 'buildarea')

    menu_name = config.get('menu', 'name')
    menu_dir = config.get('menu', 'location')
    menu_url = detect_menu_url(menu_dir)
    build_id = "0x{0}".format(config.get('menu', 'build'))
    n_modules = config.get('menu', 'modules')
    username = config.get('environment', 'username')
    build_raw = config.get('menu', 'build')
    build_id = "0x{0}".format(build_raw)
    mp7fw_tag = config.get('firmware', 'tag')
    ugt_tag = ""

    versions = {}
    versions['tm-vhdlproducer'] = detect_vhdl_producer_version(os.path.join(menu_dir, 'vhdl', 'module_0', 'src', 'ugt_constants.vhd'))
    versions['tm-reporter'] = ''
    versions['tm-editor'] = ''
    versions.update(detect_gtl_versions(os.path.join(buildarea_dir, 'module_0', 'mp7_ugt', 'firmware', 'hdl', 'gt_mp7_core', 'gt_mp7_core_pkg.vhd')))
    versions['vivado'] = detect_vivado_version(os.path.join(buildarea_dir, 'module_0', 'vivado.log'))


    table = [
        ("Menu", menu_name),
        ("Build", build_id),
        ("Modules", n_modules),
        ("Created", config.get('environment', 'timestamp')),
        ("Username", username),
        ("Hostname", config.get('environment', 'hostname')),
        ("Menu local dir", menu_dir),
        ("Menu repo url", menu_url),
        ("MP7 tag", mp7fw_tag),
        ("uGT tag", ugt_tag),
        ("uGT", versions['FRAME']),
        ("FDL", versions['FDL_FW']),
        ("GTL", versions['GTL_FW']),
        ("Vivado", versions['vivado']),
        ("Build area", buildarea_dir),
        ("tm-vhdlproducer", versions['tm-vhdlproducer']),
        ("tm-reporter", versions['tm-reporter']),
        ("tm-editor", versions['tm-editor']),
    ]

    print("Insert into ISSUE description:\n")

    for row in table:
        print("|_<.{0} |{1} |".format(*row))

    username = USERDICT[username] if username in USERDICT else username

    row = [
        menu_name,
        build_id,
        username,
        '*{0}*'.format(mp7fw_tag),
        versions['FRAME'],
        versions['GTL_FW'],
        versions['FDL_FW'],
        "\"Download\":ftp://192.168.0.241/Public/Shared_Firmware/MP7/ugt/{0}/".format(build_raw),
        n_modules,
        "#",
        "",
    ]
    print("\nPrepend BITFILES table:\n")
    print("|{0} |".format(" |".join(row)))

if __name__ == '__main__':
    main()

