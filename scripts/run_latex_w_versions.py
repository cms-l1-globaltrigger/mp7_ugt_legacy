#!/usr/bin/env python

import os
import logging
from pathlib import Path

print("================================================================================\n")
print("Get versions and branch name for Latex and 'make' mp7_ugt_firmware_specification\n")
print("================================================================================\n")

dir_path = os.path.dirname(os.path.abspath(__file__))
dir_path = dir_path.rsplit('/', 1)[0]
#print(dir_path)
file_versions = os.path.join(dir_path, 'firmware', 'hdl',  'packages',  'gt_mp7_core_pkg.vhd') 
#print(filename)

def get_versions(filename, text):

    rd_file = open(filename, 'r')
    Lines = rd_file.readlines()
  
    count = 0
    for line in Lines:
        count += 1
        if line.find(text) != -1:
            #print(line)
            value = ((line.split('=')[-1]).split(';')[0]).strip()
            #print(value)
    return value
    
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
#print(branch_name)
versions_list = [
    'constant GT_MAJOR_VERSION',
    'constant GT_MINOR_VERSION',
    'constant GT_REV_VERSION',
    'constant FRAME_MAJOR_VERSION',
    'constant FRAME_MINOR_VERSION',
    'constant FRAME_REV_VERSION',
    'constant GTL_FW_MAJOR_VERSION',
    'constant GTL_FW_MINOR_VERSION',
    'constant GTL_FW_REV_VERSION',
    'constant FDL_FW_MAJOR_VERSION',
    'constant FDL_FW_MINOR_VERSION',
    'constant FDL_FW_REV_VERSION',
    ]
versions_values = {}
    
idx = 0
for version in versions_list:
    version_value = get_versions(file_versions, version)
    versions_values[idx] = version_value
    idx += 1
#print(versions_values)

verions_tex_file = os.path.join(dir_path, 'doc', 'mp7_ugt_firmware_specification', 'src', 'latex', 'content', 'versions.tex')
nc = 'newcommand'
vgt = 'versiongt'
vframe = 'versionframe'
vgtl = 'versiongtl'
vfdl = 'versionfdl'
g_br = 'gitbranch'
g_br_txt = 'https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy/blob/{}'.format(branch_name)
with open(verions_tex_file, 'w') as fp:
    fp.write('\%s{\%s}{v%s.%s.%s }\n' % (nc, vgt, versions_values[0], versions_values[1], versions_values[2]))
    fp.write('\%s{\%s}{v%s.%s.%s }\n' % (nc, vframe, versions_values[3], versions_values[4], versions_values[5]))
    fp.write('\%s{\%s}{v%s.%s.%s }\n' % (nc, vgtl, versions_values[6], versions_values[7], versions_values[8]))
    fp.write('\%s{\%s}{v%s.%s.%s }\n' % (nc, vfdl, versions_values[9], versions_values[10], versions_values[11]))
    fp.write('\%s{\%s}{%s}\n' % (nc, g_br, g_br_txt))
    
command = f'bash -c "cd {dir_path}; cd doc/mp7_ugt_firmware_specification/src/latex; make"'
run_command(command)

