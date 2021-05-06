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
# from run_compile_simlib import run_compile_simlib

# terminal size
with os.popen('stty size') as fp:
    ts = int(fp.read().split()[1])

failed_red = ("\033[1;31m Failed! \033[0m")
success_green = ("\033[1;32m Success! \033[0m")
ok_green = ("\033[1;32m OK     \033[0m")
ignore_yellow = ("\033[1;33m IGNORE \033[0m")
error_red = ("\033[1;31m ERROR  \033[0m")

#reset = "\033[0m"

DefaultVivadoVersion = '2019.2'

DefaultQuestasimVersion = '10.7c'

vhdl_snippets_names = ['algo_index', 'gtl_module_instances', 'gtl_module_signals', 'ugt_constants']

url_menu_default = 'https://raw.githubusercontent.com/herbberg/l1menus/master'

DO_FILE = 'gtl_fdl_wrapper.do'
TB_FILE_TPL = 'testbench/templates/gtl_fdl_wrapper_tb_tpl.vhd'
TB_FILE = 'testbench/gtl_fdl_wrapper_tb.vhd'

INI_FILE = 'modelsim.ini'
DO_FILE_TPL = 'scripts/templates/gtl_fdl_wrapper_tpl_questa.do'

QuestaSimPathVersion107c = '/opt/mentor/questasim'
QuestaSimPathVersion106a = '/opt/mentor/questa_core_prime_10.6a/questasim'
DefaultQuestaSimLibsName = 'questalibs_vivado_v' # generated im /opt/mentor/

mp7_tag = 'cactusupgrades'
algonum = 512#numbers of bits
IGNORED_ALGOS = [
  'L1_FirstBunchInTrain',
  'L1_SecondBunchInTrain',
  #'L1_MASSUPT_0_0_10',
  #'L1_MASSUPT_0_0_20',
  #'L1_MASSUPT_0_0_10_open',
  #'L1_MASSUPT_0_0_20_open',
  ]

def run_command(*args):
    command = ' '.join(args)
    logging.info(">$ %s", command)
    os.system(command)

def read_file(filename):
    """Returns contents of a file."""
#    with open(os.path.join(src_dir, 'gtl_module_instances.vhd'), 'rb') as fp:
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

def make_testvector(mask, testvectorfile, new_testvector):#uses mask of the module, testvector file and the path of the new testvector file where the masked testvectors are stored
    with open(testvectorfile) as tvf, open(new_testvector,'w') as opf:
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

def run_vsim(vsim, module, msgmode, ini_file):#uses class module, arg msgmode and ini file path to start the simulation
    vsim_bin = vsim + '/bin/vsim'
    with open(module.results_log,'w') as logfile:
        cmd = [vsim_bin, '-c', '-msgmode', msgmode, '-modelsimini', ini_file, '-do', 'do {filename}; quit -f'.format(filename=os.path.join(module.path, DO_FILE))]
        logging.info("starting simulation for module_%d..." % module._id)
        logging.info("executing: %s", ' '.join(['"{0}"'.format(arg) if ' ' in str(arg) else str(arg) for arg in cmd]))
        subprocess.check_call(cmd, stdout = logfile)
    while not os.path.exists(module.results_json): # checks for the json file
        pass
    with open(module.results_txt, 'w') as results_txt: # writes to results.txt what bx number triggert which algorithm and how often
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
                    if module.menu.algorithms.byIndex(bit):#checks if index has a algorithm name else wirtes not found
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

def check_multiple(liste):#checks if multiple triggers in list
    return True if len(liste) > 1 else False

def logging_debug_write(textfile, string):#output into textfile and if logging.debug true prints on screen
    textfile.write(string + '\n')
    logging.debug(string)

