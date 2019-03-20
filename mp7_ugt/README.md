### Build mp7_ugt firmware with IPBB ###

* This is a draft description with branches of MP7 and ugt repos.
* A fork of [MP7](https://gitlab.cern.ch/cms-cactus/firmware/mp7) firmware is available with three branches:
  - branch "mp7fw_v2_4_1_ugt" created from tag mp7fw_v2_4_1.
  - branch "mp7fw_v2_4_3_ugt" created from tag mp7fw_v2_4_3.
  - branch "mp7fw_master_ugt" created from master.
* These branches contain modified MP7 files for mp7_ugt:
  - area_constraints.tcl
  - mp7_brd_decl.vhd
  - mp7xe_690.vhd
* One of these branches can be used for build (see below).

* The ugt branch [devel](https://gitlab.cern.ch/hbergaue/ugt) is a fork
of [ugt](https://gitlab.cern.ch/cms-cactus/svn2git/firmware) master.
Following modifications are done in the branch:
  - added [ugt_strategy.tcl](https://gitlab.cern.ch/hbergaue/ugt/blob/devel/mp7_ugt/firmware/ucf/ugt_strategy.tcl) for ugt specific strategy and inserted it
into [top.dep](https://gitlab.cern.ch/hbergaue/ugt/blob/devel/mp7_ugt/firmware/cfg/top.dep).
  - modified [uGT_algo.dep](https://gitlab.cern.ch/hbergaue/ugt/blob/devel/mp7_ugt/firmware/cfg/uGT_algo.dep): pointing to ipbus-firmware.

### Setup ###

    # Run kerberos for outside of CERN network
    kinit username@CERN.CH

    # Download and install ipbb
    curl -L https://github.com/ipbus/ipbb/archive/v0.2.8.tar.gz | tar xvz
    source ipbb-0.2.8/env.sh

    # Create a local working area
    ipbb init <build_name>
    cd <build_name>
    ipbb add git https://github.com/ipbus/ipbus-firmware.git -b master
    ipbb add git https://:@gitlab.cern.ch:8443/hbergaue/mp7.git -b mp7fw_v2_4_1_ugt
    ipbb add git https://:@gitlab.cern.ch:8443/hbergaue/ugt.git -b devel

    # Copy VHDL producer output and patched files to mp7_ugt (gtl_module.vhd, gtl_pkg.vhd,
    algo_mapping_rop.vhd and gt_mp7_top_pkg.vhd)

    # Create project 
    ipbb proj create vivado mp7_ugt_<build_version>_<module_nr> mp7:../ugt/mp7_ugt
    cd proj/mp7_ugt_<build_version>_<module_nr>
    ipbb vivado project

    # Run implementation, synthesis
    ipbb vivado synth
    ipbb vivado impl
    
    # Generate a bitfile
    ipbb vivado package
    deactivate

