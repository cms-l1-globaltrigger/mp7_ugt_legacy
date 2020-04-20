#!/bin/bash

# Extract Entity 
#
# Repository path   : $HeadURL: svn://heros.hephy.oeaw.ac.at:/GlobalTriggerUpgrade/doc/latex/firmware-specification/scripts/extract_entities.sh $
# Last committed    : $Revision: 2877 $
# Last changed by   : $Author: bergauer $
# Last changed date : $Date: 2014-04-23 10:11:21 +0200 (Wed, 23 Apr 2014) $
# Description       : This scripts cut out the entity from the giving list and integrate it into latex file
# Usage             : put the vhdl files, which you need to put in your document
# Usage_latex       :\lstinputlisting[language=VHDL,caption=DM interface specification]{interfaces/spytrigs.vhd}

#src_dir="/home/bergauer/cactus/trunk/cactusupgrades/projects/ugt/mp7_ugt/firmware/hdl"
src_dir="../../../../../cactus/trunk/cactusupgrades/projects/ugt/mp7_ugt/firmware/hdl"
vhdl_files=(
            "gt_mp7_core/frame/dm/dm.vhd" "gt_mp7_core/frame/dsmux/dsmux.vhd" "gt_mp7_core/frame/lmp/lmp.vhd" 
            "gt_mp7_core/frame/rb/rb.vhd" "gt_mp7_core/frame/tcm/tcm.vhd" "gt_mp7_core/frame/mem/spytrig.vhd"
            "gt_mp7_core/frame/mem/simspymem.vhd" "gt_mp7_core/frame/mem/spymem2_algos.vhd" "gt_mp7_core/frame/mem/spymem2_finor.vhd" "gt_mp7_core/frame/mem/spymem3.vhd"
            "gt_mp7_core/frame/l1asim/l1asim.vhd"
            "gt_mp7_core/frame/sw_reset/sw_reset.vhd"
            "gt_mp7_core/frame/dyndl/dynamic_delay_line.vhd" 
            "gt_mp7_core/frame/rop/rop.vhd" "gt_mp7_core/frame/rop/address_manager.vhd" "gt_mp7_core/frame/rop/address_fetch_unit.vhd"
            "gt_mp7_core/frame/rop/mux_word_generator.vhd" "gt_mp7_core/frame/rop/output_logic.vhd" "gt_mp7_core/frame/rop/rop_sw_reg_synchronizer.vhd" "gt_mp7_core/frame/rop/stretch_unit.vhd"
            "gt_mp7_core/frame/rop/validity_checker.vhd"
            "gt_mp7_core/frame/synchronizer/flag_synchronizer.vhd" 
            "gt_mp7_core/frame/fifo/fifo_2c1r1w.vhd" "gt_mp7_core/frame/ram/ram_2c1w1r.vhd"
            "gt_mp7_core/gtl_fdl_wrapper/gtl/calo_condition_v6_quad.vhd" "gt_mp7_core/gtl_fdl_wrapper/gtl/calo_conditions_v7_no_quad.vhd"
            "gt_mp7_core/gtl_fdl_wrapper/gtl/muon_conditions_v7.vhd"
            "gt_mp7_core/gtl_fdl_wrapper/gtl/esums_conditions.vhd"
            "gt_mp7_core/gtl_fdl_wrapper/gtl/calo_calo_correlation_condition_v4.vhd" "gt_mp7_core/gtl_fdl_wrapper/gtl/calo_muon_correlation_condition_v3.vhd"
            "gt_mp7_core/gtl_fdl_wrapper/gtl/muon_muon_correlation_condition_v4.vhd" "gt_mp7_core/gtl_fdl_wrapper/gtl/calo_esums_correlation_condition_v3.vhd" 
            "gt_mp7_core/gtl_fdl_wrapper/gtl/muon_esums_correlation_condition_v3.vhd" "gt_mp7_core/gtl_fdl_wrapper/gtl/gtl_module_tpl.vhd"
            "gt_mp7_core/gtl_fdl_wrapper/fdl/fdl_module.vhd"
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

# # adding gtl_module.vhd from software/l1triggermenu/compiler/trunk/templates
# src_dir_2="../../../../../cactus/trunk/cactusprojects/utm/tmVhdlProducer/templates"
# vhdl_files_2=("gtl_module.vhd")
# 
# for item in ${vhdl_files_2[*]}
# do
#     sed -n '/^architecture/q;p' < $src_dir_2/$item | sed -n '/^entity/,/end/p' > $destination_dir/$(basename $item)
# done

# use this for record types
vhdl_pkg_files=("lhc_data_pkg.vhd") # add new files here
record_names=("lhc_data_t") # add new records here

for item in ${vhdl_pkg_files[*]}
do
	for record_item in ${record_names[*]}
	do
		sed -n '/type '$record_item' is/,/end/p' < $src_dir/$item > $destination_dir/$record_item.vhd
	done
done

# copy templates for TME
cp ~/cactus/trunk/cactusprojects/utm/tmVhdlProducer/templates/vhdl/instances/calo_condition.vhd.j2 ../interfaces/instance_calo_condition.vhd.j2
cp ~/cactus/trunk/cactusprojects/utm/tmVhdlProducer/templates/vhdl/instances/muon_condition.vhd.j2 ../interfaces/instance_muon_condition.vhd.j2
cp ~/cactus/trunk/cactusprojects/utm/tmVhdlProducer/templates/vhdl/instances/esums_condition.vhd.j2 ../interfaces/instance_esums_condition.vhd.j2
cp ~/cactus/trunk/cactusprojects/utm/tmVhdlProducer/templates/vhdl/instances/calo_calo_correlation_condition.vhd.j2 ../interfaces/instance_calo_calo_correlation_condition.vhd.j2
cp ~/cactus/trunk/cactusprojects/utm/tmVhdlProducer/templates/vhdl/instances/calo_muon_correlation_condition.vhd.j2 ../interfaces/instance_calo_muon_correlation_condition.vhd.j2
cp ~/cactus/trunk/cactusprojects/utm/tmVhdlProducer/templates/vhdl/instances/muon_muon_correlation_condition.vhd.j2 ../interfaces/instance_muon_muon_correlation_condition.vhd.j2


