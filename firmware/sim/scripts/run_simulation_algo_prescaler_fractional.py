import logging
import os, sys, re
import argparse
import math

questasimDefaultPath = '/opt/mentor/questasim/bin/vsim' # v10.7c

do_tpl_file_name = 'scripts/algo_pre_scaler_fractional_loop_test_tpl.do'
do_file_name = 'scripts/algo_pre_scaler_fractional_loop_test.do'
pkg_file_name = '../hdl/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_pre_scaler_fractional_pkg.vhd'

find_str = 'PRESCALER_MODE_SEQ_LEN' # in pkg file

error_file_name = 'algo_pre_scaler_fractional_sim_run.log'
rel_sim_path_requ = 'mp7_ugt/firmware/sim'

pwd = os.environ['PWD']

def run_command(*args):
    command = ' '.join(args)
    logging.info(">$ %s", command)
    os.system(command)

def parse():
    parser = argparse.ArgumentParser()
    parser.add_argument('max_dec', type = int, help = "last prescale value in simulation runs (decimal integer) [first is 1]")
    parser.add_argument('max_deviation', type = float, help = "max. allowed deviation in percent (float, max. precision = 6) [eg.: 0.1]")
    parser.add_argument('sim_time', type = int, help = "simulator run time in us")
    parser.add_argument('--questasim', default = questasimDefaultPath, help = "path to Questasim version (default: /opt/mentor/questasim/bin/vsim)")

    return parser.parse_args()

