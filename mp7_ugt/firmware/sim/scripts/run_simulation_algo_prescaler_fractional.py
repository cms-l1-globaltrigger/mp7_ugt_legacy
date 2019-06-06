#philipp wanggo
#20.07.2017
#simultion program
#all credit to Johannes Wittmann and Bernhard Arnold
import logging
import os, sys
import math

def run_command(*args):
    command = ' '.join(args)
    logging.info(">$ %s", command)
    os.system(command)

def main():

    #sys.exit()
    #prescale_value_tb_f = 64.25
    #frac, whole = math.modf(prescale_value_tb_f)
    #prescale_value_tb_vector_int = whole
    #prescale_value_tb_vector_frac = frac
    #lut_index = prescale_value_tb_vector_frac / 0.05
    #prescale_value_tb = ("%0.2X" % lut_index) + ("%0.6X" % prescale_value_tb_vector_int)
    #print prescale_value_tb
    
    
    #print prescale_value_tb_vector_frac
    #print "%02x" % lut_index
    #print "%06x" % prescale_value_tb_vector_int
    
    #print "%02x%06x" % (lut_index, prescale_value_tb_vector_int)
    
    #prescale_value_tb = ("%0.2X" % lut_index) + ("%0.6X" % prescale_value_tb_vector_int)
    #print prescale_value_tb
    
    #sys.exit()
    
    print "=== Running Questa simulator for checking prescale values"
    print ""        

    for whole in range (1, 3):
        for frac in range (0, 5):
            prescale_value_tb_f = float(whole + frac * 0.05)
            #print "prescale_value_tb_f: ", prescale_value_tb_f
            prescale_value_tb = ("%0.2X" % frac) + ("%0.6X" % whole)
            #print "prescale_value_tb: ", prescale_value_tb
            
            pkg_tpl_file = os.path.join(os.environ['PWD'], 'testbench/algo_pre_scaler_fractional_tb_pkg_tpl.vhd')
            #print pkg_tpl_file
            with open(pkg_tpl_file, 'r') as f:
                r_strg = f.read()
            w_strg = r_strg.format(prescale_value_tb, prescale_value_tb_f)
            pkg_file = os.path.join(os.environ['PWD'], 'testbench/algo_pre_scaler_fractional_tb_pkg.vhd')
            #print pkg_file
            with open(pkg_file, 'w') as f:
                f.write(w_strg)
                    
            cmd_vsim = "/opt/mentor/questasim/bin/vsim -msgmode wlf -modelsimini modelsim.ini -do scripts/algo_pre_scaler_fractional_no_gui.do"
            cmd = 'bash -c "{}"'.format(cmd_vsim)
            run_command(cmd)

            list_file = os.path.join(os.environ['PWD'], 'list.lst')
            with open(list_file, 'r') as f:
                lines = f.readlines()
            data = lines[len(lines)-1].split()
            #print data
            prescale_value = float(data[2])/float(data[3])
            print "=== Prescale value in testbench:    %.2f" % prescale_value_tb_f
            print "=== Prescale value from simulation: %.10f" % prescale_value
            diff = prescale_value - prescale_value_tb_f
            print "=== Difference:                     %.10f" % diff        
            print ""        
        
    #with open('')
if __name__ == '__main__':
    main()
