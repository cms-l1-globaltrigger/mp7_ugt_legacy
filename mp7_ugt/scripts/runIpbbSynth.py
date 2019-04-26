#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import toolbox as tb
import mp7patch

import argparse
import urllib
import shutil
import logging
from distutils.dir_util import copy_tree
import subprocess
import ConfigParser
import sys, os, re
import socket
from xmlmenu import XmlMenu

EXIT_SUCCESS = 0
EXIT_FAILURE = 1

# Set correct FW_TYPE and BOARD_TYPE for each project!
FW_TYPE = 'ugt'
BOARD_TYPE = 'mp7'

BoardAliases = {
    #'mp7_690es': 'r1',
    'mp7xe_690': 'xe',
}

DefaultBoardType = 'mp7xe_690'
"""Default board type to be used."""

DefaultFirmwareDir = os.path.expanduser("~/work_ipbb")
"""Default output directory for firmware builds."""

DefaultGitlabUrlIPB = 'https://github.com/ipbus/ipbus-firmware.git'
"""Default URL of gitlab IPB repo."""

#DefaultGitlabUrlMP7 = 'https://:@gitlab.cern.ch:8443/hbergaue/mp7.git'
"""Default URL of gitlab MP7 repo."""

#DefaultGitlabUrlUgt = 'https://:@gitlab.cern.ch:8443/hbergaue/ugt.git'
"""Default URL of gitlab ugt repo."""

vhdl_snippets = ('algo_index.vhd','gtl_module_instances.vhd','gtl_module_signals.vhd','ugt_constants.vhd')
        
def run_command(*args):
    command = ' '.join(args)
    logging.info(">$ %s", command)
    os.system(command)

def vivado_t(version):
    """Validates Xilinx Vivado version number."""
    if not re.match(r'^\d{4}\.\d+$', version):
        raise ValueError("not a xilinx vivado version: '{version}'".format(**locals()))
    return version

def ipbb_version_t(version):
    """Validates IPBB version number."""
    if not re.match(r'^\d\.\d\.\d+$', version):
        raise ValueError("not a valid IPBB version: '{version}'".format(**locals()))
    return version

def download_file_from_url(url, filename):
    """Download files from URL."""
    # Remove existing file.
    tb.remove(filename)
    # Download file
    logging.info("retrieving %s", url)
    urllib.urlretrieve(url, filename)
    tb.make_executable(filename)

    d = open(filename).read()
    d = d.replace(', default=os.getlogin()', '')
    with open(filename, 'wb') as fp:
        fp.write(d)

def replace_vhdl_templates(vhdl_snippets_dir, ipbb_src_fw_dir, ipbb_dest_fw_dir):
    """Replace VHDL templates with snippets from VHDL Producer."""
    #Read generated VHDL snippets
    logging.info("replace VHDL templates with snippets from VHDL Producer ...")
    replace_map = {
        '{{algo_index}}': tb.read_file(os.path.join(vhdl_snippets_dir, 'algo_index.vhd')),
        '{{ugt_constants}}': tb.read_file(os.path.join(vhdl_snippets_dir, 'ugt_constants.vhd')),
        '{{gtl_module_signals}}': tb.read_file(os.path.join(vhdl_snippets_dir, 'gtl_module_signals.vhd')),
        '{{gtl_module_instances}}': tb.read_file(os.path.join(vhdl_snippets_dir, 'gtl_module_instances.vhd')),
    }

    gtl_fdl_wrapper_dir = os.path.join(ipbb_src_fw_dir, 'hdl', 'gt_mp7_core', 'gtl_fdl_wrapper')
    gtl_dir = os.path.join(gtl_fdl_wrapper_dir, 'gtl')
    fdl_dir = os.path.join(gtl_fdl_wrapper_dir, 'fdl')

    #Patch VHDL files in IPBB area (
    tb.template_replace(os.path.join(fdl_dir, 'algo_mapping_rop_tpl.vhd'), replace_map, os.path.join(ipbb_dest_fw_dir, 'algo_mapping_rop.vhd'))
    tb.template_replace(os.path.join(gtl_dir, 'gtl_pkg_tpl.vhd'), replace_map, os.path.join(ipbb_dest_fw_dir, 'gtl_pkg.vhd'))
    tb.template_replace(os.path.join(gtl_dir, 'gtl_module_tpl.vhd'), replace_map, os.path.join(ipbb_dest_fw_dir, 'gtl_module.vhd'))

