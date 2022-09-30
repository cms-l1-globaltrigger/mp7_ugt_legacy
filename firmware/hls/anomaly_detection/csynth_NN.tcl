open_project -reset prj_ad_nn
set_top myproject
add_files NN/myproject.cpp -cflags "-std=c++0x -INN/"

open_solution -reset "solution1"

# the part on MP7 XE 690
set_part {xc7vx690t-ffg1927-2}

# 40 MHZ LHC clock
create_clock -period 25 

csynth_design

exit