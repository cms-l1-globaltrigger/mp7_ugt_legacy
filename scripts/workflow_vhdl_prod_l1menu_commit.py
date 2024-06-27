import argparse
import configparser
import logging
import os
import shutil
import subprocess
import urllib.request
import urllib.parse
import urllib.error

import toolbox as tb

import git
import xml.etree.ElementTree as ET

DefaultL1menuRepo = 'https://github.com/mjeitler/cms-l1-menu.git'
"""Default URL L1Menu repo."""
DefaultDist = 1
"""Default distribution number."""
DefaultL1menuSubdir = '2024'
"""Default distribution number."""

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
    # TODO!
    with open(filename) as fp:
        d = fp.read()
    d = d.replace(', default=os.getlogin()', '')
    with open(filename, 'w') as fp:
        fp.write(d)


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

    # Define the remote repository URL and the local directory to clone into
    repo_url = args.repo
    
    menu_repo_name = args.repo.split("/")[-1].split(".")[0]
    local_dir = os.path.join(os.path.expanduser("~"), menu_repo_name)

    # Clone the remote repository
    repo = git.Repo.clone_from(repo_url, local_dir)

    menu_repo_local = os.path.join(os.path.expanduser("~"), menu_repo_name, args.subdir)
    if not os.path.exists(menu_repo_local):
        cmd = 'cd {0}; mkdir {1}'.format(local_dir, args.subdir)
        subprocess.check_call(['bash', '-c', cmd])

    new_branch_name = menu_xml_name + '-d' + str(args.dist)
    remote_new_branch_name = os.path.join('remotes', 'origin', new_branch_name)

    cmd = 'cd {0}; git branch -a'.format(local_dir)     
    result = subprocess.run(['bash', '-c', cmd], capture_output=True, check=True)
    branches = [token.strip() for token in result.stdout.decode().split()]

    for branch in branches:
        if branch == remote_new_branch_name:
            raise RuntimeError("\033[1;31m Branch {} exists!!! \033[0m".format(remote_new_branch_name))

    ## Create a new branch and check it out
    new_branch = repo.create_head(new_branch_name)
    new_branch.checkout()
    
    cmd = 'cd {0}; pip install --upgrade pip; pip install git+https://github.com/cms-l1-globaltrigger/tm-vhdlproducer.git@2.19.0; tm-vhdlproducer {1} -d {2}'.format(menu_repo_local, args.menu_xml, args.dist)

    subprocess.check_call(['bash', '-c', cmd])

    ## Add files
    repo.git.add(menu_repo_local)

    ## Commit the changes
    commit_str = '-am "Created new branch for new menu"'
    repo.git.commit(commit_str)

    ## Push the new branch to the remote repository
    origin = repo.remote(name='origin')
    origin.push(new_branch_name)

    logging.info("===========================================================================")
    logging.info("New branch %s pushed to remote.", new_branch_name)
    logging.info("===========================================================================")
    
    logging.info("done.")


if __name__ == '__main__':
    main()