def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('vivado', type=vivado_t, help="xilinx vivado version to run, eg. '2018.2'")
    parser.add_argument('--ipbb', metavar='<version>', required=True, type=ipbb_version_t, help="IPBus builder version [tag] (eg. 0.4.3) [is required]")
    parser.add_argument('--ipburl', metavar='<path>', default=DefaultGitlabUrlIPB, help="URL of IPB firmware repo")
    parser.add_argument('-i', '--ipb', metavar='<tag>', default='master', help="IPBus firmware repo: tag or branch name (default is 'master')")
    parser.add_argument('--mp7url', metavar='<path>', required=True, help="URL of MP7 firmware repo")
    parser.add_argument('-t', '--tag', metavar='<tag>', required=True, help="MP7 firmware repo: tag name [is required]")
    parser.add_argument('--mp7tag', metavar='<tag>', required=True, help="MP7 firmware repo: tag or branch for 'ipbb add' [is required]")
    parser.add_argument('--ugturl', metavar='<path>', required=True, help="URL of ugt firmware repo")
    parser.add_argument('-u', '--ugt', metavar='<tag>', required=True, help='ugt firmware repo: tag or branch name [is required]')
    parser.add_argument('--board', metavar='<type>', default=DefaultBoardType, choices=BoardAliases.keys(), help="set board type (default is {})".format(DefaultBoardType))
    parser.add_argument('-p', '--path', metavar='<path>', default=DefaultFirmwareDir, type=os.path.abspath, help="fw build path (default is {})".format(DefaultFirmwareDir))
    parser.add_argument('--menutag', required=True, help="L1Menu repository tag (eg. 'master') [is required]")
    parser.add_argument('--menudir', required=True, help="L1Menu repository directory (eg. 'herbberg/l1menus')[is required]")
    parser.add_argument('--menuname', required=True, help="L1Menu name (eg. 'L1Menu_Collisions2018_v2_1_0-d1')[is required]")
    parser.add_argument('-b', '--build', metavar='<version>', required=True, type=tb.build_t, help='menu build version (eg. 0x1001) [is required]')
    return parser.parse_args()

