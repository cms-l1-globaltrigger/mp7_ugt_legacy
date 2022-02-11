# uGT firmware

Firmware for the CMS Global Trigger (uGT).

This repository contains the algorithm part of the CMS uGT firmware. It has been written for the Imperial MP7, a Virtex-7 based AMC module.

Documentaion of [uGT firmware](https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy/blob/master/doc/mp7_ugt_firmware_specification/pdf/gt-mp7-firmware-specification.pdf)

The uGT is versioned with the following scheme:

* Major version: Changes in firmware structure, changes that require significant interventions at P5.
* Minor version: New features for trigger decisions.
* Rev version: Bug fixes, change/add scripts.

In addition there are versions (with similar schemes) for the following firmware parts of uGT:
* Framework (frame.vhd)
* Global Trigger Logic (gtl_module.vhd)
* Final Decision Logic (fdl_module.vhd)

## Instructions for setting up the simulation and build environments.

### Simulate

Simulation of VHDL module "gtl_fdl_wrapper" with Questa simulator for 6 ugt modules

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

Make sure that Questasim license file is set (MGLS_LICENSE_FILE).

Set the following environment variables (preferably in `.bashrc`):
| Variable | Description |
|:---------|:------------|
| `UGT_QUESTASIM_VERSION` | Questasim version |
| `UGT_QUESTASIM_SIM_PATH` | Installation directory of Questasim |
| `UGT_QUESTASIM_LIBS_PATH` | Path to Questasim libraries of a certain vivado version |
| `UGT_BLK_MEM_GEN_VERSION` | Version of blk_mem_gen IP for dual port memories (spy memories) and ROMs of LUT values for 1/DR2 (mass over deltaR) |

In addition following environment variables (used in run_simulation_questa.py) must be set in the simulation environment for "automatic" git clone of MP7 firmware:
| Variable | Description |
|:---------|:------------|
| `UGT_GITLAB_USER_NAME` | Gitlab user name |
| `UGT_GITLAB_PWD` | Gitlab password |

Example

```bash
export UGT_QUESTASIM_VERSION=2021.1_2
export UGT_QUESTASIM_SIM_PATH=/opt/mentor/questa/2021.1_2
export UGT_QUESTASIM_LIBS_PATH=/opt/mentor/questasimlibs_vivado_v2021.2
export UGT_BLK_MEM_GEN_VERSION=blk_mem_gen_v8_4_5
```

Clone git ugt repository.
```bash
git clone https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy.git
cd <mp7_ugt_legacy path>
git checkout <branch|tag>
```

Example
```bash
git clone https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy.git
cd mp7_ugt_legacy
git checkout master
```

Example for creating a Questasim environment in bashrc:

```bash
cd <home directory>
python3 -m venv env_questasim
. env_questasim/bin/activate
pip install -U pip
pip install -r <mp7_ugt_legacy_directory>/scripts/requirements.txt
cd <mp7_ugt_legacy directory>
export UGT_BLK_MEM_GEN_VERSION=blk_mem_gen_<blk_mem_gen version (e.g. blk_mem_gen_v8_4_5)>
. firmware/sim/setup.sh
cd firmware/sim
```