class Module(object):#module class and nessesary information
    def __init__(self, menu, _id, base_path):
        self._id = _id
        self.testvector = ''
        self.menu = menu
        self.testvector_filepath = ''
        self.path = os.path.join(base_path, 'module_%d' % self._id)
        self.base_path = base_path
        self.vhdl_path = os.path.join(base_path, 'module_%d' % self._id, 'vhdl')
        self.testbench_path = os.path.join(base_path, 'module_%d' % self._id, 'testbench')
        self.results_json = '%s/results_module_%d.json' % (self.path, self._id)
        self.results_log = '%s/results_module_%d.log' % (self.path, self._id)
        self.results_txt = '%s/results_module_%d.txt' % (self.path, self._id)

    def get_mask(self):#makes mask and saves it
        mask = 0
        for algo in self.menu.algorithms.byModuleId(self._id):
            mask = mask | (1 << algo.index)
        return mask

    def make_files(self, sim_dir, view_wave, mp7_tag, menu_path):#makes files for simulation
        render_template(os.path.join(sim_dir, DO_FILE_TPL),
            os.path.join(self.path, DO_FILE), {
            '{{MP7_TAG}}' : mp7_tag,
            '{{VIEW_WAVE}}' : format(view_wave),
            '{{MENU_DIR}}' : self.vhdl_path,
            '{{MOD_TB_DIR}}' : self.testbench_path,
            '{{SIM_DIR}}' : sim_dir,
        })
        render_template(os.path.join(sim_dir, TB_FILE_TPL),
            os.path.join(self.path, TB_FILE), {
            '{{TESTVECTOR_FILENAME}}' : self.testvector_filepath,
            '{{RESULTS_FILE}}' : self.results_json,#results.json
        })

        uGTalgosPath = os.path.abspath(os.path.join(sim_dir, '..'))
        src_dir = os.path.join(menu_path, 'vhdl/module_%d/src' % self._id)
        #print "src_dir: ",src_dir

        replace_map = {
            '{{algo_index}}': read_file(os.path.join(src_dir, 'algo_index.vhd')),
            '{{ugt_constants}}': read_file(os.path.join(src_dir, 'ugt_constants.vhd')),
            '{{gtl_module_signals}}': read_file(os.path.join(src_dir, 'gtl_module_signals.vhd')),
            '{{gtl_module_instances}}': read_file(os.path.join(src_dir, 'gtl_module_instances.vhd')),
        }

        gtl_fdl_wrapper_dir = os.path.join(uGTalgosPath, 'hdl', 'gt_mp7_core', 'gtl_fdl_wrapper')
        gtl_dir = os.path.join(gtl_fdl_wrapper_dir, 'gtl')
        fdl_dir = os.path.join(gtl_fdl_wrapper_dir, 'fdl')
        # Patch VHDL files
        render_template(os.path.join(fdl_dir, 'algo_mapping_rop_tpl.vhd'), '%s/vhdl/algo_mapping_rop.vhd' % self.path, replace_map)
        render_template(os.path.join(gtl_dir, 'gtl_pkg_tpl.vhd'), '%s/vhdl/gtl_pkg.vhd' % self.path, replace_map)
        render_template(os.path.join(gtl_dir, 'gtl_module_tpl.vhd'), '%s/vhdl/gtl_module.vhd' % self.path, replace_map)

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