def main():
    """Main routine."""

    # Parse command line arguments.
    args = parse_args()

    # Setup console logging
    logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.DEBUG)
    
    # Check for VIVADO_BASE_DIR
    vivado_base_dir = os.getenv('VIVADO_BASE_DIR')
    if not vivado_base_dir:
        raise RuntimeError("Environment variable 'VIVADO_BASE_DIR' not set. Set with: 'export VIVADO_BASE_DIR=...'")

    # Compile build root directory
    project_type = "{}_{}".format(BOARD_TYPE, FW_TYPE)
    mp7fw_tag = args.mp7tag
    build_name = "0x{}".format(args.build)
    ipbb_dir = os.path.join(args.path, project_type, args.tag, args.menuname, build_name)

    if os.path.isdir(ipbb_dir):
        raise RuntimeError("build area alredy exists: {}".format(ipbb_dir))
    
    ipbb_version = args.ipbb
    ipbb_version_path = os.path.join(os.getenv("HOME"),"ipbb-{}".format(ipbb_version))
    
    if not os.path.isdir(ipbb_version_path):
        logging.info("execute 'curl' command ...")
        cmd_curl = "curl -L https://github.com/ipbus/ipbb/archive/v{ipbb_version}.tar.gz | tar xvz".format(**locals())
        command = 'bash -c "cd; {cmd_curl}"'.format(**locals())
        run_command(command)
    
    # IPBB commands: creating IPBB area
    cmd_source_ipbb = "source ipbb-{ipbb_version}/env.sh".format(**locals())
    cmd_ipbb_init = "ipbb init {ipbb_dir}".format(**locals())
    cmd_ipbb_add_ipb = "ipbb add git {args.ipburl} -b {args.ipb}".format(**locals())
    cmd_ipbb_add_mp7 = "ipbb add git {args.mp7url} -b {mp7fw_tag}".format(**locals())
    cmd_ipbb_add_ugt = "ipbb add git {args.ugturl} -b {args.ugt}".format(**locals())

    logging.info("===========================================================================")
    logging.info("creating IPBB area ...")
    command = 'bash -c "cd; {cmd_source_ipbb}; {cmd_ipbb_init}; cd {ipbb_dir}; {cmd_ipbb_add_ipb} && {cmd_ipbb_add_mp7} && {cmd_ipbb_add_ugt}"'.format(**locals())
    run_command(command)

    logging.info("===========================================================================")
    logging.info("download XML file from L1Menu repository ...")
    xml_name = "{}{}".format(args.menuname, '.xml')    
    url_menu = "https://raw.githubusercontent.com/{args.menudir}/{args.menutag}/{args.menuname}".format(**locals())
    filename = os.path.join(ipbb_dir, 'src', xml_name)
    url = "{url_menu}/xml/{xml_name}".format(**locals())    
    download_file_from_url(url, filename)
         
    menu = XmlMenu(filename)

    # Fetch menu name from path.
    menu_name = menu.name

    if not menu_name.startswith('L1Menu_'):
        raise RuntimeError("Invalid menu name: {}".format(menu_name))

    # Fetch number of menu modules.
    modules = menu.n_modules

    if not modules:
        raise RuntimeError("Menu contains no modules")

    # Removing unused AMC502 firmware directories
    logging.info("removing src directories of unused firmware ...")
    command = 'bash -c "cd; cd {ipbb_dir}/src/ugt; rm -rf amc502_extcond && rm -rf amc502_finor && rm -rf amc502_finor_pre && rm -rf mp7_tdf"'.format(**locals())
    run_command(command)

    ipbb_src_fw_dir = os.path.abspath(os.path.join(ipbb_dir, 'src', 'ugt', project_type, 'firmware'))
    
    for module_id in range(modules):
        module_name = 'module_{}'.format(module_id)
        ipbb_module_dir = os.path.join(ipbb_dir, module_name)
        
        ipbb_dest_fw_dir = os.path.abspath(os.path.join(ipbb_dir, 'src', module_name))
        os.makedirs(ipbb_dest_fw_dir)

        #Download generated VHDL snippets from repository and replace VHDL templates
        logging.info("===========================================================================")
        logging.info(" *** module %s ***", module_id)
        logging.info("===========================================================================")
        logging.info("download generated VHDL snippets from L1Menu repository for module %s and replace VHDL templates ...", module_id)
        vhdl_snippets_dir = os.path.join(ipbb_dest_fw_dir, 'vhdl_snippets')
        os.makedirs(vhdl_snippets_dir)
        
        for i in range(len(vhdl_snippets)):
            vhdl_snippet = vhdl_snippets[i]
            filename = os.path.join(vhdl_snippets_dir, vhdl_snippet)
            url = "{url_menu}/vhdl/{module_name}/src/{vhdl_snippet}".format(**locals())
            download_file_from_url(url, filename)

        replace_vhdl_templates(vhdl_snippets_dir, ipbb_src_fw_dir, ipbb_dest_fw_dir)        

        logging.info("patch the target package with current UNIX timestamp/username/hostname ...")
        top_pkg_tpl = os.path.join(ipbb_src_fw_dir, 'hdl', 'gt_mp7_top_pkg_tpl.vhd')
        top_pkg = os.path.join(ipbb_src_fw_dir, 'hdl', 'gt_mp7_top_pkg.vhd')
        subprocess.check_call(['python', os.path.join(ipbb_src_fw_dir, '..', 'scripts', 'pkgpatch.py'), '--build', args.build, top_pkg_tpl, top_pkg])

        #Vivado settings
        settings64 = os.path.join(vivado_base_dir, args.vivado, 'settings64.sh')
        if not os.path.isfile(settings64):
            raise RuntimeError(
                "no such Xilinx Vivado settings file '{settings64}'\n" \
                "  check if Xilinx Vivado {args.vivado} is installed on this machine.".format(**locals())
            )

        logging.info("===========================================================================")
        logging.info("creating IPBB project for module %s ...", module_id)
        cmd_ipbb_proj_create = "ipbb proj create vivado {project_type}_{build_name}_{module_id} mp7:../ugt/{project_type}".format(**locals())
        
        command = 'bash -c "cd; {cmd_source_ipbb}; cd {ipbb_dir}; {cmd_ipbb_proj_create}"'.format(**locals())
        run_command(command)
        
        logging.info("===========================================================================")
        logging.info("running IPBB project, synthesis and implementation, creating bitfile for module %s ...", module_id)
        
        #IPBB commands: running IPBB project, synthesis and implementation, creating bitfile
        cmd_ipbb_project = "ipbb vivado project"
        cmd_ipbb_synth = "ipbb vivado synth"
        cmd_ipbb_impl = "ipbb vivado impl"
        cmd_ipbb_bitfile = "ipbb vivado package"
        
        #Set variable "module_id" for tcl script (l1menu_files.tcl in uGT_algo.dep)
        command = 'bash -c "cd; {cmd_source_ipbb}; source {settings64}; cd {ipbb_dir}/proj/{project_type}_{build_name}_{module_id}; module_id={module_id} {cmd_ipbb_project} && {cmd_ipbb_synth} && {cmd_ipbb_impl} && {cmd_ipbb_bitfile}"'.format(**locals())

        session = "build_{project_type}_{build_name}_{module_id}".format(**locals())
        logging.info("starting screen session '%s' for module %s ...", session, module_id)
        run_command('screen', '-dmS', session, command)

    # list running screen sessions
    logging.info("===========================================================================")
    run_command('screen', '-ls')

    os.chdir(ipbb_dir)

    # Creating configuration file.
    config = ConfigParser.RawConfigParser()
    config.add_section('environment')
    config.set('environment', 'timestamp', tb.timestamp())
    config.set('environment', 'hostname', tb.hostname())
    config.set('environment', 'username', tb.username())

    config.add_section('menu')
    config.set('menu', 'build', args.build)
    config.set('menu', 'name', menu_name)
    config.set('menu', 'location', url_menu)
    config.set('menu', 'modules', modules)

    config.add_section('ipbb')
    config.set('ipbb', 'version', ipbb_version)
    
    config.add_section('firmware')
    config.set('firmware', 'ipburl', args.ipburl)
    config.set('firmware', 'ipbtag', args.ipb)
    config.set('firmware', 'mp7url', args.mp7url)
    config.set('firmware', 'mp7tag', mp7fw_tag)
    config.set('firmware', 'tag', args.tag)
    config.set('firmware', 'ugturl', args.ugturl)
    config.set('firmware', 'ugttag', args.ugt)
    config.set('firmware', 'type', FW_TYPE)
    config.set('firmware', 'buildarea', ipbb_dir)

    config.add_section('device')
    config.set('device', 'type', args.board)
    config.set('device', 'name', BOARD_TYPE)
    config.set('device', 'alias', BoardAliases[args.board])

    # Writing configuration file
    with open('build_0x{}.cfg'.format(args.build), 'wb') as fp:
        config.write(fp)

    logging.info("created configuration file: %s/build_0x%s.cfg.", ipbb_dir, args.build)
    logging.info("done.")

if __name__ == '__main__':
    try:
        main()
    except RuntimeError, message:
        logging.error(message)
        sys.exit(EXIT_FAILURE)
    sys.exit(EXIT_SUCCESS)
