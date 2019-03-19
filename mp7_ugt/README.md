### Build mp7_ugt firmware with IPBB ###

* This is a draft description with branches of MP7 and ugt repos.
* The MP7 branch [mp7fw_v2_4_1_ugt](https://gitlab.cern.ch/hbergaue/mp7) is a fork
of [mp7](https://gitlab.cern.ch/cms-cactus/firmware/mp7) firmware tag "mp7fw_v2_4_1".
This branch contains patched MP7 files for mp7_ugt.
* The ugt branch [devel](https://gitlab.cern.ch/hbergaue/ugt) is a fork
of [ugt](https://gitlab.cern.ch/cms-cactus/svn2git/firmware) master.
Added a tcl file (ugt_strategy.tcl) for ugt specific strategy.

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

    # Copy VHDL producer output files to mp7_ugt

    # Create project 
    ipbb proj create vivado mp7_ugt_<build_version>_<module_nr> mp7:../ugt/mp7_ugt
    cd proj/mp7_ugt_<build_version>_<module_nr>
    ipbb vivado project

    # Execute ugt_strategy.tcl
    vivado top/top.xpr -mode batch -source ../../src/ugt/mp7_ugt/firmware/ucf/test.tcl

    # Run implementation, synthesis
    ipbb vivado synth
    ipbb vivado impl
    
    # Generate a bitfile
    ipbb vivado package
    deactivate

