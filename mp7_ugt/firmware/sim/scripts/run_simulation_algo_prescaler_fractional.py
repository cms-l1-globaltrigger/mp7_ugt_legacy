import logging
import os, sys
import argparse
import math

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
    parser.add_argument('--questasim', help = "Path to Questasim version [required]", required = True)
    parser.add_argument('--max_dec', help = "max. prescale value (decimal integer) [required]", required = True)
    parser.add_argument('--error_diff', help = "max. difference prescale values (float) [required]", required = True)
    parser.add_argument('--sim_time', help = "simulation time in us [required]", required = True)
    
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
    
    loop = 1
    
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
                    
            # replace {{sim_time}} in do file 
            do_tpl_file = os.path.join(os.environ['PWD'], do_tpl_file_name)
            with open(do_tpl_file, 'r') as f:
                r_strg = f.read()
            w_strg = r_strg.replace('{{sim_time}}', args.sim_time)
            do_file = os.path.join(os.environ['PWD'], do_file_name)
            with open(do_file, 'w') as f:
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

            print ""        
            print "=== Simulation %d/%d [prescale value: %.2f] done" % (loop, max_loops, prescale_value_required)
            print "=== Prescale values difference (simulated - required): %.10f" % diff        
            print ""        

            # check calculated difference
            error_diff = float(args.error_diff)
            if diff > error_diff:
                print "\033[1;31m=== ERROR: Difference > %.6f !!!\033[0m" % error_diff
                print "=== Required rescale value (in testbench):             %.2f" % prescale_value_required
                print "=== Prescale value from simulation:                    %.10f" % prescale_value
                print "=== Prescale valuesdifference (simulated - required): \033[1;31m%.10f\033[0m" % diff        
                print ""        
                exit()
                
            loop = loop + 1
                
    #with open('')
if __name__ == '__main__':
    main()
