"""Run simulation by Philipp Wanggo, credit to
Johannes Wittmann and Bernhard Arnold, 20.07.2017
"""

import argparse
import datetime
import json
import logging
import os
import re
import shutil
import subprocess
import sys
import time
import urllib.request
import urllib.parse
import urllib.error

from threading import Thread

import toolbox as tb
import xmlmenu

from ignored_algos import IGNORED_ALGOS

# terminal size
with os.popen('stty size') as fp:
    ts = int(fp.read().split()[1])

failed_red = ("\033[1;31m Failed! \033[0m")
mismatches_exit_red = ("\033[1;31m Mismatches occured !!! Exit on errors \033[0m")
success_green = ("\033[1;32m Success! \033[0m")
ok_green = ("\033[1;32m OK     \033[0m")
ignore_yellow = ("\033[1;33m IGNORE \033[0m")
error_red = ("\033[1;31m ERROR  \033[0m")

# reset = "\033[0m"

QuestaSimPath = os.getenv('UGT_QUESTASIM_SIM_PATH')
if not QuestaSimPath:
    raise RuntimeError("\033[1;31m UGT_QUESTASIM_SIM_PATH is not defined. \033[0m")

DefaultQuestaSimLibsPath = os.getenv('UGT_QUESTASIM_LIBS_PATH')
if not DefaultQuestaSimLibsPath:
    raise RuntimeError("\033[1;31m UGT_QUESTASIM_LIBS_PATH is not defined. \033[0m")

DefaultGitlabUrlIPB = 'https://github.com/ipbus/ipbus-firmware'
"""Default URL IPB FW repo."""

DefaultIpbFwTag = 'v1.4'
"""Default tag IPB FW repo."""

## HB 2022-09-16: using MP7 firmware from "original" repo, patching of MP7 firmware done in this script.
DefaultGitlabUrlMP7 = 'https://gitlab.cern.ch/cms-cactus/firmware/mp7'
"""Default URL MP7 FW repo."""

## HB 2022-10-04: using tag of MP7 firmware "original" repo
DefaultMP7Tag = 'v3.2.2'
"""Default tag MP7 FW repo."""

vhdl_snippets_names = [
    'algo_index',
    'gtl_module_instances',
    'gtl_module_signals',
    'ugt_constants'
]

DO_FILE_TMP = 'gtl_fdl_wrapper_tmp.do'
DO_FILE = 'gtl_fdl_wrapper.do'
TB_FILE_TPL = os.path.join('testbench', 'templates', 'gtl_fdl_wrapper_tb_tpl.vhd')
TB_FILE = os.path.join('testbench', 'gtl_fdl_wrapper_tb.vhd')

INI_FILE = 'modelsim.ini'
DO_FILE_TPL = os.path.join('scripts', 'templates', 'gtl_fdl_wrapper_tpl_questa.do')

mp7_tag = 'cactusupgrades'

algonum = 512  # numbers of bits

# moved IGNORED_ALGOS to "ignored_algos.py" to have an own file for changes in IGNORED_ALGOS list

def run_command(*args):
    command = ' '.join(args)
    logging.info(">$ %s", command)
    os.system(command)

def read_file(filename):
    """Returns contents of a file."""
    with open(filename, 'r') as fp:
        return fp.read()

def render_template(src, dst, args):
    """Replaces content of file *src* with values of dictionary *args* and writes to file *dst*.
    >>> render_template("template.txt", "sample.txt", { 'foo' : "bar", })
    """
    logging.debug("rendering template %s as %s", src, dst)
    with open(src) as f:
        content = f.read()
    for needle, subst in list(args.items()):
        logging.debug("  replacing `%s' by `%s'", needle, subst)
        content = content.replace(needle, subst)
    with open(dst, 'w') as dst:
        dst.write(content)

def make_testvector(mask, testvectorfile, new_testvector):
    """uses mask of the module, testvector file and the path of the new
    testvector file where the masked testvectors are stored"""
    with open(testvectorfile) as tvf, open(new_testvector, 'w') as opf:
        for line in tvf:
            colums = line.strip().split()
            mask_trigger = int(colums[-2], 16) & mask
            colums[-2] = '%0128x' % mask_trigger
            colums[-1] = '1' if mask_trigger else '0'
            opf.write(' '.join(colums))
            opf.write('\n')

