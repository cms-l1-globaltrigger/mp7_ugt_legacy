#!/usr/bin/env python

import os
import logging
from pathlib import Path

dir_path = os.path.dirname(os.path.abspath(__file__))
dir_path = dir_path.rsplit('/', 1)[0]
dir_path = dir_path.rsplit('/', 1)[0]

def run_command(*args):
    command = ' '.join(args)
    logging.info(">$ %s", command)
    os.system(command)

def get_active_branch_name(path):

    head_dir = Path(path) / ".git" / "HEAD"
    with head_dir.open("r") as f: content = f.read().splitlines()

    for line in content:
        if line[0:4] == "ref:":
            return line.partition("refs/heads/")[2]

branch_name = get_active_branch_name(dir_path)
branch_name = branch_name.strip()

versions_tex_file = os.path.join(dir_path, 'doc', 'scales_inputs_2_ugt', 'src', 'latex', 'gitbranch.tex')
nc = 'newcommand'
g_br = 'gitbranch'
g_br_txt = 'https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy/blob/{}'.format(branch_name)
with open(versions_tex_file, 'w') as fp:
    fp.write('\%s{\%s}{%s}\n' % (nc, g_br, g_br_txt))
    
command = f'bash -c "cd {dir_path}; cd doc/scales_inputs_2_ugt/src/latex; make"'
run_command(command)