If not already done create a Python virtual environment and install required dependencies including [IPBB](https://github.com/ipbus/ipbb) and lxml.
```bash
python3 -m venv <name (e.g. env_questasim)>
. env_questasim/bin/activate
pip install -U pip
pip install -r <mp7_ugt_legacy_path>/scripts/requirements.txt
```

Run simulation using Questa.

**Remarks:**
- MIF files (for mass over deltaR) are located in 'mp7_ugt_legacy/firmware/sim' for simulation.
- These files have to be in directory from where one runs script "run_simulation_questa.py".
- Change to directory 'mp7_ugt_legacy/firmware/sim' is mandatory.

Running script in repo mode
```bash
cd mp7_ugt_legacy/firmware/sim
python3 ../../scripts/run_simulation_questa.py <L1Menu name> --menu_url <URL L1Menu> --tv <testvector file path>
```

**Note:** inspect for default values and other arguments
```bash
python3 ../../scripts/run_simulation_questa.py -h
```

Example
```bash
cd mp7_ugt_legacy/firmware/sim
python3 ../../scripts/run_simulation_questa.py L1Menu_Collisions2020_v0_1_8_disp-d1 --menu_url https://raw.githubusercontent.com/herbberg/l1menus/master/2021 --tv /home/bergauer/github/herbberg/l1menus/2021/L1Menu_Collisions2020_v0_1_8_disp-d1/testvectors/TestVector_L1Menu_Collisions2020_v0_1_8_disp.txt --ignored
```

### Build

**Remarks:**
- FW versions greater or equal 0x1130 are used for uGMT v6.1.0 and unpacker (with bug fix for shifted raw eta).
- FW versions greater or equal 0x1120 and lower 0x1130 are used for uGMT v6.0.0_patch1 and unpacker (with bug: shifted raw eta).

#### Build `mp7_ugt` firmware using IPBB

* This is a draft description with branches of MP7 and ugt repos.
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

#### Setup using script

Set the following environment variables (preferably in `.bashrc`):

| Variable | Description |
|:---------|:------------|
| `UGT_VIVADO_VERSION` | Vivado version |
| `UGT_VIVADO_BASE_DIR` | Installation directory of Vivado version |
| `UGT_BLK_MEM_GEN_VERSION` | Version of blk_mem_gen IP for dual port memories (spy memories) and ROMs of LUT values for 1/DR2 ("mass over deltaR") |

Example

```bash
export UGT_VIVADO_VERSION=2019.2
export UGT_VIVADO_BASE_DIR=/opt/xilinx/Vivado
export UGT_BLK_MEM_GEN_VERSION=blk_mem_gen_v8_4_4
```

Example for creating a Vivado environment in bashrc:

```bash
cd <home directory>
python3 -m venv env_build_ugt_fw
. env_build_ugt_fw/bin/activate
pip install -U pip
pip install -r <mp7_ugt_legacy directory>/scripts/requirements.txt
cd <mp7_ugt_legacy directory>
source ${UGT_VIVADO_BASE_DIR}/${UGT_VIVADO_VERSION}/settings64.sh
export UGT_BLK_MEM_GEN_VERSION=blk_mem_gen_<blk_mem_gen version (e.g. blk_mem_gen_v8_4_4)
```

Run kerberos for outside of CERN network.
```bash
kinit <username>@CERN.CH
```
Make local clone of ugt repositiory.
```bash
git clone https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy.git <local path>/mp7_ugt_legacy
cd <local path>/mp7_ugt_legacy
```

If not already done create a Python virtual environment and install required dependencies including [IPBB](https://github.com/ipbus/ipbb) and lxml.
```bash
python3 -m venv <name (e.g. env_build_ugt_fw)>
. env_build_ugt_fw/bin/activate
pip install -U pip
pip install -r <mp7_ugt_legacy_path>/scripts/requirements.txt
```
Run synthesis script (for all 6 modules).
```bash
python3 scripts/run_synth_ipbb.py <L1Menu name> --menuurl <URL MP7 L1menu repo> --ugturl <URL ugt git repo> --ugt <ugt tag in repo> --build <build-version> -p <work dir>
```

**Note:** inspect default values for arguments using
```bash
python3 scripts/run_synth_ipbb.py -h
```

Example
```bash
python3 scripts/run_synth_ipbb.py L1Menu_Collisions2020_v0_1_8-d1
  --menuurl https://raw.githubusercontent.com/cms-l1-globaltrigger/cms-l1-menu/L1Menu_Collisions2020_v0_1_8-d1/2021
  --ugturl https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy
  --ugt master
  --build 0x1138
  -p ~/work_synth/production/
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

    Bernhard Arnold (bernhard.arnold@cern.ch)
    Herbert Bergauer (herbert.bergauer@oeaw.ac.at) [Developer]
    Manfred Jeitler (Manfred.Jeitler@cern.ch)

