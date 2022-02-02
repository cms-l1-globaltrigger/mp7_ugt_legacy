"""Script for inserting versions of firmware parts (from gt_mp7_core_pkg.vhd) into TEX files.
"""

import os

def run_command(*args):
    command = ' '.join(args)
    os.system(command)

script_file_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)))

gt_mp7_core_pkg = os.path.join(script_file_dir, '../../firmware/hdl/packages/gt_mp7_core_pkg.vhd')

# strings for used in gt_mp7_core_pkg.vhd for names of versions constants
gt_parts = ['FRAME', 'GTL_FW', 'FDL_FW']
version_parts = ['MAJOR', 'MINOR', 'REV']

versions = {
gt_parts[0]: {version_parts[0]: 0, version_parts[1]: 0, version_parts[2]: 0},
gt_parts[1]: {version_parts[0]: 0, version_parts[1]: 0, version_parts[2]: 0},
gt_parts[2]: {version_parts[0]: 0, version_parts[1]: 0, version_parts[2]: 0}
}

# get versions from gt_mp7_core_pkg.vhd file
with open(gt_mp7_core_pkg) as f_versions:
    versionsfile = f_versions.readlines()
for line in versionsfile:
    for gt_part in gt_parts:
        for version_part in version_parts:
            item = "constant {}_{}_VERSION".format(gt_part,version_part)
            if item in line:
                versions[gt_part][version_part] = line.split(':=')[-1].split(';')[0].replace(' ','')

gt_version = "v{}.{}.{}".format(versions["FRAME"]["MAJOR"],versions["FRAME"]["MINOR"],versions["FRAME"]["REV"])
gtl_version = "v{}.{}.{}".format(versions["GTL_FW"]["MAJOR"],versions["GTL_FW"]["MINOR"],versions["GTL_FW"]["REV"])
fdl_version = "v{}.{}.{}".format(versions["FDL_FW"]["MAJOR"],versions["FDL_FW"]["MINOR"],versions["FDL_FW"]["REV"])
frame_version = "v1.2.4"

read_files = ['','','']
write_files = ['src/latex/content/firmware.tex', 'src/latex/content/gtl.tex', 'src/latex/content/fdl.tex']

# remove existing write_files
for idx, item in enumerate(write_files):
    read_files[idx] = write_files[idx].split('.')[0]+'_tmpl.tex'
    if item:
        command = f'bash -c "rm {script_file_dir}/{item}"'
        run_command(command)

# open read_files (templates) for replacement of replacement strings
gt_repl_str = "++gtversion++"
frame_repl_str = "++frameversion++"
gtl_repl_str = "++gtlversion++"
fdl_repl_str = "++fdlversion++"

for idx, item in enumerate(read_files):
    with open(item) as f_r:
        datafile = f_r.readlines()
    for i, line in enumerate(datafile):
        if frame_repl_str in line:
            write_line = datafile[i].replace(frame_repl_str, frame_version)
        elif fdl_repl_str in line:
            write_line = datafile[i].replace(fdl_repl_str, fdl_version)
        elif gtl_repl_str in line:
            write_line = datafile[i].replace(gtl_repl_str, gtl_version)
        elif gt_repl_str in line:
            write_line = datafile[i].replace(gt_repl_str, gt_version)
        else:
            write_line = datafile[i]
        f_w = open(write_files[idx], "a")
        f_w.write(write_line)
    f_w.close()


command = f'bash -c "cd {script_file_dir}/src/latex; make"'
run_command(command)
