#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import argparse
import configparser
import logging
import os
import subprocess
import sys
import urllib.request
import urllib.parse
import urllib.error

import toolbox as tb

from xmlmenu import XmlMenu
from run_simulation_questa import run_simulation_questa

EXIT_SUCCESS = 0
EXIT_FAILURE = 1

BoardAliases = {
    #'mp7_690es': 'r1',
    'mp7xe_690': 'xe',
}

DefaultVivadoVersion = '2019.2'

DefaultBoardType = 'mp7xe_690'
"""Default board type to be used."""

DefaultFirmwareDir = os.path.expanduser("~/work_ipbb")
"""Default output directory for firmware builds."""

DefaultGitlabUrlIPB = 'https://github.com/ipbus/ipbus-firmware.git'
"""Default URL IPB FW repo."""

DefaultIpbbTag = 'v1.4'
"""Default tag IPB FW repo."""

DefaultIpbbVersion = '0.5.2'
"""Default version IPBB."""

DefaultGitlabUrlMP7 = 'https://:@gitlab.cern.ch:8443/hbergaue/mp7.git'
"""Default URL MP7 FW repo."""

DefaultMP7Tag = 'mp7fw_v3_0_0'
"""Default tag MP7 FW repo."""

mp7fw_ugt_suffix = '_mp7_ugt'
"""Suffix for ugt MP7 FW tag (patched files in MP7 FW)."""
"""Example MP7 FW tag for ugt: mp7fw_v3_0_0_mp7_ugt."""

#DefaultGitlabUrlUgt = 'https://:@gitlab.cern.ch:8443/hbergaue/ugt.git'
"""Default URL of gitlab ugt repo."""

#DefaultMenuUrl = 'https://raw.githubusercontent.com/herbberg/l1menus/master'

DefaultQuestasimVersion = '10.7c'

vhdl_snippets = ('algo_index.vhd','gtl_module_instances.vhd','gtl_module_signals.vhd','ugt_constants.vhd')

# For Questa simulation
QuestaSimPathVersion107c = '/opt/mentor/questasim'
QuestaSimPathVersion106a = '/opt/mentor/questa_core_prime_10.6a/questasim'
DefaultQuestaSimLibsName = 'questasimlibs' # generated im $HOME

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

def replace_vhdl_templates(vhdl_snippets_dir, src_fw_dir, dest_fw_dir):
    """Replace VHDL templates with snippets from VHDL Producer."""
    #Read generated VHDL snippets
    logging.info("replace VHDL templates with snippets from VHDL Producer ...")
    replace_map = {
        '{{algo_index}}': tb.read_file(os.path.join(vhdl_snippets_dir, 'algo_index.vhd')),
        '{{ugt_constants}}': tb.read_file(os.path.join(vhdl_snippets_dir, 'ugt_constants.vhd')),
        '{{gtl_module_signals}}': tb.read_file(os.path.join(vhdl_snippets_dir, 'gtl_module_signals.vhd')),
        '{{gtl_module_instances}}': tb.read_file(os.path.join(vhdl_snippets_dir, 'gtl_module_instances.vhd')),
    }

    gtl_fdl_wrapper_dir = os.path.join(src_fw_dir, 'hdl', 'gt_mp7_core', 'gtl_fdl_wrapper')
    gtl_dir = os.path.join(gtl_fdl_wrapper_dir, 'gtl')
    fdl_dir = os.path.join(gtl_fdl_wrapper_dir, 'fdl')

    #Patch VHDL files in IPBB area (
    tb.template_replace(os.path.join(fdl_dir, 'algo_mapping_rop_tpl.vhd'), replace_map, os.path.join(dest_fw_dir, 'algo_mapping_rop.vhd'))
    tb.template_replace(os.path.join(gtl_dir, 'gtl_pkg_tpl.vhd'), replace_map, os.path.join(dest_fw_dir, 'gtl_pkg.vhd'))
    tb.template_replace(os.path.join(gtl_dir, 'gtl_module_tpl.vhd'), replace_map, os.path.join(dest_fw_dir, 'gtl_module.vhd'))

