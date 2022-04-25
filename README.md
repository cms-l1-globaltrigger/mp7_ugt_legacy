# uGT firmware

Firmware for the CMS Global Trigger (uGT).

This repository contains the algorithm part of the CMS uGT firmware. It has been written for the Imperial MP7, a Virtex-7 based AMC module.

Documentaion of [uGT firmware](https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy/blob/master/doc/mp7_ugt_firmware_specification/pdf/gt-mp7-firmware-specification.pdf).

The uGT is versioned with the following scheme:

* Major version: Changes in firmware structure, changes that require significant interventions at P5.
* Minor version: New features for trigger decisions.
* Rev version: Bug fixes, change/add scripts.

In addition there are versions (with similar schemes) for the following firmware parts of uGT:
* Framework ([frame.vhd](https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy/blob/master/firmware/hdl/payload/frame.vhd))
* Global Trigger Logic ([gtl_module.vhd](https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy/blob/master/firmware/hdl/payload/gtl_module_tpl.vhd))
* Final Decision Logic ([fdl_module.vhd](https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy/blob/master/firmware/hdl/payload/fdl_module.vhd))

## Instructions for setting up simulation and build environments.

### Setup environment

If not already done create a Python virtual environment and install required dependencies including [IPBB](https://github.com/ipbus/ipbb) and lxml.
```bash
cd <mp7_ugt_legacy_path>
python3 -m venv env>
. env/bin/activate
pip install -U pip
pip install -r <mp7_ugt_legacy_path>/scripts/requirements.txt
```

A template file for setting up the envirionment variables is available (setup_env_sim_synth_tpl.sh). Copy this file to e.g. "setup_env_sim_synth.sh", edit the values for the variables and execute the script with ". setup_env_sim_synth.sh".

Example for "setup_env_sim_synth.sh"

```bash
export UGT_VIVADO_BASE_DIR=/opt/xilinx/Vivado
export UGT_VIVADO_VERSION=2019.2
export MGLS_LICENSE_FILE=1717@heros.hephy.at
export UGT_GITLAB_USER_NAME=hbergaue
export UGT_QUESTASIM_VERSION=10.7c
export UGT_QUESTASIM_SIM_PATH=/opt/mentor
export UGT_VIVADO_QUESTASIMLIBS_VERSION=v2019.2
export UGT_BLK_MEM_GEN_VERSION_SIM=blk_mem_gen_v8_4_4
export UGT_BLK_MEM_GEN_VERSION_SYNTH=blk_mem_gen_v8_4_4
export UGT_QUESTASIM_LIBS_PATH=${UGT_QUESTASIM_SIM_PATH}/questalibs_vivado_${UGT_VIVADO_QUESTASIMLIBS_VERSION}
source ${UGT_VIVADO_BASE_DIR}/${UGT_VIVADO_VERSION}/settings64.sh
```

### Simulate

Simulation of VHDL module "gtl_fdl_wrapper.vhd" with Questa simulator for 6 ugt modules.

* This is a description running script `run_simulation_questa.py` for simulation.
* If Questasim libraries for a certain Vivado version do not exist, they have to be created for the selected Questasim version with script 'run_compile_simlib.py':
```bash
cd <mp7_ugt_legacy_path>
python3 scripts/run_compile_simlib.py --vivado <Vivado version (e.g. 2019.2)> --questasim <Questasim version (e.g. 10.7c)> --output <output directory for generated libraries>
```

Following table shows which Questasim libraries for a certain Vivado version have been created and tested (version of IP 'blk_mem_gen' in libraries is relevant for Global Trigger logic):

| Vivado | blk_mem_gen | 10.7c | 2021.1_2 |
|:-:|:-:|:-:|:-:|
| 2019.2 | v8.4.4 | ok | X |
| 2020.2 | v8.4.4 | X | ok |
| 2021.1 | v8.4.4 | X | ok |
| 2021.2 | v8.4.5 | X | ok |

#### Workflow

Be sure that setup of environment is done (see chapter above).

Run simulation using Questa.

*Remarks:*
- MIF files (for mass over deltaR) are located in 'mp7_ugt_legacy/firmware/sim' for simulation.
- These files have to be in directory from where one runs script "run_simulation_questa.py".
- Change to directory 'mp7_ugt_legacy/firmware/sim' is mandatory.

Running script
```bash
cd <mp7_ugt_legacy_path>
python3 scripts/run_simulation_questa.py <path to menu xml file (in repo or local)> --tv <testvector file path> [--ignored]
```

*Note:* inspect for default values and other arguments
```bash
python3 scripts/run_simulation_questa.py -h
```

Example 1
```bash
cd <mp7_ugt_legacy_path>
python3 scripts/run_simulation_questa.py https://raw.githubusercontent.com/herbberg/l1menus/master/2022/L1Menu_Collisions2022_v0_1_6-d1/xml/L1Menu_Collisions2022_v0_1_6-d1.xml --tv <path>/github/herbberg/l1menus/2022/L1Menu_Collisions2022_v0_1_6-d1/testvectors/TestVector_L1Menu_Collisions2022_v0_1_6.txt --ignored
```

Example 2
```bash
cd <mp7_ugt_legacy_path>
python3 scripts/run_simulation_questa.py <path>/github/herbberg/l1menus/2022/L1Menu_Collisions2022_v0_1_6-d1/xml/L1Menu_Collisions2022_v0_1_6-d1.xml --tv <path>/github/herbberg/l1menus/2022/L1Menu_Collisions2022_v0_1_6-d1/testvectors/TestVector_L1Menu_Collisions2022_v0_1_6.txt --ignored
```

### Build

*Remarks:*
- FW versions greater or equal 0x1130 are used for uGMT v6.1.0 and unpacker (with bug fix for shifted raw eta).
- FW versions greater or equal 0x1120 and lower 0x1130 are used for uGMT v6.0.0_patch1 and unpacker (with bug: shifted raw eta).

#### Build `mp7_ugt` firmware using IPBus builder (IPBB)

The firmware uses the ipbb build tool, and requires the ipbus system firmware. If you are going to build on a computer outside of the CERN network, then you will need to run kerberos (kinit username@CERN.CH). These instructions assume that you have your Xilinx Vivado licensing already setup for your enviroment.

* This is a description with branches of MP7 and ugt repos.
* A fork of [MP7](https://gitlab.cern.ch/cms-cactus/firmware/mp7) firmware is available in [MP74UGT](https://gitlab.cern.ch/hbergaue/mp7) with branch:
  - "mp7fw_v3_0_0_mp7_ugt" created from tag mp7fw_v3_0_0.
* This branch contains patched MP7 files for mp7_ugt_legacy (patched with [mp7patch.py](https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy/scripts/mp7patch.py)):
  - area_constraints.tcl
  - mp7_brd_decl.vhd
  - mp7xe_690.vhd

* The ugt repo [mp7 ugt_legacy](https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy) is a fork of [svn2git ugt](https://gitlab.cern.ch/hbergaue/ugt/blob/master/mp7_ugt) repo.
  - added [ugt_strategy.tcl](https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy/firmware/ucf/ugt_strategy.tcl) for ugt specific strategy and inserted it into [top.dep](https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy/firmware/cfg/top.dep).
  - added [add_l1menu_blkmem_files.tcl](https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy/firmware/cfg/add_l1menu_blkmem_files.tcl) for adding L1Menu VHDL files and inserted it into [top.dep](https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy/firmware/cfg/top.dep).

* Following scripts are available for firmware sythesis, checking used fpga resources and packing firmware files:
  - script [runIpbbSynth.py](https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy/scripts/runIpbbSynth.py) for IPBB synthesis (all 6 mp7_ugt modules).
  - script [checkIpbbSynth.py](https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy/scripts/checkIpbbSynth.py) for checking used fpga resources.
  - script [fwpackerIpbb.py](https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy/scripts/fwpackerIpbb.py) for packing firmware files in a tar file.

#### Workflow

Be sure that setup of environment is done (see chapter above).

Run kerberos for outside of CERN network.
```bash
kinit <username>@CERN.CH
```

Run synthesis script (for all 6 modules).
```bash
cd <mp7_ugt_legacy_path>
python3 scripts/run_synth_ipbb.py <path to menu xml file (in repo or local)> --ugturl <URL ugt git repo> --ugt <ugt tag in repo> --build <build-version> -p <work dir>
```

*Note:* inspect default values for arguments using
```bash
python3 scripts/run_synth_ipbb.py -h
```

Example 1
```bash
cd <mp7_ugt_legacy_path>
python3 scripts/run_synth_ipbb.py https://raw.githubusercontent.com/herbberg/l1menus/master/2022/L1Menu_Collisions2022_v0_1_6-d1/xml/L1Menu_Collisions2022_v0_1_6-d1.xml --ugturl https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy --ugt master --build 0x113d -p /home/bergauer/work_synth/production
```

Example 2
```bash
cd <mp7_ugt_legacy_path>
python3 scripts/run_synth_ipbb.py <path>/github/herbberg/l1menus/2022/L1Menu_Collisions2022_v0_1_6-d1/xml/L1Menu_Collisions2022_v0_1_6-d1.xml --ugturl https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy --ugt master --build 0x113d -p /home/bergauer/work_synth/production
```

#### Setup (commands for one module)

Run kerberos for outside of CERN network
```bash
kinit <username>@CERN.CH
```

If not already done create a Python virtual environment and install required dependencies including [IPBB](https://github.com/ipbus/ipbb) and lxml.
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
ipbb add git https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy -b <master or branch name or tag name>
```

Copy VHDL producer output and patched files to mp7_ugt (`gtl_module.vhd`, `gtl_pkg.vhd`, `algo_mapping_rop.vhd` and `gt_mp7_top_pkg.vhd`)

Source Vivado

Create project
```bash
ipbb proj create vivado module_<module number> mp7:../mp7_ugt_legacy
cd proj/module_<module number>
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
Herbert Bergauer (Developer) [<herbert.bergauer@oeaw.ac.at>]<br>
Manfred Jeitler [<Manfred.Jeitler@cern.ch>]