#def run_simulation_questa(a_mp7_tag, a_menu, a_testvector, a_vivado, a_questasim, a_questasimlibs, a_output, a_view_wave, a_wlf, a_verbose):
def run_simulation_questa(a_mp7_tag, a_menu, a_url_menu, a_vivado, a_questasim, a_questasimlibs, a_output, a_view_wave, a_wlf, a_verbose):
    print("a_mp7_tag: ", a_mp7_tag)
    print("a_menu: ", a_menu)
    print("a_url_menu: ", a_url_menu)
    print("a_vivado: ", a_vivado)
    print("a_questasim: ", a_questasim)
    print("a_questasimlibs: ", a_questasimlibs)
    # Check Questa sim version
    if a_questasim == '10.6a':
        questasim_path = QuestaSimPathVersion106a
    elif a_questasim == '10.7c':
        questasim_path = QuestaSimPathVersion107c
    else:
        raise RuntimeError("Questa sim version '%s' does NOT exist" % a_questasim)

    if not os.path.isdir(questasim_path):
        raise RuntimeError("No installation of Questa sim in '%s'" % questasim_path)

    # Set sim_dir
    sim_dir = os.path.join(os.path.dirname(__file__), '../firmware/sim')

    # Copy dofile from gtl_fdl_wrapper_tpl_questa_v<vivado version>.do to gtl_fdl_wrapper_tpl_questa.do
    src_do = os.path.join(sim_dir, 'scripts/templates/gtl_fdl_wrapper_tpl_questa_v{}.do'.format(a_vivado))
    dest_do = os.path.join(sim_dir, 'scripts/templates/gtl_fdl_wrapper_tpl_questa.do')
    shutil.copyfile(src_do, dest_do)

    ## Path to Questa sim libs for selected vivado version
    #questasimlibs_name = a_questasimlibs + a_vivado
    #questasimlib_path = os.path.join('/opt/mentor/', questasimlibs_name)

    #print "questasimlib_path: ", questasimlib_path

    # Copy modelsim.ini from questasimlib dir to sim dir (to get questasim libs corresponding to Vivado version)
    command = 'bash -c "cp /opt/mentor/questasim/modelsim.ini {sim_dir}/modelsim.ini"'.format(**locals())
    print("command cp modelsim.ini: ", command)
    run_command(command)

    ## Run compile Vivado sim libs for Questa (if not exist)
    #run_compile_simlib(a_vivado, questasim_path, questasimlib_path)

    # using SIM_ROOT dir as default output path
    if not a_output:
        a_output = sim_dir

    # Set message mode:
    # wlf => no output to console for transcript info, warning and error messages (transccd -ript output to vsim.wlf).
    # tran => output to console.
    msgmode = 'wlf' if a_wlf else 'tran'

    temp_dir = os.path.join(sim_dir, "temp_dir")
    if not os.path.exists(temp_dir):
        os.makedirs(temp_dir)#makes folders

    logging.info("===========================================================================")
    logging.info("download XML and testvector file from L1Menu repository ...")
    # Get l1menus_path for URL
    #url_menu = "{}/{}".format(url_menu_default, a_menu)
    url_menu = "{}/{}".format(a_url_menu, a_menu)
    print("=== url_menu: ", url_menu)
    xml_name = "{}{}".format(a_menu, '.xml')
    print("=== xml_name: ", xml_name)
    menu_filepath = os.path.join(temp_dir, xml_name)
    print("=== menu_filepath: ", menu_filepath)
    url = "{}/xml/{}".format(url_menu, xml_name)
    print("=== url: ", url)
    download_file_from_url(url, menu_filepath)
    # Remove "distribution number" from a_menu for testvector file name
    tv_name = "TestVector_{}{}".format((re.split("-", a_menu)[0]), '.txt')
    testvector_filepath = os.path.join(temp_dir, tv_name)
    url = "{}/testvectors/{}".format(url_menu, tv_name)
    download_file_from_url(url, testvector_filepath)

    # Get VHDL snippets from menu URL
    #print "menu_filepath: ", menu_filepath
    #print "testvector_filepath: ", testvector_filepath

    timestamp = time.time()#creates timestamp
    _time = datetime.datetime.fromtimestamp(timestamp).strftime('%Y-%m-%dT%H-%M-%S')#changes time apperance

    base_dir = '%s/sim_results/%s_%s' % (a_output, _time, a_menu)#creates base directory for later use

    modules = []
    menu = xmlmenu.XmlMenu(menu_filepath)
    for _id in range(menu.n_modules):#makes list for each module
        modules.append(Module(menu ,_id, base_dir))

    # Get VHDL snippets from menu URL
    for module in modules:
        vhdl_src_path = "vhdl/module_{}/src".format(module._id)
        temp_dir_module = os.path.join(temp_dir, vhdl_src_path)
        if not os.path.exists(temp_dir_module):
            os.makedirs(temp_dir_module)#makes folders
        #print "temp_dir_module: ", temp_dir_module
        for vhdl_name in vhdl_snippets_names:
            vhdl_name_ext = vhdl_name + ".vhd"
            vhdl_file_local_path = os.path.join(temp_dir_module, vhdl_name_ext)
            #print "vhdl_file_local_path: ", vhdl_file_local_path
            vhdl_file_path = os.path.join(vhdl_src_path, vhdl_name_ext)
            url = "{}/{}".format(url_menu, vhdl_file_path)
            #print "url: ", url
            download_file_from_url(url, vhdl_file_local_path)

    if not os.path.exists(menu_filepath):#checks for menu
        raise RuntimeError('Missing %s File' % menu_filepath)#help
    if not os.path.exists(testvector_filepath):#checks for testvector
        raise RuntimeError('Missing %s' % testvector_filepath)#its not working as intended
    if os.path.exists(base_dir):#checks if directory alredy exists
        raise RuntimeError('Directory already exists!')

    os.makedirs(base_dir)#makes folders

    ini_file = os.path.join(sim_dir, INI_FILE)

    logging.info('Creating Modules and Masks...')

    for module in modules:#gives each module the information
        module_id = 'module_%d' % module._id
        testvector_base_name = os.path.splitext(os.path.basename(testvector_filepath))[0]
        module.testvector_filepath = os.path.join(module.path, '%s_%s.txt' %(testvector_base_name, module_id))

        os.makedirs('%s/testbench' % module.path)
        os.makedirs('%s/vhdl' % module.path)
        logging.debug('Module_%d: %0128x' % (module._id, module.get_mask()))

        make_testvector(module.get_mask(), testvector_filepath, module.testvector_filepath)#mask, testvectorfile, out_dir

        logging.debug('Module_%d created at %s' % (module._id, base_dir))

        #module.make_files(sim_dir, a_view_wave, a_mp7_tag, a_menu)#sim_dir, view_wave, mp7_tag, menu_path
        module.make_files(sim_dir, a_view_wave, a_mp7_tag, temp_dir)#sim_dir, view_wave, mp7_tag, temp_dir

    logging.info('finished creating modules and masks')
    logging.info("===========================================================================")
    logging.info('starting simulations with Questa Simulator version %s (from directory %s)'% (a_questasim, questasim_path))

    threads = []
    for module in modules:#makes for all simulations a thread
        thread = Thread(target = run_vsim, args = (questasim_path, module, msgmode, ini_file))
        threads.append(thread)
        thread.start()
        while not os.path.exists(os.path.join(module.path, 'running.lock')):#stops starting of new threads if .do file is still in use
            time.sleep(0.5)
        os.remove(os.path.join(module.path, 'running.lock'))

    for thread in threads:#waits for all threads to finish
        thread.join()
    logging.info('finished all simulations')
    print ('')

    algos_sim = {}
    algos_tv = {}

    for module in modules:#steps through all modules and makes a list with trigger count and module
        jsonf = json.load(open(module.results_json))
        counts = jsonf['counts']
        for count in counts:
            index = count['algo_index']
            if index not in algos_sim:
                algos_sim[index] = []
            algos_sim[index].append(count['algo_sim'])
            if index not in algos_tv:
                algos_tv[index] = []
            algos_tv[index].append(count['algo_tv'])

    for index in range(len(algos_sim)):#makes a list with tuples (module id, trigger count)
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

    sum_log.info("|-----|-----|------------------------------------------------------------------|--------|--------|--------|")
    sum_log.info("| Mod | Idx | Name of algorithm                                                | l1a.tv | l1a.hw | Result |")
    sum_log.info("|-----|-----|------------------------------------------------------------------|--------|--------|--------|")
    #      |   1 |   0 | L1_SingleMuCosmics                                               |    86  |     0  | ERROR  |

    algorithms = sorted(menu.algorithms, key = lambda algorithm: algorithm.index)#sorts all algorithms by index number
    success = True
    for algo in algorithms:
        result = ok_green
        if algo.name in IGNORED_ALGOS:
            result = ignore_yellow
        #checks if algorithm trigger count is equal in both hardware and testvectors
        elif algos_tv[algo.index][0][1] != algos_sim[algo.index][0][1]:
            result = error_red
            success = False

        sum_log.info('|{:>5}|{:>5}|{:<66}|{:>8}|{:>8}|{:>8}|'.format( #prints line with information about each algo present in the menu
            algo.module_id,
            algo.index,
            algo.name,
            algos_tv[algo.index][0][1],
            algos_sim[algo.index][0][1],
            result
        ))

    sum_log.info("|-----|-----|------------------------------------------------------------------|--------|--------|--------|")

    trigger_liste = trigger_list(testvector_filepath)#gets a list: index is algorithm index and content is the trigger count in the testvector file

    # prints bits which are present in the testvector but have no corresponding algo in the menu
    errors=[]

    for index in range(len(trigger_liste)):
        if menu.algorithms.byIndex(index) == None and trigger_liste[index] > 0:
            errors.append((index, trigger_liste[index]))

    if errors:
        success = False
        sum_log.info("")
        sum_log.info("Found triggers which are not defined in the menu")
        sum_log.info("|-------|--------|")
        sum_log.info("| Index |triggers|")
        sum_log.info("|-------|--------|")
        for index, triggers in errors:
            sum_log.info('|{:>7}|{:>8}|'.format(index, triggers))#prints all algorithms witch are not in the menu but also triggert for some reason
        sum_log.info("|-------|--------|")


    for index in range(len(algos_sim)):#checks if algorithm triggert more than once in simulation and testvector file and prints it red on screen
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

    print ("")

    if success:
        logging.info(success_green)
    else:
        logging.error(failed_red)

    logging.info("===========================================================================")
    logging.info("removed temporary directory ('temp_dir') ...")
    if os.path.exists(os.path.join(sim_dir, "temp_dir")):
        shutil.rmtree(os.path.join(sim_dir, "temp_dir"))