def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('menuname', type=tb.menuname_t, help="L1Menu name (eg. 'L1Menu_Collisions2018_v2_1_0-d1')")
    parser.add_argument('--menuurl', metavar='<path>', required=True, help="L1Menu URL to retrieve files from repo [required]")
    parser.add_argument('--vivado', metavar='<version>', default=DefaultVivadoVersion, type=tb.vivado_t, help="Vivado version to run (default is '{}')".format(DefaultVivadoVersion))
    parser.add_argument('--ipbb', metavar='<version>', default=DefaultIpbbVersion, type=tb.ipbb_version_t, help="IPBus builder version [tag] (default is '{}')".format(DefaultIpbbVersion))
    parser.add_argument('--ipburl', metavar='<path>', default=DefaultGitlabUrlIPB, help="URL of IPB firmware repo (default is '{}')".format(DefaultGitlabUrlIPB))
    parser.add_argument('-i', '--ipb', metavar='<tag>', default=DefaultIpbbTag, help="IPBus firmware repo: tag or branch name (default is '{}')".format(DefaultIpbbTag))
    parser.add_argument('--mp7url', metavar='<path>', default=DefaultGitlabUrlMP7, help="URL of MP7 firmware repo (default is '{}')".format(DefaultGitlabUrlMP7))
    parser.add_argument('--mp7tag', metavar='<path>', default=DefaultMP7Tag, help="MP7 firmware repo: tag name (default is '{}')".format(DefaultMP7Tag))
    parser.add_argument('--ugturl', metavar='<path>', required=True, help="URL of ugt firmware repo [required]")
    parser.add_argument('--ugt', metavar='<path>',required=True, help='ugt firmware repo: tag or branch name [required]')
    parser.add_argument('--build', type=tb.build_str_t, required=True, metavar='<version>', help='menu build version (eg. 0x1001) [required]')
    parser.add_argument('--board', metavar='<type>', default=DefaultBoardType, choices=list(BoardAliases.keys()), help="set board type (default is '{}')".format(DefaultBoardType))
    parser.add_argument('-p', '--path', metavar='<path>', default=DefaultFirmwareDir, type=os.path.abspath, help="fw build path (default is '{}')".format(DefaultFirmwareDir))
    parser.add_argument('--sim', action='store_true', help='running simulation with Questa simulator (before synthesis)')
    parser.add_argument('--simmp7path', metavar='<tag>', help="local MP7 firmware repo [required if sim is set]")
    parser.add_argument('--questasim', type=tb.questasim_t, default=DefaultQuestasimVersion, help = "Questasim version (default is  '{}')".format(DefaultQuestasimVersion))
    parser.add_argument('--questasimlibs', metavar='<path>', default=DefaultQuestaSimLibsName, help = "Questasim Vivado libraries directory name (default: '{}') [useful if sim is set]".format(DefaultQuestaSimLibsName))
    parser.add_argument('--output', metavar = '<path>', help = 'directory for sim results [useful if sim is set]', type = os.path.abspath)
    return parser.parse_args()

