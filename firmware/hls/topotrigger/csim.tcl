open_project -reset prj_topo_trigger_sim
set_top topo_trigger
add_files  -tb topo_trigger.cpp -cflags "-std=c++11 -I../"
add_files NN/VAE_HLS.cpp -cflags "-std=c++0x -INN/"
add_files -tb topo_trigger_test.cpp -cflags "-std=c++11 -I../"
add_files -tb test_input.txt

open_solution -reset "solution1"

# the part on MP7 XE 690
set_part {xc7vx690t-ffg1927-2}

# 40 MHZ LHC clock
create_clock -period 25 

csim_design


exit