import argparse
import configparser
import logging
import os
import subprocess

import toolbox as tb

import xml.etree.ElementTree as ET

DefaultL1menuRepo = 'https://github.com/mjeitler/cms-l1-menu.git'
"""Default URL L1Menu repo."""
DefaultDist = 1
"""Default distribution number."""
DefaultL1menuSubdir = '2024'
"""Default distribution number."""

#def run_command(*args):
    #command = ' '.join(args)
    #logging.info(">$ %s", command)
    #os.system(command)


def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('menu_xml', help="local menu xml file")
    parser.add_argument('--dist', default=DefaultDist, help="distribution (default is '{}')".format(DefaultDist))
    parser.add_argument('--repo', metavar='<path>', default=DefaultL1menuRepo, help="L1Menu repo path (default is '{}')".format(DefaultL1menuRepo))
    parser.add_argument('--subdir', default=DefaultL1menuSubdir, help="L1Menu repo sub dir name (default is '{}')".format(DefaultL1menuSubdir))
    return parser.parse_args()


def main():
    """Main routine."""

    # Parse command line arguments.
    args = parse_args()
    
    tree = ET.parse(args.menu_xml)
    root = tree.getroot()    
    menu_xml_name = root.find('name').text    
    # check menu name
    tb.xmlname_t(menu_xml_name)
        
    # Setup console logging
    logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)

    logging.info("===========================================================================")
    logging.info("git checkout %s ...", args.repo)
    #subprocess.check_call(['bash', '-c', 'cd; mkdir cms-l1-menu'])

    # Define local directory to clone into
    menu_repo_name = args.repo.split("/")[-1].split(".")[0]
    local_dir = os.path.join(os.path.expanduser("~"), menu_repo_name)

    # Clone the remote repository
    cmd = 'cd; git clone {0}'.format(args.repo)     
    subprocess.check_call(['bash', '-c', cmd])

    menu_repo_local = os.path.join(os.path.expanduser("~"), menu_repo_name, args.subdir)
    if not os.path.exists(menu_repo_local):
        cmd = 'cd {0}; mkdir {1}'.format(local_dir, args.subdir)
        subprocess.check_call(['bash', '-c', cmd])

    new_branch_name = menu_xml_name + '-d' + str(args.dist)

    cmd = 'cd {0}; git branch -a'.format(local_dir)     
    result = subprocess.run(['bash', '-c', cmd], capture_output=True, check=True)
    branches = [token.strip() for token in result.stdout.decode().split()]

    for branch in branches:
        #print(branch)
        branch = branch.split('/')[-1]
        #print(branch)
        if branch == new_branch_name:
            raise RuntimeError("\033[1;31m Branch {} exists!!! \033[0m".format(new_branch_name))

    ## Create a new branch and check it out
    cmd = 'cd {0}; git checkout -b {1}'.format(local_dir, new_branch_name)     
    subprocess.check_call(['bash', '-c', cmd])
    
    cmd = 'cd {0}; pip install --upgrade pip; pip install git+https://github.com/cms-l1-globaltrigger/tm-vhdlproducer.git@2.19.0; tm-vhdlproducer {1} -d {2}'.format(menu_repo_local, args.menu_xml, args.dist)
    subprocess.check_call(['bash', '-c', cmd])

    ## Add files
    cmd = 'cd {0}; git add {1}'.format(menu_repo_local, new_branch_name)     
    subprocess.check_call(['bash', '-c', cmd])

    ## Commit the changes
    cmd = 'cd {0}; git commit -am "Created new branch for new menu" '.format(menu_repo_local)     
    subprocess.check_call(['bash', '-c', cmd])

    ## Push the new branch to the remote repository
    cmd = 'cd {0}; git push --set-upstream origin {1}'.format(menu_repo_local, new_branch_name)     
    subprocess.check_call(['bash', '-c', cmd])

    logging.info("===========================================================================")
    logging.info("New branch %s pushed to remote.", new_branch_name)
    logging.info("===========================================================================")
    
    logging.info("done.")


if __name__ == '__main__':
    main()
