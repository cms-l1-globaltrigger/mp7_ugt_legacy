import argparse
import logging
import os
import subprocess
import sys

import toolbox as tb
from time import sleep

DefaultSynthDir = 'work_synth/production'
DefaultUgtUrl = 'https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy'
DefaultUgtTag = 'master'
DefaultMenu4Checkout = 'L1Menu_Collisions2020_v0_1_5-d3'
DefaultMenuRepo = 'l1menus'
DefaultMenuRepoYear = '2022'
DefaultMP7Tag = 'mp7fw_v3_0_0_mp7_ugt'

def read_file(filename):
    """Returns contents of a file."""
    with open(filename, 'r') as fp:
        return fp.read()


def run_command(*args):
    command = ' '.join(args)
    logging.info(">$ %s", command)
    os.system(command)


def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('menuname', type=tb.xmlname_t, help="L1Menu name (eg. 'L1Menu_Collisions2020_v0_1_6')")
    parser.add_argument('--user', required=True, help="synthesis server user name [required]")
    parser.add_argument('--github_user', required=True, help="git hub user name [required]")
    parser.add_argument('--temp_dir', metavar='<path>', required=True, help="temporarly workflow dir name [required]")
    parser.add_argument('--xml_path', metavar='<path>', required=True, help="absolute path to XML file [required]")
    parser.add_argument('--tv_path', metavar='<path>', required=True, help="absolute path to test vector file [required]")
    parser.add_argument('--dist', required=True, help="distribution number for VHDL Producer [required]")
    parser.add_argument('--ugt_url', metavar='<path>', default=DefaultUgtUrl, help="ugt firmware repo url (default is '{}')".format(DefaultUgtUrl))
    parser.add_argument('--ugt', metavar='<path>', default=DefaultUgtTag, help="ugt firmware repo: tag or branch name (default is '{}')".format(DefaultUgtTag))
    parser.add_argument('--synth_dir', metavar='<path>', default=DefaultSynthDir, help="relative path to local dir for synthesis results (default is '{}')".format(DefaultSynthDir))
    parser.add_argument('--build', type=tb.build_str_t, required=True, metavar='<version>', help="menu build version (eg. 0x1001) [required]")
    parser.add_argument('--checkout_menu', metavar='<path>', default=DefaultMenu4Checkout, help="checkout menu name (default is '{}')".format(DefaultMenu4Checkout))
    parser.add_argument('--menu_repo', metavar='<path>', default=DefaultMenuRepo, help="menu repo name (default is '{}')".format(DefaultMenuRepo))
    parser.add_argument('--menu_repo_year', metavar='<path>', default=DefaultMenuRepoYear, help="menu repo year dir (default is '{}')".format(DefaultMenuRepoYear))
    parser.add_argument('--mp7_tag', metavar='<path>', default=DefaultMP7Tag, help="mp7 tag name (default is '{}')".format(DefaultMP7Tag))
    parser.add_argument('--ignored', action='store_true', default=False, help="using IGNORED_ALGOS in simulation for error checks")
    return parser.parse_args()


