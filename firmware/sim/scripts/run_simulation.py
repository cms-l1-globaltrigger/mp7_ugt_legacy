#philipp wanggo
#20.07.2017
#simultion program
#all credit to Johannes Wittmann and Bernhard Arnold
import xmlmenu
import os, sys
import json
import subprocess
import logging
import argparse
import time, datetime
from threading import Thread

# terminal size
with os.popen('stty size') as fp:
    ts = int(fp.read().split()[1])

failed_red = ("\033[1;31m Failed! \033[0m")
success_green = ("\033[1;32m Success! \033[0m")
ok_green = ("\033[1;32m OK     \033[0m")
ignore_yellow = ("\033[1;33m IGNORE \033[0m")
error_red = ("\033[1;31m ERROR  \033[0m")

#reset = "\033[0m"

DEFAULT_XILINX_PATH = '/opt/xilinx/14.6'#default paths
DEFAULT_MODELSIM_VERSION = '10.3b'
DEFAULT_MODELSIM_INI_TPL = 'modelsim_tpl.ini'

DO_FILE = 'gtl_fdl_wrapper.do'
TB_FILE_TPL = 'testbench/templates/gtl_fdl_wrapper_tb_tpl.vhd'
TB_FILE = 'testbench/gtl_fdl_wrapper_tb.vhd'

INI_FILE_TPL = 'modelsim_tpl.ini'
INI_FILE = 'modelsim.ini'
DO_FILE_TPL = 'scripts/templates/gtl_fdl_wrapper_tpl.do'

mp7_tag = 'cactusupgrades'
algonum = 512#numbers of bits
IGNORED_ALGOS = [
  'L1_FirstBunchInTrain',
  'L1_SecondBunchInTrain',
  ]

def read_file(filename):
    """Returns contents of a file."""
    with open(filename) as fp:
        return fp.read()

def render_template(src, dst, args):
    """Replaces content of file *src* with values of dictionary *args* and writes to file *dst*.
    >>> render_template("template.txt", "sample.txt", { 'foo' : "bar", })
    """
    logging.debug("rendering template %s as %s", src, dst)
    with open(src) as src:
        content = src.read()
    for needle, subst in args.items():
          logging.debug("  replacing `%s' by `%s'", needle, subst)
          content = content.replace(needle, subst)
    with open(dst, 'w') as dst:
        dst.write(content)

def make_testvector(mask, testvectorfile, new_testverctor):#uses mask of the module, testvector file and the path of the new testvector file where the masked testvectors are stored
    with open(testvectorfile) as tvf, open(new_testverctor, 'w') as opf:
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

def run_vsim(module, msgmode, ini_file):#uses class module, arg msgmode and ini file path to start the simulation
    with open(module.results_log, 'w') as logfile:
        cmd = ['vsim', '-c', '-msgmode', msgmode, '-modelsimini', ini_file, '-do', 'do {filename}; quit -f'.format(filename = os.path.join(module.path, DO_FILE))]
        logging.info("starting simulation for module_%d..." % module._id)
        logging.info("executing: %s", ' '.join(['"{0}"'.format(arg) if ' ' in str(arg) else str(arg) for arg in cmd]))
        subprocess.check_call(cmd, stdout = logfile)
    while not os.path.exists(module.results_json): # checks for the json file
        pass
    with open(module.results_json) as fp:
        jsonf = json.load(fp)
    with open(module.results_txt, 'w') as results_txt: # writes to results.txt what bx number triggert which algorithm and how often
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