def trigger_list(testvectorfile):
    """makes a list of all triggers in testvectorfile eg. [1,0,0,1,0,1,0,0,1,1,1]"""
    out_list = [0] * algonum
    with open(testvectorfile) as tvf:
        for line in tvf:
            colums = line.strip().split()
            trigger_list = bitfield(int(colums[-2], 16))
            out_list = [x + y for x, y in zip(out_list, trigger_list)]
    return out_list


def bitfield(i, n=algonum):
    """converts intager to a list of 'n' bits
    >>> bitfield(10, 4)
    [0, 1, 0, 1]
    """
    return [int(digit) for digit in '{0:0{1}b}'.format(i, n)][::-1]

def run_vsim(vsim, module, msgmode, ini_file):
    """uses class module, arg msgmode and ini file path to start the simulation"""
    vsim_bin = os.path.join(vsim, 'bin', 'vsim')
    with open(module.results_log, 'w') as logfile:
        cmd = [vsim_bin, '-c', '-msgmode', msgmode, '-modelsimini', ini_file, '-do', 'do {filename}; quit -f'.format(filename=os.path.join(module.path, DO_FILE))]
        logging.info("starting simulation for module_%d..." % module._id)
        logging.info("executing: %s", ' '.join(['"{0}"'.format(arg) if ' ' in str(arg) else str(arg) for arg in cmd]))
        subprocess.check_call(cmd, stdout=logfile)
    while not os.path.exists(module.results_json):  # checks for the json file
        pass
    with open(module.results_txt, 'w') as results_txt:  # writes to results.txt what bx number triggert which algorithm and how often
        jsonf = json.load(open(module.results_json))
        errors = jsonf['errors']
        for error in errors:
            results_txt.write('#' * 80 + '\n')
            results_txt.write('bx-nr      = %s\n' % error['bx-nr'])
            results_txt.write('algo_sim   = %s\n' % error['algos_sim'])
            results_txt.write('algo_tv    = %s\n' % error['algos_tv'])
            results_txt.write('fin_or_sim = %s\n' % error['finor_sim'])
            results_txt.write('fin_or_tv  = %s\n' % error['finor_tv'])
            results_txt.write('#' * 80 + '\n')

            algos_sim_bin = bitfield(int(error['algos_sim'], 16))
            algos_tv_bin = bitfield(int(error['algos_tv'], 16))
            logging.debug('-' * ts)

            for bit in range(algonum):
                if algos_tv_bin[bit] != algos_sim_bin[bit]:
                    if module.menu.algorithms.byIndex(bit):  # checks if index has a algorithm name else wirtes not found
                        results_txt.write('\n')
                        results_txt.write('algo %s (%s)\n' % (bit, module.menu.algorithms.byIndex(bit).name))
                        results_txt.write('     tv = %s sim = %s\n' % (algos_tv_bin[bit], algos_sim_bin[bit]))
                        results_txt.write('\n')
                    else:
                        results_txt.write('\n')
                        results_txt.write('algo with index: %s not found in menu\n' % bit)
                        results_txt.write('\n')

        logging.info("finished simulating module_{}".format(module._id))

def check_algocount(liste):
    """prosseses list so module id is in [0] and trgger count in [1] eg. [1, 255]"""
    aus_liste = []
    i = 0
    for index in range(len(liste)):
        if liste[index] != 0:
            aus_liste.append((index, liste[index]))
            i += 1
    if i == 0:
        aus_liste.append((-1, 0))
    return aus_liste


def check_multiple(liste):  # checks if multiple triggers in list
    return True if len(liste) > 1 else False


def logging_debug_write(textfile, string):  # output into textfile and if logging.debug true prints on screen
    textfile.write(string + '\n')
    logging.debug(string)

