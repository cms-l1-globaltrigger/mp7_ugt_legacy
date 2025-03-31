# uGT firmware

Firmware for the CMS Global Trigger (uGT).

This repository contains the algorithm part of the CMS uGT firmware. It has been
written for the Imperial MP7, a Virtex-7 based AMC module.

Documentaion of [uGT firmware](doc/mp7_ugt_firmware_specification/pdf/gt-mp7-firmware-specification.pdf).

The uGT is versioned with the following scheme:

* Major version: Changes in firmware structure, changes that require significant
interventions at P5.
* Minor version: New features for trigger decisions.
* Rev version: Bug fixes, change/add scripts.

In addition there are versions (with similar schemes) for the following firmware
parts of uGT:
* Framework ([frame.vhd](firmware/hdl/payload/frame.vhd))
* Global Trigger Logic ([gtl_module.vhd](firmware/hdl/payload/gtl_module_tpl.vhd))
* Final Decision Logic ([fdl_module.vhd](firmware/hdl/payload/fdl_module.vhd))

Current versions:

| entity | version |
|:-:|:-:|
| uGT FW | v1.31.1 |
| framework | v1.4.2 |
| gt logic | v1.24.1 |
| final decision logic | v1.4.1 |

Following software tool versions used to create L1Menu and menu depended VHDL
files:

| utm | TME | VHDL Producer |
|:-:|:-:|:-:|
| 0.13.0 | 0.17.2 | 2.21.0 |


Following dependencies exist for uGT firmware:

