"""Automated workflow for producing a new menu distributions and pushing the
files to a remote git repository.

What this script does:
 - verify python interpreter version (>= Python 3.9)
 - create a temporary directory
 - inside, create a python virtual environment
 - install tm-vhdlproducer inside virtual environment
 - clone remote git repository
 - create a new menu distribution using tm-vhdlproducer
 - create a new git branch for the distribution
 - add the distribution files to the branch
 - pushes the branch to the remote git repository
 - finally clean up all temporary files

"""

import argparse
import configparser
import logging
import os
import re
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET

DefaultL1menuRepo = "https://github.com/mjeitler/cms-l1-menu.git"
"""Default URL L1Menu repo."""

DefaultDist = 1
"""Default distribution number."""

DefaultL1menuSubdir = "2024"
"""Default distribution number."""

VHDLProsucerVersion = "2.19.0"
VHDLProducerUrl = f"git+https://github.com/cms-l1-globaltrigger/tm-vhdlproducer.git@{VHDLProsucerVersion}"


def validate_menu_name(name: str) -> str:
    """L1menu XML name tag."""
    if not re.match(r'^L1Menu_\w+', name):
        raise ValueError(f"not a valid menu name: '{name}'")


def check_interpreter_version() -> None:
    version_info = sys.version_info
    if (version_info.major, version_info.minor) < (3, 9):
        raise RuntimeError(f"Requires at least Python 3.9 (current is {version_info.major}.{version_info.minor})")


def parse_menu_name(filename: str) -> str:
    tree = ET.parse(filename)
    root = tree.getroot()
    return root.find("name").text  # TODO weak search


def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument("menu_xml", help="path to local menu xml file")
    parser.add_argument("-d", "--dist", default=DefaultDist, help=f"distribution (default is {DefaultDist!r})")
    parser.add_argument("--repo", metavar="<path>", default=DefaultL1menuRepo, help=f"L1Menu repo path (default is {DefaultL1menuRepo!r})")
    parser.add_argument("--subdir", default=DefaultL1menuSubdir, help=f"L1Menu repo sub dir name (default is {DefaultL1menuSubdir!r})")
    parser.add_argument("-y", "--yes", "--assume-yes", action="store_true", help="automatically answer yes for all questions")
    return parser.parse_args()


def main():
    """Main routine."""

    # Parse command line arguments.
    args = parse_args()

    # Setup console logging
    logging.basicConfig(format="%(levelname)s: %(message)s", level=logging.INFO)

    check_interpreter_version()

    # Absoulte path to input file
    menu_filename = os.path.abspath(args.menu_xml)

    # Extract menu name for new branch
    menu_name = parse_menu_name(menu_filename)

    # Validate menu name
    validate_menu_name(menu_name)

    # Create temporary working dir
    with tempfile.TemporaryDirectory() as temp_dir:
        logging.info("created temporary dir %r ...", temp_dir)
        os.chdir(temp_dir)

        logging.info("creating virtual env ...")

        # Create virtual python environment usign current interpreter
        subprocess.run([sys.executable, "-m", "venv", "env"], check=True)

        env_activate = os.path.join(temp_dir, "env", "bin", "activate")

        logging.info("git checkout %r ...", args.repo)

        # Define local directory to clone into
        menu_repo_name = "cms-l1-menu"

        # Clone the remote repository
        subprocess.run(["git", "clone", args.repo, menu_repo_name], check=True)

        # Change into the repository
        os.chdir(menu_repo_name)

        new_branch_name = f"{menu_name}-d{args.dist:d}"

        result = subprocess.run(["git", "branch", "-a"], capture_output=True, check=True)
        branches = [token.strip() for token in result.stdout.decode().split()]

        for branch in branches:
            branch_name = branch.split("/")[-1]
            if branch_name == new_branch_name:
                raise RuntimeError(f"git branch already exists: {new_branch_name!r}")

        if not os.path.exists(args.subdir):
            os.makedirs(args.subdir)

        # Change into the subdir
        os.chdir(args.subdir)

        ## Create a new branch and check it out
        subprocess.run(["git", "checkout", "-b", new_branch_name], check=True)

        cmd = f". {env_activate}; pip install --upgrade pip"
        subprocess.run(["bash", "-c", cmd], check=True)

        cmd = f". {env_activate}; pip install {VHDLProducerUrl}"
        subprocess.run(["bash", "-c", cmd], check=True)

        cmd = f". {env_activate}; tm-vhdlproducer {menu_filename} -d {args.dist}"
        subprocess.run(["bash", "-c", cmd], check=True)

        # Add files
        subprocess.run(["git", "add", new_branch_name], check=True)

        # Commit the changes
        subprocess.run(["git", "commit", "-am", "Created new branch for new menu"], check=True)

        logging.info("about to push changes to upstream origin [%s]", args.repo)

        # Push the new branch to the remote repository
        prompt = "Do you want to continue? (y/N): "
        response = input(prompt).strip().lower()
        if response != "y":
            logging.info("aborted.")
        else:
            subprocess.run(["git", "push", "--set-upstream", "origin", new_branch_name], check=True)
            logging.info("new branch %r pushed to remote origin", new_branch_name)

            logging.info("done.")


if __name__ == "__main__":
    main()