class Module(object):

    def __init__(self, menu, _id, base_path):
        self._id = _id
        self.testvector = ''
        self.menu = menu
        self.testvector_filepath = ''
        self.path = os.path.join(base_path, 'module_%d' % self._id)
        self.base_path = base_path
        self.vhdl_path = os.path.join(base_path, 'module_%d' % self._id, 'vhdl')
        self.testbench_path = os.path.join(base_path, 'module_%d' % self._id, 'testbench')
        self.results_json = os.path.join(self.path, f'results_module_{self._id:d}.json')
        self.results_log = os.path.join(self.path, f'results_module_{self._id:d}.log')
        self.results_txt = os.path.join(self.path, f'results_module_{self._id:d}.txt')

    def get_mask(self):  # makes mask and saves it
        mask = 0
        for algo in self.menu.algorithms.byModuleId(self._id):
            mask = mask | (1 << algo.index)
        return mask

    def make_files(self, sim_dir, view_wave, mp7_tag, menu_path, ipb_fw_dir):  # makes files for simulation
        render_template(
            os.path.join(sim_dir, DO_FILE_TPL),
            os.path.join(self.path, DO_FILE_TMP),
            {
                '{{MP7_TAG}}': mp7_tag,
                '{{VIEW_WAVE}}': format(view_wave),
                '{{MENU_DIR}}': self.vhdl_path,
                '{{MOD_TB_DIR}}': self.testbench_path,
                '{{SIM_DIR}}': sim_dir,
                '{{IPB_DIR}}': ipb_fw_dir,
            }
        )
        render_template(
            os.path.join(sim_dir, TB_FILE_TPL),
            os.path.join(self.path, TB_FILE), {
                '{{TESTVECTOR_FILENAME}}': self.testvector_filepath,
                '{{RESULTS_FILE}}': self.results_json,
            }
        )

        uGTalgosPath = os.path.abspath(os.path.join(sim_dir, '..'))
        src_dir = os.path.join(menu_path, 'vhdl', f'module_{self._id:d}', 'src')

        replace_map = {
            '{{algo_index}}': read_file(os.path.join(src_dir, 'algo_index.vhd')),
            '{{ugt_constants}}': read_file(os.path.join(src_dir, 'ugt_constants.vhd')),
            '{{gtl_module_signals}}': read_file(os.path.join(src_dir, 'gtl_module_signals.vhd')),
            '{{gtl_module_instances}}': read_file(os.path.join(src_dir, 'gtl_module_instances.vhd')),
        }

        # Patch VHDL files
        render_template(
            os.path.join(uGTalgosPath, 'hdl', 'payload', 'fdl', 'algo_mapping_rop_tpl.vhd'),
            os.path.join(self.path, 'vhdl', 'algo_mapping_rop.vhd'),
            replace_map
        )
        render_template(
            os.path.join(uGTalgosPath, 'hdl', 'packages', 'fdl_pkg_tpl.vhd'),
            os.path.join(self.path, 'vhdl', 'fdl_pkg.vhd'),
            replace_map
        )
        render_template(
            os.path.join(uGTalgosPath, 'hdl', 'payload', 'gtl_module_tpl.vhd'),
            os.path.join(self.path, 'vhdl', 'gtl_module.vhd'),
            replace_map
        )

        # Create 'anomaly_detection.txt' from 'anomaly_detection.dep'
        adt_dep_file = os.path.join(uGTalgosPath, 'cfg', 'anomaly_detection.dep')
        adt_repl = os.path.join(uGTalgosPath, 'cfg', 'anomaly_detection.txt')
        
        with open(adt_dep_file) as fp:
            adt_vhd = fp.read()
        adt_vhd = adt_vhd.replace('src ', 'vcom -93 -work work $HDL_DIR/')
        with open(adt_repl, 'w') as fp:
            fp.write(adt_vhd)
                        
        # Create 'topo_trigger.txt' from 'topo_trigger.dep'
        topo_dep_file = os.path.join(uGTalgosPath, 'cfg', 'topo_trigger.dep')
        topo_repl = os.path.join(uGTalgosPath, 'cfg', 'topo_trigger.txt')
        
        with open(topo_dep_file) as fp:
            topo_vhd = fp.read()
        topo_vhd = topo_vhd.replace('src ', 'vcom -93 -work work $HDL_DIR/')
        with open(topo_repl, 'w') as fp:
            fp.write(topo_vhd)
                        
        # Insert content of 'anomaly_detection.txt' into DO_FILE
        render_template(
            os.path.join(self.path, DO_FILE_TMP),
            os.path.join(self.path, DO_FILE),
            {
                '{{adt_vhd}}': read_file(os.path.join(uGTalgosPath, 'cfg', 'anomaly_detection.txt')),
                '{{topo_vhd}}': read_file(os.path.join(uGTalgosPath, 'cfg', 'topo_trigger.txt')),
            }
        )

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

