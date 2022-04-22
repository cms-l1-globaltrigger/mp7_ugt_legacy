import argparse
import logging
import os
import subprocess

import toolbox as tb
from time import sleep

import urllib.request

DefaultTempDir = 'temp_run_synth_workflow'
DefaultUgtUrl = 'https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy'
DefaultMP7Tag = 'mp7fw_v3_0_0_mp7_ugt'

def read_file(filename):
    """Returns contents of a file."""
    with open(filename, 'r') as fp:
        return fp.read()

def run_command(*args):
    command = ' '.join(args)
    logging.info(">$ %s", command)
    os.system(command)

def download_file_from_url(url, filename):
    """Download files from URL."""
    # Remove existing file.
    tb.remove(filename)
    # Download file
    logging.info("retrieving %s", url)
    urllib.request.urlretrieve(url, filename)
    tb.make_executable(filename)

    with open(filename) as fp:
        d = fp.read()
    d = d.replace(', default=os.getlogin()', '')
    with open(filename, 'w') as fp:
        fp.write(d)

def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('menu_xml_path', metavar='<path>', help="absolute path to XML file (in temp dir) (eg. '/home/bergauer/{}/l1menus/2022/L1Menu_Collisions2022_v1_0_0-d2/xml/L1Menu_Collisions2022_v1_0_0-d2.xml')".format(DefaultTempDir))
    parser.add_argument('--home_dir', metavar='<path>', required=True, help="local home dir")
    parser.add_argument('--temp_dir', metavar='<path>', default=DefaultTempDir, help="local temporarly dir in /home/<user> for workflow (default is '{}')".format(DefaultTempDir))
    parser.add_argument('--tv_path', metavar='<path>', required=True, help="absolute local path to test vector file [required]")
    parser.add_argument('--ignored', action='store_true', default=False, help="using IGNORED_ALGOS in simulation for error checks")
    parser.add_argument('--mp7_tag', metavar='<path>', default=DefaultMP7Tag, help="mp7 tag name (default is '{}')".format(DefaultMP7Tag))
    parser.add_argument('--ugt_url', metavar='<path>', default=DefaultUgtUrl, help="ugt firmware repo url (default is '{}')".format(DefaultUgtUrl))
    parser.add_argument('--ugt', metavar='<path>', required=True, help="tag or branch name of ugt firmware repo (eg. 'v1.20.0')")
    parser.add_argument('--build', type=tb.build_str_t, required=True, metavar='<version>', help="menu build version (eg. 0x113e) [required]")
    parser.add_argument('--synth_dir', metavar='<path>', required=True, help="local dir in /home/<user> for synthesis results (eg. 'work_synth/production'")
    return parser.parse_args()

def main():
    """Main routine."""

    # Parse command line arguments.
    args = parse_args()

    cwd = os.getcwd()

    home_dir = args.home_dir
    scripts_path = os.path.dirname(os.path.abspath(__file__))
    temp_dir_path = os.path.join(home_dir, args.temp_dir)
    menu_url_synth = args.menu_xml_path
    menu_name_dist = args.menu_xml_path.split('/')[-1]
    menu_repo_name = args.menu_xml_path.split('/')[-5]
    local_menu_path = os.path.join(temp_dir_path, menu_repo_name)

    #mp7_temp_dir = os.path.join(home_dir, args.temp_dir, "mp7")

    # Setup console logging
    logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)

    build_path = os.path.join(home_dir, args.synth_dir, args.build)
    if os.path.exists(build_path):
        raise RuntimeError('%s exists - remove it and execute script once more' % build_path)

    sim_temp_dir = os.path.join('/'.join(scripts_path.split('/')[:-1]), 'firmware', 'sim', 'temp_dir')
    if os.path.exists(sim_temp_dir):
        subprocess.run(["rm", "-rf", sim_temp_dir], check=True)

    if not os.path.exists(args.tv_path):
        raise RuntimeError('%s does not exists' % args.tv_path)

    synth_dir_build_path = os.path.join(temp_dir_path, args.synth_dir, args.build)
    if os.path.exists(synth_dir_build_path):
        raise RuntimeError('%s exists - remove build and execute script once more' % synth_dir_build_path)

    ignored = ''
    if args.ignored:
        ignored = '--ignored'

    #logging.info("===========================================================================")
    #logging.info("clone repo 'mp7' to %s (for simulation)", args.temp_dir)
    #subprocess.run(["git", "clone", "https://gitlab.cern.ch/hbergaue/mp7.git", mp7_temp_dir], check=True)

    #logging.info("===========================================================================")
    #logging.info("checkout branch %s of repo mp7", args.mp7_tag)
    #logging.info("to %s (for simulation)", args.temp_dir)
    #os.chdir(mp7_temp_dir)
    #subprocess.run(["git", "checkout", args.mp7_tag], check=True)
    #os.chdir(cwd)

    logging.info("===========================================================================")
    logging.info("run simulation")
    subprocess.run(['python3', os.path.join(scripts_path, 'run_simulation_questa.py'), menu_url_synth, '--tv', args.tv_path, ignored], check=True)
    os.chdir(cwd)

    logging.info("===========================================================================")
    logging.info("run synthesis (takes about 4 hours)")
    subprocess.run(['python3', os.path.join(scripts_path, 'run_synth_ipbb.py'), menu_url_synth, '--ugturl', args.ugt_url, '--ugt', args.ugt, '--build', args.build, '-p', os.path.join(home_dir, args.synth_dir)], check=True)

    write_bitstream_path = os.path.join(scripts_path, 'vivado_write_bitstream.tcl')

    build_path = os.path.join(home_dir, args.synth_dir, args.build, menu_name_dist)
    build_cfg = "{}/build_{}.cfg".format(build_path, args.build)
    check_path = os.path.join(scripts_path, 'checkIpbbSynth.py')
    packer_path = os.path.join(scripts_path, 'fwpackerIpbb.py')

    print("===========================================================================")
    print("\033[1;33m push created menu branch: \033[0m")
    print("$ cd", temp_dir_path)
    print("$ git push --set-upstream origin", menu_name_dist)
    print(" ")
    print("\033[1;33m check, whether syntheses still running: \033[0m")
    print("$ screen -r")
    print(" ")
    print("\033[1;33m after all syntheses have finished, check results: \033[0m")
    print("$ python3", check_path, build_cfg)
    print(" ")
    print("\033[1;33m if timing errors (and bit files is not generated) occur, execute the following command for every module with errors: \033[0m")
    print("$ vivado -mode batch -source", write_bitstream_path, " -tclargs", build_path, " <module number (e.g.: 0)>")
    print(" ")
    print("\033[1;33m after successfully created bit files, execute the following command to create tar file for HW: \033[0m")
    print("$ python3", packer_path, build_cfg)
    print("===========================================================================")

    logging.info("done.")

if __name__ == '__main__':
    main()
