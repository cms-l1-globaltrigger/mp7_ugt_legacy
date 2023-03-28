open_project -reset prj_topo_trigger
set_top topo_trigger
add_files topo_trigger.cpp -cflags "-std=c++0x -I../"
add_files NN/firmware/topo_trigger.cpp -cflags "-std=c++0x -INN/"

open_solution -reset "solution1"

# the part on MP7 XE 690
set_part {xc7vx690t-ffg1927-2}

# 40 MHZ LHC clock
create_clock -period 25
set_clock_uncertainty 0

config_array_partition -complete_threshold 2

csynth_design

# make ipbb structure and .dep file
set f [open ../../cfg/topo_trigger.dep "w"]

foreach filepath [glob -dir prj_topo_trigger/solution1/syn/vhdl/ *] {
  set filename [file tail $filepath];
  file copy -force prj_topo_trigger/solution1/syn/vhdl/$filename ../../hdl/payload/gtl/topo_trigger/$filename;
  puts $f "src payload/gtl/topo_trigger/$filename"
}
close $f

exit