def run_simulation_questa(a_mp7_url, a_mp7_tag, a_menu, a_url_menu, a_ipb_fw_dir, a_questasimlibs, a_output, a_view_wave, a_wlf, a_verbose, a_tv, a_ignored):

    sim_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'firmware', 'sim')

    # Copy modelsim.ini from questasimlib dir to sim dir (to get questasim libs corresponding to Vivado version)
    source_filename = os.path.join(a_questasimlibs, 'modelsim.ini')
    dest_filename = os.path.join(sim_dir, 'modelsim.ini')
    command = f'bash -c "cp {source_filename} {dest_filename}; chmod ug+w {dest_filename}"'
    #print("command cp modelsim.ini: ", command)
    run_command(command)

    # using SIM_ROOT dir as default output path
    if not a_output:
        a_output = sim_dir

    # Set message mode:
    # wlf => no output to console for transcript info, warning and error messages (transccd -ript output to vsim.wlf).
    # tran => output to console.
    msgmode = 'wlf' if a_wlf else 'tran'

    temp_dir = os.path.join(sim_dir, "temp_dir")
    # Remove existing "temp_dir"
    if os.path.exists(temp_dir):
        command = f'bash -c "rm -rf {temp_dir}"'
        run_command(command)
    os.makedirs(temp_dir)  # makes folders

    logging.info("===========================================================================")
    logging.info("clone repos of MP7 and IPB-firmware to temp_dir ...")

    gitlab_user = os.getenv('UGT_GITLAB_USER_NAME')
    if not gitlab_user:
        raise RuntimeError("\033[1;31m UGT_GITLAB_USER_NAME is not defined. \033[0m")

    gitlab_mp7_url = a_mp7_url.split("//")[1]

    # clone repos of MP7 and IPB-firmware to temp_dir
    command = f'bash -c "cd {temp_dir}; git clone https://{gitlab_user}@{gitlab_mp7_url}.git mp7; cd {temp_dir}/mp7; git checkout {a_mp7_tag}; cd {temp_dir}; git clone {a_ipb_fw_dir}.git ipbus-firmware"'
    run_command(command)

    if not os.path.exists(os.path.join(temp_dir, "mp7")):
        raise RuntimeError("\033[1;31m mp7 not in temp_dir. \033[0m")
    if not os.path.exists(os.path.join(temp_dir, "ipbus-firmware")):
        raise RuntimeError("\033[1;31m ipbus-firmware not in temp_dir. \033[0m")
    
    ## HB 2022-09-16: patching of MP7 firmware (using MP7 firmware from original repo).
    logging.info("===========================================================================")
    logging.info("patch MP7 firmware for ugt ...")
    command = f'bash -c "cd; python3 {os.path.dirname(os.path.abspath(__file__))}/mp7patch.py {temp_dir}/mp7"'
    run_command(command)
    
    logging.info("===========================================================================")
    logging.info("download XML and testvector file from L1Menu repository ...")
    # Get l1menus_path for URL
    xml_name = "{}{}".format(a_menu, '.xml')
    menu_filepath = os.path.join(temp_dir, xml_name)
    url = os.path.join(a_url_menu, 'xml', xml_name)

    url_menu_split_0 = a_url_menu.split("/")[0]
    if url_menu_split_0 == 'https:':
        download_file_from_url(url, menu_filepath) # retrieve xml file from repo
    else:
        shutil.copyfile(url, menu_filepath) # copy xml file from local path

    #if not os.path.exists(a_tv):
        #raise RuntimeError("\033[1;31m test vector file does not exist. \033[0m")

    tv_name = a_tv.split("/")[-1]
    if not tv_name.split(".")[1]:
        tv_name = "{}{}".format(tv_name, '.txt')

    testvector_filepath = os.path.join(temp_dir, tv_name)
    #shutil.copyfile(a_tv, testvector_filepath)

    tv_split_0 = a_tv.split("/")[0]
    if tv_split_0 == 'https:':
        download_file_from_url(a_tv, testvector_filepath) # retrieve xml file from repo
    else:
        shutil.copyfile(a_tv, testvector_filepath) # copy xml file from local path

    timestamp = time.time()  # creates timestamp
    _time = datetime.datetime.fromtimestamp(timestamp).strftime('%Y-%m-%dT%H-%M-%S')  # changes time apperance

    base_dir = os.path.join(a_output, 'sim_results', f'{_time}_{a_menu}')  # creates base directory for later use

    modules = []
    menu = xmlmenu.XmlMenu(menu_filepath)
    for _id in range(menu.n_modules):  # makes list for each module
        modules.append(Module(menu, _id, base_dir))

    # Get VHDL snippets from menu URL
    for module in modules:
        vhdl_src_path = os.path.join('vhdl', f'module_{module._id:d}', 'src')
        temp_dir_module = os.path.join(temp_dir, vhdl_src_path)
        if not os.path.exists(temp_dir_module):
            os.makedirs(temp_dir_module)  # makes folders
            for vhdl_name in vhdl_snippets_names:
                vhdl_name_ext = vhdl_name + ".vhd"
                vhdl_file_local_path = os.path.join(temp_dir_module, vhdl_name_ext)
                vhdl_file_path = os.path.join(vhdl_src_path, vhdl_name_ext)
                url = os.path.join(a_url_menu, vhdl_file_path)
                if url_menu_split_0 == 'https:':
                    download_file_from_url(url, vhdl_file_local_path) # retrieve xml file from repo
                else:
                    shutil.copyfile(url, vhdl_file_local_path) # copy xml file from local path

    if not os.path.exists(menu_filepath):
        raise RuntimeError('Missing %s File' % menu_filepath)
    if not os.path.exists(testvector_filepath):
        raise RuntimeError('Missing %s' % testvector_filepath)
    if os.path.exists(base_dir):
        raise RuntimeError('Directory already exists!')

    os.makedirs(base_dir)

    ini_file = os.path.join(sim_dir, INI_FILE)

    logging.info('creating Modules and Masks...')

    for module in modules:  # gives each module the information
        module_id = 'module_%d' % module._id
        testvector_base_name = os.path.splitext(os.path.basename(testvector_filepath))[0]
        module.testvector_filepath = os.path.join(module.path, '%s_%s.txt' % (testvector_base_name, module_id))

        os.makedirs(os.path.join(module.path, 'testbench'))
        os.makedirs(os.path.join(module.path, 'vhdl'))
        logging.debug('Module_%d: %0128x' % (module._id, module.get_mask()))

        make_testvector(module.get_mask(), testvector_filepath, module.testvector_filepath)  # mask, testvectorfile, out_dir

        logging.debug('Module_%d created at %s' % (module._id, base_dir))

        mp7 = os.path.join(temp_dir, 'mp7')
        ipb_fw = os.path.join(temp_dir, 'ipbus-firmware')

        module.make_files(sim_dir, a_view_wave, mp7, temp_dir, ipb_fw)  # sim_dir, view_wave, mp7_tag, temp_dir

    questasim_path = os.path.join(QuestaSimPath, 'questasim')

    logging.info('finished creating Modules and Masks')
    logging.info("===========================================================================")
    logging.info('starting simulations with Questa Simulator from directory %s', questasim_path)

    threads = []
    for module in modules:  # makes for all simulations a thread
        thread = Thread(target=run_vsim, args=(questasim_path, module, msgmode, ini_file))
        threads.append(thread)
        thread.start()
        while not os.path.exists(os.path.join(module.path, 'running.lock')):  # stops starting of new threads if .do file is still in use
            time.sleep(0.5)
        os.remove(os.path.join(module.path, 'running.lock'))

    for thread in threads:  # waits for all threads to finish
        thread.join()
    logging.info('finished all simulations')
    print('')

    algos_sim = {}
    algos_tv = {}
    error_jsonf = {}
    for i in range(menu.n_modules):
        error_jsonf[i] = False

    for module in modules:  # steps through all modules and makes a list with trigger count and module
        jsonf = json.load(open(module.results_json))
        errors_jsonf = jsonf['errors']
        for err in errors_jsonf:
            if err != "":
                error_jsonf[module._id] = True
        counts = jsonf['counts']
        for count in counts:
            index = count['algo_index']
            if index not in algos_sim:
                algos_sim[index] = []
            algos_sim[index].append(count['algo_sim'])
            if index not in algos_tv:
                algos_tv[index] = []
            algos_tv[index].append(count['algo_tv'])

    for index in range(len(algos_sim)):  # makes a list with tuples (module id, trigger count)
        algos_sim[index] = check_algocount(algos_sim[index])

    for index in range(len(algos_tv)):
        algos_tv[index] = check_algocount(algos_tv[index])

    # Summary logging
    sum_log = logging.getLogger("sum_log")
    sum_log.propagate = False
    handler = logging.StreamHandler(stream=sys.stdout)
    handler.setFormatter(logging.Formatter(fmt='%(message)s'))
    handler.setLevel(logging.DEBUG)
    sum_log.addHandler(handler)

    sum_file = os.path.join(base_dir, 'summary.txt')
    handler = logging.FileHandler(sum_file, mode='w')
    handler.setFormatter(logging.Formatter(fmt='%(message)s'))
    handler.setLevel(logging.DEBUG)
    sum_log.addHandler(handler)

    sum_log.info('Test vector file name: {}'.format(tv_name))
    sum_log.info("|-----|-----|------------------------------------------------------------------|--------|--------|--------|")
    sum_log.info("| Mod | Idx | Name of algorithm                                                | l1a.tv | l1a.hw | Result |")
    sum_log.info("|-----|-----|------------------------------------------------------------------|--------|--------|--------|")
    #      |   1 |   0 | L1_SingleMuCosmics                                               |    86  |     0  | ERROR  |

    algorithms = sorted(menu.algorithms, key=lambda algorithm: algorithm.index)  # sorts all algorithms by index number
    success = True
    err_cnt = 0
    for algo in algorithms:
        result = ok_green
        if algo.name in IGNORED_ALGOS and a_ignored:
            result = ignore_yellow
        # checks if algorithm trigger count is equal in both hardware and testvectors
        elif algos_tv[algo.index][0][1] != algos_sim[algo.index][0][1]:
            err_cnt=err_cnt+1
            result = error_red
            success = False

        sum_log.info('|{:>5}|{:>5}|{:<66}|{:>8}|{:>8}|{:>8}|'.format(   # prints line with information about each algo present in the menu
            algo.module_id,
            algo.index,
            algo.name,
            algos_tv[algo.index][0][1],
            algos_sim[algo.index][0][1],
            result
        ))

    sum_log.info("|-----|-----|------------------------------------------------------------------|--------|--------|--------|")

    json_err_msg = True
    for i in range(len(error_jsonf)):
        if error_jsonf[i]:
            if json_err_msg:
                sum_log.info("\033[1;31m ERROR: mismatches of algos or finor @ certain bx-nr in: \033[0m ".format(i))
                json_err_msg = False
            json_file = os.path.join(base_dir, 'module_{}', 'results_module_{}.json').format(i, i)
            sum_log.info("\033[1;31m {} \033[0m ".format(json_file))

    trigger_liste = trigger_list(testvector_filepath)  # gets a list: index is algorithm index and content is the trigger count in the testvector file

    # prints bits which are present in the testvector but have no corresponding algo in the menu
    errors = []

    for index in range(len(trigger_liste)):
        if menu.algorithms.byIndex(index) is None and trigger_liste[index] > 0:
            errors.append((index, trigger_liste[index]))

    if errors:
        success = False
        sum_log.info("")
        sum_log.info("Found triggers which are not defined in the menu")
        sum_log.info("|-------|--------|")
        sum_log.info("| Index |triggers|")
        sum_log.info("|-------|--------|")
        for index, triggers in errors:
            sum_log.info('|{:>7}|{:>8}|'.format(index, triggers))  # prints all algorithms witch are not in the menu but also triggert for some reason
        sum_log.info("|-------|--------|")

    for index in range(len(algos_sim)):  # checks if algorithm triggert more than once in simulation and testvector file and prints it red on screen
        if check_multiple(algos_sim[index]):
            sum_log.info("Multiple algorithms found in simulation!")
            for i in range(len(algos_sim[index])):
                sum_log.info('Module: {}'.format(algos_sim[index][0][0]))
                sum_log.info('    Index: {}'.format(index))
                sum_log.info('    algoname: {}'.format(menu.algorithms.byIndex(index).name if menu.algorithms.byIndex(index).name else 'not found in menu'))

    for index in range(len(algos_tv)):
        if check_multiple(algos_tv[index]):
            sum_log.info("Multiple algorithms found in testvectors!")
            for i in range(len(algos_tv[index])):
                sum_log.info('Module: {}'.format(algos_tv[index][0][0]))
                sum_log.info('    Index: {}'.format(index))
                sum_log.info('    algoname: {}'.format(menu.algorithms.byIndex(index).name if menu.algorithms.byIndex(index).name else 'not found in menu'))

    print("")

    if not json_err_msg or not success:
        logging.info(failed_red)
    else:
        logging.error(success_green)

    logging.info("===========================================================================")
    logging.info("removed temporary directory ('temp_dir') ...")
    if os.path.exists(os.path.join(sim_dir, "temp_dir")):
        shutil.rmtree(os.path.join(sim_dir, "temp_dir"))

    # remove 'anomaly_detection.txt'
    cfg_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'firmware', 'cfg')
    adt_txt = os.path.join(cfg_dir, 'anomaly_detection.txt')
    topo_txt = os.path.join(cfg_dir, 'topo_trigger.txt')
    command = f'bash -c "rm {adt_txt} {topo_txt}"'
    run_command(command)
        
    if not success:
        logging.info("===========================================================================")
        logging.error(mismatches_exit_red)
        print("\033[1;31m ===> {} error(s) occured! \033[0m".format(err_cnt))
        logging.info("===========================================================================")
        exit(1)

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('menu_xml', help="path to menu xml file (in repository or local")
    parser.add_argument('--tv', required=True, help="Test vector path")
    parser.add_argument('--ignored', action='store_true', default=False, help="using IGNORED_ALGOS for error checks")
    parser.add_argument('--mp7_url', default=DefaultGitlabUrlMP7, help="MP7 repo (default is '{}')".format(DefaultGitlabUrlMP7))
    parser.add_argument('--mp7_repo_tag', default=DefaultMP7Tag, help="MP7 repo tag (default is '{}')".format(DefaultMP7Tag))
    parser.add_argument('--ipb_fw_url', default=DefaultGitlabUrlIPB, help="IPBus firmware repo (default is '{}')".format(DefaultGitlabUrlIPB))
    parser.add_argument('--ipb_fw_repo_tag', default=DefaultIpbFwTag, help="IPBus firmware repo tag (default is '{}')".format(DefaultIpbFwTag))
    parser.add_argument('--questasimlibs', default=DefaultQuestaSimLibsPath, help="Questasim Vivado libraries directory name (default is {})".format(DefaultQuestaSimLibsPath))
    parser.add_argument('--output', metavar='path', type=os.path.abspath, help='path to output directory')
    parser.add_argument('--view_wave', action='store_true', help="shows the waveform")
    parser.add_argument('--wlf', action='store_true', help="no console transcript info, warning and error messages (transcript output to vsim.wlf)")
    parser.add_argument('-v', '--verbose', action='store_const', const=logging.DEBUG, help="enables debug prints to console", default=logging.INFO)
    return parser.parse_args()

def main():
    args = parse_args()

    # Setup console logging
    logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)

    xml_name = args.menu_xml.split("/")[-1]
    menu = xml_name.split(".")[0]
    # check menu name
    tb.menuname_t(menu)
    menu_url = '/'.join(args.menu_xml.split('/')[:-2])

    run_simulation_questa(args.mp7_url, args.mp7_repo_tag, menu, menu_url, args.ipb_fw_url, args.questasimlibs, args.output, args.view_wave, args.wlf, args.verbose, args.tv, args.ignored)

if __name__ == '__main__':
    main()