def main():
    """Main routine."""

    # Parse command line arguments.
    args = parse_args()

    menuname_dist = "{}-d{}".format(args.menuname, args.dist)
    home_dir = os.path.join('/home', args.user)
    menu_local = os.path.join(args.menu_repo, args.menu_repo_year)
    menu_repo = os.path.join(args.github_user, args.menu_repo, menuname_dist, args.menu_repo_year)
    menu_url = os.path.join('https://raw.githubusercontent.com', menu_repo)
    temp_dir_path = os.path.join(home_dir, args.temp_dir)
    scripts_path = os.path.dirname(os.path.abspath(__file__))
    tme_error_file = os.path.join(temp_dir_path, 'tme_error.txt')
    menu_branch_exists_file = os.path.join(temp_dir_path, 'menu_branch_exists.txt')

    commit_message = "'added new menu {}'".format(menuname_dist)

    # Setup console logging
    logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)

    build_path = os.path.join(home_dir, args.synth_dir, args.build)
    if os.path.exists(build_path):
        command = "rm -rf {build_path}".format(**locals())
        run_command(command)

    sim_temp_dir = os.path.join('/'.join(scripts_path.split('/')[:-1]), 'firmware', 'sim', 'temp_dir')
    if os.path.exists(sim_temp_dir):
        command = "rm -rf {sim_temp_dir}".format(**locals())
        run_command(command)

    if os.path.exists(temp_dir_path):
        command = "rm -rf {temp_dir_path}".format(**locals())
        run_command(command)

    os.makedirs(temp_dir_path)

    local_menu_path = os.path.join(temp_dir_path, menu_local, menuname_dist)

    if os.path.exists(local_menu_path):
        raise RuntimeError('%s exists - remove it and execute script once more' % local_menu_path)

    if not os.path.exists(args.xml_path):
        raise RuntimeError('%s does not exists' % args.xml_path)

    if not os.path.exists(args.tv_path):
        raise RuntimeError('%s does not exists' % args.tv_path)

    synth_dir_build_path = os.path.join(temp_dir_path, args.synth_dir, args.build)
    if os.path.exists(synth_dir_build_path):
        raise RuntimeError('%s exists - remove build and execute script once more' % synth_dir_build_path)

    if os.path.exists(tme_error_file):
        command = "rm {tme_error_file}".format(**locals())
        run_command(command)

    if os.path.exists(menu_branch_exists_file):
        command = "rm {menu_branch_exists_file}".format(**locals())
        run_command(command)

    logging.info("===========================================================================")
    logging.info("verifying menu '%s' with TME", args.xml_path)
    command = 'bash -c "{home_dir}/tm-editor {args.xml_path} 2>&1 | tee {tme_error_file}"'.format(**locals())
    run_command(command)

    if os.stat(tme_error_file).st_size > 0:
        print("===================================")
        print("verifying XML in TME shows errors !!!")
        sys.exit(1)

    logging.info("===========================================================================")
    logging.info("clone menu repo 'args.menu_repo' to '%s'", args.temp_dir)
    command = 'bash -c "git clone https://github.com/{args.github_user}/{args.menu_repo}.git {home_dir}/{args.temp_dir}/{args.menu_repo}; "'.format(**locals())
    run_command(command)

    command = 'bash -c "cd {home_dir}/{args.temp_dir}/{args.menu_repo}; git show-branch remotes/origin/{menuname_dist} &> {menu_branch_exists_file}"'.format(**locals())
    run_command(command)

    words = read_file(menu_branch_exists_file).split(' ')
    if words[0] == 'fatal:':
        logging.info("===========================================================================")
        logging.info("create new branch '%s'", menuname_dist)
        command = 'bash -c "cd {home_dir}/{args.temp_dir}/{args.menu_repo}; git checkout {args.checkout_menu}; git checkout -b {menuname_dist}"'.format(**locals())
        run_command(command)
    else:
        raise RuntimeError('branch %s exists - delete it from repo (or change menu name)' % menuname_dist)

    logging.info("===========================================================================")
    logging.info("run VHDL Producer")
    vhdl_prod_out = os.path.join(temp_dir_path, menu_local)

    subprocess.check_call([os.path.join(home_dir, 'tm-vhdlproducer'), args.xml_path, '--modules 6', '--dist', args.dist, '--sorting desc', '--output', vhdl_prod_out])

    logging.info("===========================================================================")
    logging.info("copy test vector file to created menu %s", local_menu_path)
    command = 'bash -c "scp {args.tv_path} {local_menu_path}/testvectors/TestVector_{args.menuname}.txt"'.format(**locals())
    run_command(command)

    logging.info("===========================================================================")
    logging.info("commit generated VHDL code of menu %s", menuname_dist)
    command = 'bash -c "cd {home_dir}/{args.temp_dir}/{menu_local}; git add {menuname_dist}; git pull; git commit -m {commit_message}; git push --set-upstream origin {menuname_dist}"'.format(**locals())
    run_command(command)

    # waiting for commit is finished
    sleep(2.0)

    logging.info("===========================================================================")
    logging.info("clone repo 'mp7' to %s (for simulation)", args.temp_dir)
    command = 'bash -c "git clone https://gitlab.cern.ch/hbergaue/mp7.git {home_dir}/{args.temp_dir}/mp7"'.format(**locals())
    run_command(command)

    logging.info("===========================================================================")
    logging.info("checkout branch %s of repo mp7", args.mp7_tag)
    logging.info("to %s (for simulation)", args.temp_dir)
    command = 'bash -c "cd {home_dir}/{args.temp_dir}/mp7; git checkout {args.mp7_tag}"'.format(**locals())
    run_command(command)

    ignored = ''
    if args.ignored:
        ignored = '--ignored'

    logging.info("===========================================================================")
    logging.info("run simulation")
    subprocess.check_call(['python3', os.path.join(scripts_path, 'run_simulation_questa.py'), os.path.join(menu_url,  menuname_dist), '--tv', args.tv_path, ignored])

    logging.info("===========================================================================")
    logging.info("run synthesis (takes about 4 hours)")
    subprocess.check_call(['python3', os.path.join(scripts_path, 'run_synth_ipbb.py'), menuname_dist, '--menuurl', menu_url, '--ugturl', args.ugt_url, '--ugt', args.ugt, '--build', args.build, '-p', os.path.join(home_dir, args.synth_dir)])

    write_bitstream_path = os.path.join(scripts_path, 'vivado_write_bitstream.tcl')

    build_path = os.path.join(home_dir, args.synth_dir, args.build, menuname_dist)
    build_cfg = "{}/build_{}.cfg".format(build_path, args.build)
    check_path = os.path.join(scripts_path, 'checkIpbbSynth.py')
    packer_path = os.path.join(scripts_path, 'fwpackerIpbb.py')

    print("===========================================================================")
    print("check, whether syntheses still running:")
    print("$ screen -r")
    print(" ")
    print("after all syntheses have finished, check results:")
    print("$ python3", check_path, build_cfg)
    print(" ")
    print("if timing errors (and bit files is not generated) occur, execute the following command for every module with errors:")
    print("$ vivado -mode batch -source", write_bitstream_path, " -tclargs", build_path, " <module number (e.g.: 0)>")
    print(" ")
    print("after successfully created bit files, execute the following command to create tar file for HW:")
    print("$ python3", packer_path, build_cfg)
    print("===========================================================================")

    logging.info("done.")

if __name__ == '__main__':
    main()
