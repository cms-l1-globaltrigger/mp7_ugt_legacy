import logging
import os, sys
import argparse
import math

questasimPathDefault = '/opt/mentor/questasim/bin/vsim' # v10.7c

do_tpl_file_name = 'scripts/algo_pre_scaler_fractional_loop_test_tpl.do'
do_file_name = 'scripts/algo_pre_scaler_fractional_loop_test.do'
#do_tpl_file_name = 'scripts/test_tpl.do'
#do_file_name = 'scripts/test.do'

def run_command(*args):
    command = ' '.join(args)
    logging.info(">$ %s", command)
    os.system(command)

def parse():
    parser = argparse.ArgumentParser()
    parser.add_argument('max_dec', help = "end prescale value (decimal integer) [begin at 1]")
    parser.add_argument('max_deviation', help = "max. allowed deviation in percent (float) [eg.: 0.1]")
    parser.add_argument('sim_time', help = "simulator run time in us")
    parser.add_argument('--questasim', default = questasimPathDefault, help = "path to Questasim version (default: /opt/mentor/questasim/bin/vsim)")
    
    return parser.parse_args()

def main():
    args = parse()
    
    if not os.path.isfile(os.path.join(os.environ['PWD'], 'modelsim.ini')):
        raise RuntimeError("No modelsim.ini file in {}".format(os.environ['PWD']))

    print "=== Running Questa simulator for checking prescale values"
    print ""        

    whole_value_max = int(args.max_dec) # max. integer value of prescale factor
    nr_frac_values = 20 # MODE_SEQ_LUT in VHDL with length 20 (fraction values of prescale factor = .00, .05, ...) - floating point precision = 2
    max_loops = whole_value_max * nr_frac_values
    
    diff_max = 0.0
    diff_percent_max = 0.0
    loop = 1
    
    # replace {{sim_time}} in do file 
    do_tpl_file = os.path.join(os.environ['PWD'], do_tpl_file_name)
    with open(do_tpl_file, 'r') as f:
        r_strg = f.read()
    w_strg = r_strg.replace('{{sim_time}}', args.sim_time)
    do_file = os.path.join(os.environ['PWD'], do_file_name)
    with open(do_file, 'w') as f:
        f.write(w_strg)
       
    for whole in range (1, whole_value_max+1):
        for frac in range (0, nr_frac_values):
            prescale_value_required = float(whole + frac * 0.05)
            prescale_value_tb = ("%0.2X" % frac) + ("%0.6X" % whole)
             
            # replace constant PRESCALE_FACTOR_VAL in pkg file 
            pkg_tpl_file = os.path.join(os.environ['PWD'], 'testbench/algo_pre_scaler_fractional_tb_pkg_tpl.vhd')
            with open(pkg_tpl_file, 'r') as f:
                r_strg = f.read()
            w_strg = r_strg.format(prescale_value_tb, prescale_value_required)
            pkg_file = os.path.join(os.environ['PWD'], 'testbench/algo_pre_scaler_fractional_tb_pkg.vhd')
            with open(pkg_file, 'w') as f:
                f.write(w_strg)
                    
            # run simulation 
            cmd_vsim = "{} -c -msgmode wlf -modelsimini modelsim.ini -do {} -nostdout -logfile vsim_log.log".format(args.questasim, do_file)
            cmd = 'bash -c "{}"'.format(cmd_vsim)
            run_command(cmd)

            # calculate difference with prescale values from list.lst (last line)
            list_file = os.path.join(os.environ['PWD'], 'list.lst')
            with open(list_file, 'r') as f:
                lines = f.readlines()
            data = lines[len(lines)-1].split()
            prescale_value = float(data[2])/float(data[3])            
            diff = abs(prescale_value - prescale_value_required)
            diff_percent = float((diff / prescale_value_required) * 100.0)

            print ""        
            print "=== Simulation \033[1;32m%d/%d\033[0m [prescale value: \033[1;32m%.2f\033[0m] done" % (loop, max_loops, prescale_value_required)
            print "=== Prescale values difference (simulated-required): \033[1;32m%.10f\033[0m" % diff        
            print "=== Deviation [in %s]: \033[1;32m%.10f\033[0m" % (chr(37), diff_percent)      
            print ""        

            # check calculated difference
            max_deviation = float(args.max_deviation)
            if diff_percent > max_deviation:
                print "\033[1;31m=== ERROR: Deviation > %.6f % !!!\033[0m" % max_deviation
                print "=== Required rescale value (in testbench): \033[1;32m%.2f\033[0m" % prescale_value_required
                print "=== Prescale value from simulation: \033[1;32m%.10f\033[0m" % prescale_value
                print "=== Prescale values difference (simulated-required): \033[1;31m%.10f\033[0m" % diff        
                print "=== Deviation [in %s]: \033[1;31m%.10f\033[0m" % (chr(37), diff_percent)        
                print ""        
                error_file_name = 'algo_pre_scaler_fractional_error.log'                
                error_file = os.path.join(os.environ['PWD'], error_file_name)
                with open(error_file, 'w') as f:
                    f.write("=== ERROR: Deviation > %.6f % !!!\n" % max_deviation)
                    f.write("=== Required rescale value (in testbench): %.2f\n" % prescale_value_required)
                    f.write("=== Prescale value from simulation: %.10f\n" % prescale_value)
                    f.write("=== Prescale values difference (simulated-required): %.10f\n" % diff)
                    f.write("=== Deviation [in %s]: %.10f\n" % (chr(37), diff_percent))
                exit()
                
            loop = loop + 1
            if diff > diff_max:
                diff_max = diff
            if diff_percent > diff_percent_max:
                diff_percent_max = diff_percent
                prescale_value_diff_percent_max = prescale_value_required
                
    print "=== \033[1;32mSuccess !!!\033[0m"
    print "=== Max. difference: \033[1;32m%.10f\033[0m" % diff_max
    print "=== Max. deviation [in %s]: \033[1;32m%.5f\033[0m at prescale value \033[1;32m%.2f\033[0m" % (chr(37), diff_percent_max, prescale_value_diff_percent_max)
    error_file_name = 'algo_pre_scaler_fractional_error.log'                
    error_file = os.path.join(os.environ['PWD'], error_file_name)
    with open(error_file, 'w') as f:
        f.write("=== Success !!! Max. difference: %.10f\n" % diff_max)
        f.write("=== Success !!! Max. deviation [in %s]: %.5f at %.2f\n" % (chr(37), diff_percent_max, prescale_value_diff_percent_max))
        
    #with open('')
if __name__ == '__main__':
    main()