def parse():
    parser = argparse.ArgumentParser()
    parser.add_argument('menu', type=tb.menuname_t, help = "menu name (eg. 'L1Menu_Collisions2018_v2_1_0-d1')")
    parser.add_argument('--url', default=url_menu_default, help = "URL of menu")
    parser.add_argument('--mp7_tag', required=True, type=os.path.abspath, help = "local path to MP7 tag (checkout tag before running simulation)")
    parser.add_argument('--vivado', metavar='<version>', default=DefaultVivadoVersion, type=tb.vivado_t, help="Vivado version (default is {})".format(DefaultVivadoVersion))
    parser.add_argument('--questasim', type=tb.questasim_t, default=DefaultQuestasimVersion, help = "Questasim version (default is  {})".format(DefaultQuestasimVersion))
    parser.add_argument('--questasimlibs', default=DefaultQuestaSimLibsName, help = "Questasim Vivado libraries directory name (default: '~/{}')".format(DefaultQuestaSimLibsName))
    parser.add_argument('--output', metavar = 'path', help = '', type = os.path.abspath)
    parser.add_argument('--view-wave', action = 'store_true', help = "shows the waveform")
    parser.add_argument('--wlf', action = 'store_true', help = "no console transcript info, warning and error messages (transcript output to vsim.wlf)")
    parser.add_argument('-v', '--verbose', action = 'store_const', const = logging.DEBUG, help = "enables debug prints to console", default = logging.INFO)
    return parser.parse_args()

def main():
    args = parse()

    # Setup console logging
    logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)

    run_simulation_questa(args.mp7_tag, args.menu, args.url, args.vivado, args.questasim, args.questasimlibs, args.output, args.view_wave, args.wlf, args.verbose)

if __name__ == '__main__':
    main()
