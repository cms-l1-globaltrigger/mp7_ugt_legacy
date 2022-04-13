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
    parser.add_argument('menu_xml_path', metavar='<path>', help="absolute path to XML file [required] (eg. 'https://raw.githubusercontent.com/cms-l1-dpg/L1MenuRun3/master/development/L1Menu_Collisions2022_v1_0_0/L1Menu_Collisions2022_v1_0_0.xml')")
    parser.add_argument('--repo_new_menu_path', metavar='<path>', help="path to repo of new menu [required] (eg. 'github/herbberg/l1menus/master/2022')")
    parser.add_argument('--user', metavar='<path>', required=True, help="synthesis server user name [required]")
    parser.add_argument('--github_user', metavar='<path>', required=True, help="git hub user name [required]")
    parser.add_argument('--home_dir', metavar='<path>', required=True, help="local home dir")
    parser.add_argument('--temp_dir', metavar='<path>', default=DefaultTempDir, help="local temporarly dir in /home/<user> for workflow (default is '{}')".format(DefaultTempDir))
    parser.add_argument('--checkout_menu', metavar='<path>', required=True, help="checkout menu name for creating new menu branch (eg. L1Menu_Collisions2022_v1_0_0-d1)")
    parser.add_argument('--dist', type=int, required=True, help="distribution number for VHDL Producer [required]")
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
    mp7_ugt_path = os.path.join('/'.join(scripts_path.split('/')[:-1]))
    temp_dir_path = os.path.join(home_dir, args.temp_dir)
    tme_error_file = os.path.join(temp_dir_path, 'tme_error.txt')
    menu_branch_exists_file = os.path.join(temp_dir_path, 'menu_branch_exists.txt')

    menu_name = args.menu_xml_path.split('/')[-1]
    raw_git_hub_com = args.menu_xml_path.split('/')[2]
    new_menu_path = args.repo_new_menu_path.split('/')

    git_hub_com = "{}.com".format(new_menu_path[0])
    menu_git = new_menu_path[1]
    menu_repo_name = new_menu_path[2]
    menu_branch = new_menu_path[3]
    menu_year = tb.year_str_t(new_menu_path[4])

    menu_name_no_dist = menu_name.split('-')[0]
    menu_name_no_dist = menu_name.split('.')[0]
    menu_name_dist = "{}-d{}".format(menu_name_no_dist, args.dist)
    menu_url_synth = f"https://{raw_git_hub_com}/{menu_git}/{menu_repo_name}/{menu_name_dist}/{menu_year}/{menu_name_dist}/xml/{menu_name_dist}.xml"
    menu_repo_temp_dir_path = os.path.join(home_dir, args.temp_dir, menu_repo_name)
    mp7_temp_dir = os.path.join(home_dir, args.temp_dir, "mp7")

    commit_message = "'added new menu {}'".format(menu_name_dist)

    # Setup console logging
    logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)

    build_path = os.path.join(home_dir, args.synth_dir, args.build)
    if os.path.exists(build_path):
        raise RuntimeError('%s exists - remove it and execute script once more' % build_path)

    tme_path = os.path.join(mp7_ugt_path, "tm-editor")
    if not os.path.exists(tme_path):
        raise RuntimeError('tm-editor does not exists - install it in this environment')

    vhdlprod_path = os.path.join(mp7_ugt_path, "tm-vhdlproducer")
    if not os.path.exists(vhdlprod_path):
        subprocess.run(["rm", "-rf", vhdlprod_path], check=True)
        raise RuntimeError('tm-vhdlproducer does not exists - install it in this environment')

    sim_temp_dir = os.path.join('/'.join(scripts_path.split('/')[:-1]), 'firmware', 'sim', 'temp_dir')
    if os.path.exists(sim_temp_dir):
        subprocess.run(["rm", "-rf", sim_temp_dir], check=True)

    if os.path.exists(temp_dir_path):
        subprocess.run(["rm", "-rf", temp_dir_path], check=True)

    os.makedirs(temp_dir_path)

    local_menu_path = os.path.join(temp_dir_path, menu_repo_name, menu_year, menu_name_dist)

    if os.path.exists(local_menu_path):
        raise RuntimeError('%s exists - remove it and execute script once more' % local_menu_path)

    if not os.path.exists(args.tv_path):
        raise RuntimeError('%s does not exists' % args.tv_path)

    synth_dir_build_path = os.path.join(temp_dir_path, args.synth_dir, args.build)
    if os.path.exists(synth_dir_build_path):
        raise RuntimeError('%s exists - remove build and execute script once more' % synth_dir_build_path)

    if os.path.exists(tme_error_file):
        subprocess.run(["rm", tme_error_file], check=True)

    if os.path.exists(menu_branch_exists_file):
        subprocess.run(["rm", menu_branch_exists_file], check=True)

    logging.info("===========================================================================")
    logging.info("verifying menu '%s' with TME", args.menu_xml_path)

    #subprocess.run([os.path.join(mp7_ugt_path, 'tm-editor'), args.menu_xml_path], check=True)
    subprocess.run(["tm-editor", args.menu_xml_path], check=True)

    if menu_repo_name == 'l1menus':
        menu_git = 'herbberg'
        checkout_branch = 'master'
    else:
        menu_git = 'cms-l1-globaltrigger'
        checkout_branch = args.checkout_menu

    #menu_repo_git = f"https://github.com/{menu_git}/{menu_repo_name}.git"
    #subprocess.run(["git", "clone", menu_repo_git, menu_repo_temp_dir_path], check=True)
    #os.chdir(menu_repo_temp_dir_path)
    #remotes_origin = f"remotes/origin/{menu_name_dist}"
    #subprocess.run(["git", "show-branch", remotes_origin, "&>", "menu_branch_exists.txt"], capture_output=True)
    #os.chdir(cwd)

    command = f'bash -c "cd; git clone https://github.com/{menu_git}/{menu_repo_name}.git {home_dir}/{args.temp_dir}/{menu_repo_name}; cd {home_dir}/{args.temp_dir}/{menu_repo_name}; git show-branch remotes/origin/{menu_name_dist} &> {menu_branch_exists_file} "'
    run_command(command)

    words = read_file(menu_branch_exists_file).split(' ')
    if words[0] == 'fatal:':
        logging.info("===========================================================================")
        logging.info("create new branch '%s'", menu_name_dist)
        os.chdir(menu_repo_temp_dir_path)
        subprocess.run(["git", "checkout", checkout_branch], check=True)
        subprocess.run(["git", "checkout", "-b", menu_name_dist], check=True)
        os.chdir(cwd)
    else:
        raise RuntimeError('branch %s exists - delete it from repo (or change menu name)' % menu_name_dist)

    local_xml_file = os.path.join(home_dir, args.temp_dir, 'menu_xml_file')
    download_file_from_url(args.menu_xml_path, local_xml_file)

    logging.info("===========================================================================")
    logging.info("run VHDL Producer with '%s' with", local_xml_file)

    menu_local_path = os.path.join(temp_dir_path, menu_repo_name, menu_year)
    command = "tm-vhdlproducer {0} --modules 6 --dist {1} --sorting desc --output {2}".format(local_xml_file, args.dist, menu_local_path)
    os.chdir(mp7_ugt_path)
    #subprocess.run(['tm-vhdlproducer', local_xml_file, '--modules', str(6), '--dist', args.dist, '--sorting', 'desc', '--output', menu_local_path], check=True)
    run_command(command)
    os.chdir(cwd)

    logging.info("===========================================================================")
    logging.info("copy test vector file to created menu %s", local_menu_path)
    tv_name = "/TestVector_{}.txt".format(menu_name)
    local_tv_file = "{}/.".format(os.path.join(os.path.join(local_menu_path, "testvectors")))
    subprocess.run(["cp", args.tv_path, local_tv_file], check=True)

    logging.info("===========================================================================")
    logging.info("commit generated VHDL code of menu %s", menu_name_dist)
    os.chdir(menu_local_path)
    subprocess.run(["git", "add", menu_name_dist], check=True)
    subprocess.run(["git", "pull"])
    subprocess.run(["git", "commit", "-m", commit_message], check=True)
    #subprocess.run(["git", "push", "--set-upstream", "origin", menu_name_dist], check=True)
    os.chdir(cwd)

    # waiting for commit is finished
    sleep(2.0)

    ignored = ''
    if args.ignored:
        ignored = '--ignored'

    logging.info("===========================================================================")
    logging.info("clone repo 'mp7' to %s (for simulation)", args.temp_dir)
    subprocess.run(["git", "clone", "https://gitlab.cern.ch/hbergaue/mp7.git", mp7_temp_dir], check=True)

    logging.info("===========================================================================")
    logging.info("checkout branch %s of repo mp7", args.mp7_tag)
    logging.info("to %s (for simulation)", args.temp_dir)
    os.chdir(mp7_temp_dir)
    subprocess.run(["git", "checkout", args.mp7_tag], check=True)
    os.chdir(cwd)

    logging.info("===========================================================================")
    logging.info("run simulation")
    xml_file_4_sim = "{}.xml".format(os.path.join(local_menu_path, 'xml', menu_name_dist))
    subprocess.run(['python3', os.path.join(scripts_path, 'run_simulation_questa.py'), xml_file_4_sim, '--tv', args.tv_path, ignored], check=True)
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
    print("$ cd", local_menu_path)
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