def main():
    """Main routine."""

    # Parse command line arguments.
    args = parse_args()

    # Setup console logging
    logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)

    # Check for VIVADO_BASE_DIR
    vivado_base_dir = os.getenv('VIVADO_BASE_DIR')
    if not vivado_base_dir:
        raise RuntimeError("Environment variable 'VIVADO_BASE_DIR' not set. Set with: 'export VIVADO_BASE_DIR=...'")

    # Setup console logging
    logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.DEBUG)

    # Board type taken from mp7url repo name
    board_type_repo_name = os.path.basename(args.mp7url)
    if board_type_repo_name.find(".") > 0:
        board_type = board_type_repo_name.split('.')[0]    # Remove ".git" from repo name
    else:
        board_type = board_type_repo_name

    # Project type taken from ugturl repo name
    project_type_repo_name = os.path.basename(args.ugturl)
    if project_type_repo_name.find(".") > 0:
        project_type = project_type_repo_name.split('.')    # Remove ".git" from repo name
    else:
        project_type = project_type_repo_name

    # Create MP7 tag name for ugt
    mp7fw_ugt = args.mp7tag + mp7fw_ugt_suffix

    #ipbb_dir = os.path.join(args.path, project_type, args.mp7tag, args.menuname, args.build)
    # HB 2019-11-12: inserted mp7_ugt tag and vivado version in directory name and changed order
    vivado_version = "vivado_" + args.vivado
    ipbb_dir = os.path.join(args.path, args.menuname, args.build, project_type, args.ugt, args.mp7tag, vivado_version)

    if os.path.isdir(ipbb_dir):
        raise RuntimeError("build area alredy exists: {}".format(ipbb_dir))

    # Runnig simulation with Questa simulator, if args.sim is set
    if args.sim:
        logging.info("===========================================================================")
        logging.info("running simulation with Questa ...")
        run_simulation_questa(args.simmp7path, args.menuname, args.menuurl, args.vivado, args.questasim, args.questasimlibs, args.output, False, False, False)
    else:
        logging.info("===========================================================================")
        logging.info("no simulation required ...")

    ipbb_version = args.ipbb

    # IPBB commands: creating IPBB area
    cmd_ipbb_init = "ipbb init {ipbb_dir}".format(**locals())
    cmd_ipbb_add_ipb = "ipbb add git {args.ipburl} -b {args.ipb}".format(**locals())
    cmd_ipbb_add_mp7 = "ipbb add git {args.mp7url} -b {mp7fw_ugt}".format(**locals())
    cmd_ipbb_add_ugt = "ipbb add git {args.ugturl} -b {args.ugt}".format(**locals())

    logging.info("===========================================================================")
    logging.info("creating IPBB area ...")
    command = 'bash -c "cd; {cmd_ipbb_init}; cd {ipbb_dir}; {cmd_ipbb_add_ipb} && {cmd_ipbb_add_mp7} && {cmd_ipbb_add_ugt}"'.format(**locals())
    run_command(command)

    logging.info("===========================================================================")
    logging.info("download XML file from L1Menu repository ...")
    xml_name = "{}{}".format(args.menuname, '.xml')
    html_name = "{}{}".format(args.menuname, '.html')
    url_menu = "{}/{}".format(args.menuurl, args.menuname)
    #print "url_menu",url_menu
    # Download XML and HTML files (HTML for buildReporter.py)
    filename = os.path.join(ipbb_dir, 'src', xml_name)
    url = "{url_menu}/xml/{xml_name}".format(**locals())
    download_file_from_url(url, filename)
    menu = XmlMenu(filename)

    filename = os.path.join(ipbb_dir, 'src', html_name)
    url = "{url_menu}/doc/{html_name}".format(**locals())
    download_file_from_url(url, filename)

    # Fetch menu name from path.
    menu_name = menu.name

    if not menu_name.startswith('L1Menu_'):
        raise RuntimeError("Invalid menu name: {}".format(menu_name))

    # Fetch number of menu modules.
    modules = menu.n_modules

    if not modules:
        raise RuntimeError("Menu contains no modules")

    ipbb_src_fw_dir = os.path.abspath(os.path.join(ipbb_dir, 'src', project_type, 'firmware'))

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
        cmd_ipbb_proj_create = "ipbb proj create vivado {module_name} {board_type}:../{project_type}".format(**locals())

        #command = 'bash -c "cd; {cmd_activate_env}; cd {ipbb_dir}; {cmd_ipbb_proj_create}"'.format(**locals())
        command = 'bash -c "cd; cd {ipbb_dir}; {cmd_ipbb_proj_create}"'.format(**locals())
        run_command(command)

        logging.info("===========================================================================")
        logging.info("running IPBB project, synthesis and implementation, creating bitfile for module %s ...", module_id)

        #IPBB commands: running IPBB project, synthesis and implementation, creating bitfile
        cmd_ipbb_project = "ipbb vivado make-project --single" # workaround to prevent "hang-up" in make-project with IPBB v0.5.2
        cmd_ipbb_synth = "ipbb vivado synth"
        cmd_ipbb_impl = "ipbb vivado impl"
        cmd_ipbb_bitfile = "ipbb vivado package"

        #Set variable "module_id" for tcl script (l1menu_files.tcl in uGT_algo.dep)
        command = 'bash -c "cd; source {settings64}; cd {ipbb_dir}/proj/{module_name}; module_id={module_id} {cmd_ipbb_project} && {cmd_ipbb_synth} && {cmd_ipbb_impl} && {cmd_ipbb_bitfile}"'.format(**locals())

        session = "build_{project_type}_{args.build}_{module_id}".format(**locals())
        logging.info("starting screen session '%s' for module %s ...", session, module_id)
        run_command('screen', '-dmS', session, command)

    # list running screen sessions
    logging.info("===========================================================================")
    run_command('screen', '-ls')

    os.chdir(ipbb_dir)

    ## Creating configuration file.
    config = configparser.RawConfigParser()
    config.add_section('environment')
    config.set('environment', 'timestamp', tb.timestamp())
    config.set('environment', 'hostname', tb.hostname())
    config.set('environment', 'username', tb.username())

    config.add_section('menu')
    # Remove "0x" from args.build
    build_raw = args.build.split("x", 1)
    config.set('menu', 'build', build_raw[1])
    # Take args.menuname with distribution number
    config.set('menu', 'name', args.menuname)
    # Location of menu XML file
    menu_xml_loc = "{}/xml/{}.xml".format(url_menu, args.menuname)    
    config.set('menu', 'location', menu_xml_loc)
    config.set('menu', 'modules', modules)

    config.add_section('ipbb')
    config.set('ipbb', 'version', ipbb_version)

    config.add_section('vivado')
    config.set('vivado', 'version', args.vivado)

    config.add_section('firmware')
    config.set('firmware', 'ipburl', args.ipburl)
    config.set('firmware', 'ipbtag', args.ipb)
    config.set('firmware', 'mp7url', args.mp7url)
    config.set('firmware', 'mp7tag', args.mp7tag)
    config.set('firmware', 'mp7fw_ugt', mp7fw_ugt)
    config.set('firmware', 'ugturl', args.ugturl)
    config.set('firmware', 'ugttag', args.ugt)
    config.set('firmware', 'type', project_type)
    config.set('firmware', 'buildarea', ipbb_dir)

    config.add_section('device')
    config.set('device', 'type', args.board)
    config.set('device', 'name', board_type)
    config.set('device', 'alias', BoardAliases[args.board])

    # Writing configuration file
    with open('build_{}.cfg'.format(args.build), 'w') as fp:
        config.write(fp)

    logging.info("created configuration file: %s/build_%s.cfg.", ipbb_dir, args.build)
    logging.info("done.")

if __name__ == '__main__':
    try:
        main()
    except RuntimeError as message:
        logging.error(message)
        sys.exit(EXIT_FAILURE)
    sys.exit(EXIT_SUCCESS)
