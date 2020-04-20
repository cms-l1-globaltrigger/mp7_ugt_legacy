#!/bin/bash

# Extract Entity 
#
# Repository path   : $HeadURL: https://hbergauer@forge.hephy.oeaw.ac.at/scm/svn/project-cmstrigger/GlobalTriggerUpgrade/doc/latex/gtl_4_emulator/scripts/extract_entities.sh $
# Last committed    : $Revision: 4265 $
# Last changed by   : $Author: bergauer $
# Last changed date : $Date: 2016-01-07 14:35:44 +0100 (Thu, 07 Jan 2016) $
# Description       : This scripts cut out the entity from the giving list and integrate it into latex file
# Usage             : put the vhdl files, which you need to put in your document
# Usage_latex       :\lstinputlisting[language=VHDL,caption=DM interface specification]{interfaces/spytrigs.vhd}

src_dir="../../../../../cactus/trunk/cactusupgrades/projects/ugt/mp7_ugt/firmware/hdl"
#vhdl_files=("mem/spytrig.vhd" "mem/spymems.vhd") # add new files here
# vhdl_files=("dm/dm.vhd" "dsmux/dsmux.vhd" "lmp/lmp.vhd" "rop/rop.vhd" "ad/ad.vhd" "rb/rb.vhd" "tcm/tcm.vhd" "mem/spytrig.vhd" "mem/simspymem.vhd" 
#             "mem/spymem2_algos.vhd" "mem/spymem2_finor.vhd" "mem/spymem3.vhd" "l1asim/l1asim.vhd" "sw_reset/sw_reset.vhd" "dyndl/dynamic_delay_line.vhd"
#                 "rop/address_manager.vhd" "rop/address_fetch_unit.vhd" "rop/mux_word_generator.vhd" "rop/output_logic.vhd" "rop/rop_sw_reg_synchronizer.vhd"
#                 "rop/stretch_unit.vhd" "rop/validity_checker.vhd" "synchronizer/flag_synchronizer.vhd" "fifo/fifo_2c1r1w.vhd" "ram/ram_2c1w1r.vhd"
#                 "gtl/gtl_module_example.vhd" "gtl/calo_conditions.vhd" "gtl/esums_conditions.vhd" "gtl/muon_conditions.vhd" "fdl/fdl_module.vhd") # add new files here
vhdl_files=( 
            "gt_mp7_core/gtl_fdl_wrapper/gtl/calo_conditions.vhd" "gt_mp7_core/gtl_fdl_wrapper/gtl/calo_conditions_v3.vhd"
            "gt_mp7_core/gtl_fdl_wrapper/gtl/muon_conditions.vhd" "gt_mp7_core/gtl_fdl_wrapper/gtl/muon_conditions_v3.vhd"
            "gt_mp7_core/gtl_fdl_wrapper/gtl/esums_conditions.vhd"
            "gt_mp7_core/gtl_fdl_wrapper/gtl/calo_calo_correlation_condition.vhd" "gt_mp7_core/gtl_fdl_wrapper/gtl/calo_muon_correlation_condition.vhd" "gt_mp7_core/gtl_fdl_wrapper/gtl/muon_muon_correlation_condition.vhd" 
            "gt_mp7_core/gtl_fdl_wrapper/gtl/calo_esums_correlation_condition.vhd" "gt_mp7_core/gtl_fdl_wrapper/gtl/muon_esums_correlation_condition.vhd"
            ) 

			
destination_dir="../interfaces"
mkdir -p $destination_dir


for item in ${vhdl_files[*]}
do
	#sed -n '/entity/,/end;/p' < $src_dir/$item > $destination_dir/$(basename $item)
	
	#1. sed deletes everything after the first occurrence of the word "archtecture"
	#2. sed selects only the part between "entity" and "end;"
# 	sed -n '/architecture/q;p' < $src_dir/$item | sed -n '/entity/,/end/p' > $destination_dir/$(basename $item)
## HB 2015-08-20: "^' means "start of line", so "entity" and "architecture" in comments are "skipped"!!!
    sed -n '/^architecture/q;p' < $src_dir/$item | sed -n '/^entity/,/^end/p' > $destination_dir/$(basename $item)
done

# adding gtl_module.vhd from software/l1triggermenu/compiler/trunk/templates
src_dir_2="../../../../../cactus/trunk/cactusprojects/utm/tmVhdlProducer/templates"
vhdl_files_2=("gtl_module.vhd")

for item in ${vhdl_files_2[*]}
do
    sed -n '/^architecture/q;p' < $src_dir_2/$item | sed -n '/^entity/,/end/p' > $destination_dir/$(basename $item)
done

# 
# # use this for record types
vhdl_pkg_files=("lhc_data_pkg.vhd") # add new files here
record_names=("lhc_data_t") # add new records here

for item in ${vhdl_pkg_files[*]}
do
	for record_item in ${record_names[*]}
	do
		sed -n '/type '$record_item' is/,/end/p' < $src_dir/$item > $destination_dir/$record_item.vhd
	done
done
# 
# copy templates for TME
cp ~/cactus/trunk/cactusprojects/utm/tmVhdlProducer/jinjaTemplates/subTemplates/instance_calo_condition_v3.vhd.j2 ../interfaces/instance_calo_condition_v3.vhd.j2
cp ~/cactus/trunk/cactusprojects/utm/tmVhdlProducer/jinjaTemplates/subTemplates/instance_muon_condition_v2.vhd.j2 ../interfaces/instance_muon_condition_v2.vhd.j2
cp ~/cactus/trunk/cactusprojects/utm/tmVhdlProducer/jinjaTemplates/subTemplates/instance_esums_condition.vhd.j2 ../interfaces/instance_esums_condition.vhd.j2
cp ~/cactus/trunk/cactusprojects/utm/tmVhdlProducer/jinjaTemplates/subTemplates/instance_calo_muon_correlation_condition.vhd.j2 ../interfaces/instance_calo_muon_correlation_condition.vhd.j2