def parse():
    parser = argparse.ArgumentParser()
    parser.add_argument('--mp7_tag', type=os.path.abspath, help = "path to MP7 tag", required = True)
    parser.add_argument('--menu', metavar = 'path', help = 'menue folder path', type = os.path.abspath, required = True)
    parser.add_argument('--testvector', metavar = 'path', help = 'testvector file path')
    parser.add_argument('--output', metavar = 'path', help = '', type = os.path.abspath)
    parser.add_argument('--view-wave', action = 'store_true', help = "shows the waveform")
    parser.add_argument('--wlf', action = 'store_true', help = "no console transcript info, warning and error messages (transcript output to vsim.wlf)")
    parser.add_argument('--xilinx-path', metavar = '<path>', default = DEFAULT_XILINX_PATH, help = "path to xilinx installation, default is `{DEFAULT_XILINX_PATH}'".format(**globals()))
    parser.add_argument('--modelsim', metavar = '<version>', default = DEFAULT_MODELSIM_VERSION, help = "select modelsim version, default is `{DEFAULT_MODELSIM_VERSION}'".format(**globals()))
    parser.add_argument('--config', metavar = '<filename>', default = DEFAULT_MODELSIM_INI_TPL, help = "set modelsim INI template file, default is `{DEFAULT_MODELSIM_INI_TPL}'".format(**globals()))
    parser.add_argument('-v', '--verbose', action = 'store_const',const = logging.DEBUG, help = "enables debug prints to console", default = logging.INFO)
    return parser.parse_args()

def main():
    args = parse()

    sim_dir = os.getenv('SIM_ROOT')
    if not sim_dir:
        raise RuntimeError("var SIM_ROOT is not defined (source setup.sh first!)")#checks if setup.py was executed

    # using SIM_ROOT dir as default output path
    if not args.output:
        args.output = sim_dir

    # Setup console logging
    logging.basicConfig(format = '%(levelname)s: %(message)s', level = args.verbose)

    # Set message mode:
    # wlf => no output to console for transcript info, warning and error messages (transcript output to vsim.wlf).
    # tran => output to console.
    msgmode = 'wlf' if args.wlf else 'tran'

    _base = os.path.basename(os.path.abspath(args.menu))

    menu_filepath = os.path.join(args.menu, ('xml/%s.xml' % (_base)))#gets xmlmenu
    testvector_filepath = os.path.join(args.menu, ('testvectors/TestVector_%s.txt' % (_base)))#gets path to testvector file
    timestamp = time.time()#creates timestamp
    _time = datetime.datetime.fromtimestamp(timestamp).strftime('%Y-%m-%dT%H-%M-%S')#changes time apperance

    base_dir = '%s/sim_results/%s_%s' % (args.output, _time, _base)#creates base directory for later use

    if args.testvector:#checks if testvector file argument is given else uses default path
        testvector_filepath = os.path.abspath(args.testvector)
    if not os.path.exists(menu_filepath):#checks for menu
        raise RuntimeError('Missing %s File' % menu_filepath)#help
    if not os.path.exists(testvector_filepath):#checks for testvector
        raise RuntimeError('Missing %s' % testvector_filepath)#its not working as intended
    if os.path.exists(base_dir):#checks if directory alredy exists
        raise RuntimeError('Directory exist alredy!')

    os.makedirs(base_dir)#makes folders

    menu = xmlmenu.XmlMenu(menu_filepath)


    modules = []
    for _id in range(menu.n_modules):#makes list for each module
        modules.append(Module(menu ,_id, base_dir))

    ini_file = os.path.join(base_dir, INI_FILE)
    render_template(#makes render template
        os.path.join(sim_dir, INI_FILE_TPL),
        ini_file, {
        '{{XILINX_PATH}}' : args.xilinx_path,
        '{{MODELSIM_VERSION}}' : args.modelsim,
    })

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

        module.make_files(sim_dir, args.view_wave, args.mp7_tag, args.menu)#sim_dir, view_wave, mp7_tag, menu_path

    logging.info('finished creating modules and masks')
    logging.info('starting simulations...')

    gtu_settings = os.getenv('GTU_SETTINGS_MODELSIM_INI_VERSION')
    if not gtu_settings:#checks for gtu settings
        raise RuntimeError("GTU settings not set (run gtu-settings-XXX)")

    threads = []
    for module in modules:#makes for all simulations a thread
        thread = Thread(target = run_vsim, args = (module, msgmode, ini_file))
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
        with open(module.results_json) as fp:
            jsonf = json.load(fp)
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

if __name__ == '__main__':
    main()