| Repo | Tag |
|:-:|:-:|
| [MP7](https://gitlab.cern.ch/cms-l1-globaltrigger/mp7) | v3.2.2_Vivado2021+_ugt_v4
| [IPBB](https://github.com/ipbus/ipbb) | dev/2023a
| [IPB_FW](https://github.com/ipbus/ipbus-firmware) | v1.4


## Setup environment

First make sure to checkout the branch or tag to work with.

```bash
git clone https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy.git
cd mp7_ugt_legacy
git checkout <branch/tag>
```

If not already done create a Python virtual environment and install all required
dependencies including [IPBB](https://github.com/ipbus/ipbb) and lxml.

```bash
python3 -m venv env
. env/bin/activate
pip install -U pip
pip install -r scripts/requirements.txt
```

A template file for setting up the required environment variables is available
[setup_env_sim_synth_tpl.sh](setup_env_sim_synth_tpl.sh). Copy this file to e.g.
`setup_env_sim_synth.sh`, edit the values for the variables and source the
script.

```bash
. setup_env_sim_synth.sh
```

Example for `setup_env_sim_synth.sh`

```bash
## Simulation (Questasim)
export MODELSIM_ROOT=/opt/mentor/questa/2021.1_2
export MODELSIM_PATH=${MODELSIM_ROOT}/questasim/bin
export PATH=${MODELSIM_PATH}:${PATH}
export MTI_VCO_MODE=64
export MGLS_LICENSE_FILE=1234@license.server
export UGT_GITLAB_USER_NAME=<user name>
export UGT_QUESTASIMLIBS_DIR=<home dir>
export UGT_QUESTASIM_SIM_PATH=${MODELSIM_ROOT}
export UGT_VIVADO_QUESTASIMLIBS_VERSION=2021.2
export UGT_QUESTASIM_LIBS_PATH=<home dir>/questasimlibs
export UGT_BLK_MEM_GEN_VERSION_SIM=blk_mem_gen_v8_4_5

## Synthesis (Vivado)
export VIVADO_BASE_DIR=/opt/Xilinx/Vivado
export UGT_VIVADO_BASE_DIR=${VIVADO_BASE_DIR}
export UGT_VIVADO_VERSION=2021.2
export UGT_BLK_MEM_GEN_VERSION_SYNTH=blk_mem_gen_v8_4_5
source ${VIVADO_BASE_DIR}/${UGT_VIVADO_VERSION}/settings64.sh
```

## Simulation

Simulation of VHDL module `gtl_fdl_wrapper.vhd` with Questa simulator for 6 ugt modules.

* This is a description running script simulation.py in [ugt-fwtools](https://github.com/cms-l1-globaltrigger/ugt-fwtools) with ugt-simulate for simulation.
* If Questasim libraries for a certain Vivado version do not exist, they have to
be created for the selected Questasim version with script ugt-compile-simlib in [ugt-fwtools](https://github.com/cms-l1-globaltrigger/ugt-fwtools):
```bash
ugt-compile-simlib --questasim $UGT_QUESTASIM_SIM_PATH/questasim --output $UGT_QUESTASIM_LIBS_PATH

```

Following table shows which Questasim libraries for a certain Vivado version
have been created and tested (version of IP 'blk_mem_gen' in libraries is
relevant for Global Trigger logic):

| Vivado | blk_mem_gen | 10.7c | 2021.1_2 |
|:-:|:-:|:-:|:-:|
| 2019.2 | v8.4.4 | ok | X |
| 2020.2 | v8.4.4 | X | ok |
| 2021.1 | v8.4.4 | X | ok |
| 2021.2 | v8.4.5 | X | ok |

### Workflow

Be sure that setup of environment is done (see chapter above).

Run simulation using Questa.

*Remarks:*
- MIF files (for mass over deltaR) are located in `mp7_ugt_legacy/firmware/sim`
for simulation.

Running script simulation.py in [ugt-fwtools](https://github.com/cms-l1-globaltrigger/ugt-fwtools) with ugt-simulate.

*Note:* inspect for default values and other arguments

```bash
cd ../ugt-fwtools
python3 -m venv env
. env/bin/activate
ugt-simulate <xml_file> --tv <testvector_file> [--ugttag <ugt tag or branch> --mp7_repo_tag <MP7 repo tag - default is v3.2.2_Vivado2021+_ugt_v4>] [--ignored]
```

Example

```bash
ugt-simulate https://raw.githubusercontent.com/cms-l1-globaltrigger/cms-l1-menu/L1Menu_Collisions2024_v1_3_0-d1/2024/L1Menu_Collisions2024_v1_3_0-d1/xml/L1Menu_Collisions2024_v1_3_0-d1.xml \
 --tv https://raw.githubusercontent.com/cms-l1-globaltrigger/cms-l1-menu/L1Menu_Collisions2024_v1_3_0-d1/2024/L1Menu_Collisions2024_v1_3_0-d1/testvectors/L1menu_2024_v1_3_0_ttBar_TestVector_003.txt \
 --ignored
```

## Build all modules

*Remarks:*
- FW versions greater or equal 0x1150 are used with 2loose muon shower bit (MUS2).
- FW versions greater or equal 0x1130 are used for uGMT v6.1.0 and unpacker (with bug fix for shifted raw eta).
- FW versions greater or equal 0x1120 and lower 0x1130 are used for uGMT v6.0.0_patch1 and unpacker (with bug: shifted raw eta).

The firmware uses the ipbb build tool, and requires the ipbus system firmware.
If you are going to build on a computer outside of the CERN network, then you
will need to run kerberos (kinit username@CERN.CH). These instructions assume
that you have your Xilinx Vivado licensing already setup for your enviroment.

* The ugt repo [mp7 ugt_legacy](https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy) is a fork of [svn2git ugt](https://gitlab.cern.ch/hbergaue/ugt/blob/master/mp7_ugt) repo.
  - added [ugt_strategy.tcl](firmware/ucf/ugt_strategy.tcl) for ugt specific strategy and inserted it into [top.dep](firmware/cfg/top.dep).
  - added [add_l1menu_blkmem_files.tcl](firmware/cfg/add_l1menu_blkmem_files.tcl) for adding L1Menu VHDL files and inserted it into [top.dep](firmware/cfg/top.dep).

* Following scripts are available in [ugt_fwtools](https://github.com/cms-l1-globaltrigger/ugt-fwtools/ugt_fwtools) for firmware sythesis, checking used FPGA resources and packing firmware files:
  - script synthesis.py for IPBB synthesis (all 6 mp7_ugt modules).
  - script checksynth.py for checking used FPGA resources.
  - script fwpacker.py for packing firmware files in a tar file.

* The [MP7](https://gitlab.cern.ch/cms-cactus/firmware/mp7) firmware needs to be adapted for Global Trigger firmware.
* A script makes this changes in the following MP7 files:
  - [area_constraints.tcl](https://gitlab.cern.ch/cms-cactus/firmware/mp7/-/blob/v3.2.2_Vivado2021+_ugt_v4/boards/mp7/base_fw/common/firmware/ucf/area_constraints.tcl)
  - [mp7_brd_decl.vhd](https://gitlab.cern.ch/cms-cactus/firmware/mp7/-/blob/v3.2.2_Vivado2021+_ugt_v4/boards/mp7/base_fw/mp7xe_690/firmware/hdl/mp7_brd_decl.vhd)
  - [mp7xe_690.vhd](https://gitlab.cern.ch/cms-cactus/firmware/mp7/-/blob/v3.2.2_Vivado2021+_ugt_v4/boards/mp7/base_fw/mp7xe_690/firmware/hdl/mp7xe_690.vhd)
* Additionally this script inserts L1A (port l1a) to [mp7_payload.vhd](firmware/hdl/mp7_payload.vhd).
* This script is part of simulation and synthesis workflows (ugt-simulate, ugt-synthesize).

### Workflow

Make sure to setup your local bash environment (see above).

Run kerberos for outside of CERN network.

```bash
kinit <username>@CERN.CH
```

Run synthesis script (for all 6 modules).

*Note:* inspect default values for arguments using

```bash
cd ../ugt-fwtools
python3 -m venv env
. env/bin/activate
ugt-synthesize <xml_file> --ugt <ugt tag or branch> --mp7tag <MP7 repo tag - default is v3.2.2_Vivado2021+_ugt_v4> --build <build_version> -p <working_dir>
```

Example

```bash
ugt-synthesize https://raw.githubusercontent.com/cms-l1-globaltrigger/cms-l1-menu/L1Menu_Collisions2024_v1_3_0-d1/2024/L1Menu_Collisions2024_v1_3_0-d1/xml/L1Menu_Collisions2024_v1_3_0-d1.xml \
 --ugt v1.30.0 \
 --build 0x1192 \
 -p ~/work_synth/production
```

After all syntheses have finished, check results:

```bash
ugt-checksynth <path of build_xxxx.cfg>
```

If timing errors occur (and bit files is not generated), check timing errors in file:

```bash
<project path>/proj/module_<nr>/module_<nr>/module_<nr>.runs/impl_1/top_timing_summary_postroute_physopted.rpt
```

Afterwards execute the following command for every module with timing errors to generate bit file:

```bash
vivado -mode batch -source <path to scripts/vivado_write_bitstream.tcl> -tclargs <project path> <module id>
```

After successfully created bit files, execute the following command to create tar file for HW:

```bash
ugt-fwpacker <path of build_xxxx.cfg>
```

## Build single module

Run kerberos for outside of CERN network

```bash
kinit <username>@CERN.CH
```

If not already done create a Python virtual environment and install all required dependencies including [IPBB](https://github.com/ipbus/ipbb) and lxml.

```bash
python3 -m venv env
. env/bin/activate
pip install -U pip
pip install -r scripts/requirements.txt
```

Create a local working area

```bash
ipbb init <working_area_path>
cd <working_area_path>
ipbb add git https://github.com/ipbus/ipbus-firmware.git -b v1.4
ipbb add git https://:@gitlab.cern.ch:8443/hbergaue/mp7.git -b mp7fw_v3_0_0_mp7_ugt
ipbb add git https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy -b <branch/tag>
```

Copy VHDL producer output and patched files to mp7_ugt (`gtl_module.vhd`, `gtl_pkg.vhd`, `algo_mapping_rop.vhd` and `gt_mp7_top_pkg.vhd`)

Source Vivado

Create project

```bash
ipbb proj create vivado module_<module_id> mp7:../mp7_ugt_legacy
cd proj/module_<module_id>
ipbb vivado make-project --single
```

Run implementation, synthesis

```bash
ipbb vivado synth
ipbb vivado impl
```

Generate a bitfile

```bash
ipbb vivado package
deactivate
```

## Contact

Bernhard Arnold [<bernhard.arnold@cern.ch>]<br>
Herbert Bergauer (Developer - retirement on July 1st 2025) [<herbert.bergauer@oeaw.ac.at>]<br>
Manfred Jeitler [<Manfred.Jeitler@cern.ch>]