def main():
    args = parse()

    # check sim directory
    rel_sim_path = pwd.split(os.path.sep)[-3:]
    if rel_sim_path != rel_sim_path_requ.split('/'):
        raise RuntimeError("Wrong sim directory, change to '../mp7_ugt/firmware/sim'")

    # check modelsim.ini exists
    if not os.path.isfile(os.path.join(pwd, 'modelsim.ini')):
        raise RuntimeError("No modelsim.ini file in {}".format(pwd))

    # get mode sequence length from "algo_pre_scaler_fractional_pkg.vhd" file
    pkg_file = os.path.join(pwd, pkg_file_name)
    with open(pkg_file) as f:
        for line in f:
            result = re.match('.+{}.+=\s*(\d+);'.format(find_str), line)
            if result:
                prescaler_mode_seq_len = int(result.group(1))
                break

    # check PRESCALER_MODE_SEQ_LEN
    if not (prescaler_mode_seq_len == 1 or prescaler_mode_seq_len == 10 or prescaler_mode_seq_len == 20 or prescaler_mode_seq_len == 100):
        print("\033[1;31m=== ERROR: wrong value for PRESCALER_MODE_SEQ_LEN (= %d) in '../hdl/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_pre_scaler_fractional_pkg.vhd' !!!\033[0m" % prescaler_mode_seq_len)
        exit()

    #sys.exit()

    frac_factor = 100 / prescaler_mode_seq_len
    step_size = 1 / float(prescaler_mode_seq_len)

    whole_value_max = args.max_dec # max. integer value of prescale factor
    max_loops = whole_value_max * prescaler_mode_seq_len # max. simulator loops

    #sys.exit()

    # replace {{sim_time}} in do file
    do_tpl_file = os.path.join(pwd, do_tpl_file_name)
    with open(do_tpl_file) as f:
        r_strg = f.read()
    w_strg = r_strg.replace('{{sim_time}}', str(args.sim_time))
    do_file = os.path.join(pwd, do_file_name)
    with open(do_file, 'w') as f:
        f.write(w_strg)

    print("=== Running Questa simulator for checking prescale values")
    print()

    diff_max = 0.0
    diff_percent_max = 0.0
    prescale_value_diff_percent_max = 0.0
    loop = 1

    for whole in range (1, whole_value_max+1):
        for frac in range (0, prescaler_mode_seq_len):
            prescale_value_required = float(whole + frac * step_size)
            prescale_value_tb = ("%0.2X" % (frac * frac_factor)) + ("%0.6X" % whole)

            # replace constant PRESCALE_FACTOR_VAL in pkg file
            pkg_tpl_file = os.path.join(pwd, 'testbench/algo_pre_scaler_fractional_tb_pkg_tpl.vhd')
            with open(pkg_tpl_file) as f:
                r_strg = f.read()
            w_strg = r_strg.format(prescale_value_tb, prescale_value_required)
            pkg_file = os.path.join(pwd, 'testbench/algo_pre_scaler_fractional_tb_pkg.vhd')
            with open(pkg_file, 'w') as f:
                f.write(w_strg)

            # run simulation
            cmd_vsim = "{} -c -msgmode wlf -modelsimini modelsim.ini -do {} -nostdout -logfile vsim_log.log".format(args.questasim, do_file)
            cmd = 'bash -c "{}"'.format(cmd_vsim)
            run_command(cmd)

            # calculate difference (with prescale values from list.lst (last line)
            list_file = os.path.join(pwd, 'list.lst')
            with open(list_file) as f:
                lines = f.readlines()
            data = lines[len(lines)-1].split()
            algos = data[2]
            prescaled_algos = data[3]
            prescale_value_sim = float(algos)/float(prescaled_algos)
            diff = abs(prescale_value_sim - prescale_value_required)
            diff_percent = float((diff / prescale_value_required) * 100.0)

            print()
            print('=== Prescale value in testbench (and register): \033[1;32mX"{}"\033[0m'.format(prescale_value_tb))
            print("=== Simulation \033[1;32m%d/%d\033[0m [prescale value: \033[1;32m%.2f\033[0m] done" % (loop, max_loops, prescale_value_required))
            print("=== Prescale values difference (simulated minus required): \033[1;32m%.10f\033[0m" % diff)
            print("=== Deviation [in %s]: \033[1;32m%.10f\033[0m" % (chr(37), diff_percent))
            print()

            # check calculated difference
            max_deviation = args.max_deviation
            if diff_percent > max_deviation:
                print("\033[1;31m=== ERROR: Deviation > %.6f %s !!!\033[0m" % (max_deviation, chr(37)))
                print("=== Required rescale value: \033[1;32m%.2f\033[0m" % prescale_value_required)
                print("=== Prescale value from simulation: \033[1;32m%.10f\033[0m" % prescale_value_sim)
                print("=== Prescale values difference (simulated minus required): \033[1;31m%.10f\033[0m" % diff)
                print("=== Deviation [in %s]: \033[1;31m%.10f\033[0m" % (chr(37), diff_percent))
                print()
                error_file = os.path.join(pwd, error_file_name)
                with open(error_file, 'w') as f:
                    f.write("=== ERROR: Deviation > %.6f %s !!!\n" % (max_deviation, chr(37)))
                    f.write("=== Required rescale value: %.2f\n" % prescale_value_required)
                    f.write("=== Prescale value from simulation: %.10f\n" % prescale_value_sim)
                    f.write("=== Prescale values difference (simulated minus required): %.10f\n" % diff)
                    f.write("=== Deviation [in %s]: %.10f\n" % (chr(37), diff_percent))
                exit()

            loop = loop + 1
            if diff > diff_max:
                diff_max = diff
            if diff_percent > diff_percent_max:
                diff_percent_max = diff_percent
                prescale_value_diff_percent_max = prescale_value_required

    print("=== \033[1;32mSuccess !!!\033[0m")
    print("=== Max. deviation [in %s]: \033[1;32m%.5f\033[0m at prescale value \033[1;32m%.2f\033[0m" % (chr(37), diff_percent_max, prescale_value_diff_percent_max))
    error_file = os.path.join(pwd, error_file_name)
    with open(error_file, 'w') as f:
        f.write("=== Success !!! Max. deviation [in %s]: %.5f at prescale value %.2f\n" % (chr(37), diff_percent_max, prescale_value_diff_percent_max))

if __name__ == '__main__':
    main()
