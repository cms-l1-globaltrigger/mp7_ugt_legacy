## Simulate

Simulation of gtl_fdl_wrapper with Questa simulator for 6 ugt modules

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

### Workflow

Set the following environment variables (preferably in bashrc):
```bash
UGT_QUESTASIM_VERSION - Questasim version (e.g. '2021.1_2')
UGT_QUESTASIM_SIM_PATH - installation directory of Questasim version (e.g. '/opt/mentor/questa/2021.1_2')
UGT_QUESTASIM_LIBS_PATH - path to Questasim libraries of a certain vivado version (e.g. '/opt/mentor/questasimlibs_vivado_v2021.2')
UGT_DP_MEM_VERSION - version of blk_mem_gen for DP_MEM (spy memories), export it in simulation environment (e.g. 'blk_mem_gen_v8_4_5')
UGT_ROM_INV_DR_SQ_VERSION - version of blk_mem_gen for ROMs of LUT values for 1/DR2 (spy memories), export it in simulation environment (e.g. 'blk_mem_gen_v8_4_5')
```

Example for creating a Questasim environment in bashrc:

```bash
alias @questasim='
cd <home directory>;\
python3 -m venv env_questasim;\
. env_questasim/bin/activate;\
pip install -U pip;\
pip install -r <mp7_ugt_legacy directory>/scripts/requirements.txt;\
cd <<mp7_ugt_legacy directory>>;\
export UGT_DP_MEM_VERSION=blk_mem_gen_<blk_mem_gen version (e.g. blk_mem_gen_v8_4_5)>;\
export UGT_ROM_INV_DR_SQ_VERSION=blk_mem_gen_<blk_mem_gen version (e.g. blk_mem_gen_v8_4_5)>;\
. firmware/sim/setup.sh;\
cd firmware/sim;\
```

Clone git repositories for mp7 and ugt.
```bash
git clone https://gitlab.cern.ch/hbergaue/mp7.git
cd mp7
git checkout <tag>
git clone https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy.git
cd mp7_ugt_legacy
git checkout <branch|tag>
```

Example
```bash
git clone https://gitlab.cern.ch/hbergaue/mp7.git
cd mp7
git checkout mp7fw_v3_0_0_mp7_ugt
git clone https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy.git
cd mp7_ugt_legacy
git checkout master
```

If not already done create a Python virtual environment and install required dependencies including [IPBB](https://github.com/ipbus/ipbb) and lxml.
```bash
python3 -m venv <name (e.g. env_questasim)>
. env_questasim/bin/activate
pip install -U pip
pip install -r <mp7_ugt_legacy_path>/scripts/requirements.txt
```

Run simulation using Questa.

REMARK:
- MIF files (for mass over deltaR) are located in 'mp7_ugt_legacy/firmware/sim' for simulation.
- These files have to be in directory from where one runs script "run_simulation_questa.py".
- Change to directory 'mp7_ugt_legacy/firmware/sim' is mandatory.

```bash
cd mp7_ugt_legacy/firmware/sim
python3 ../../scripts/run_simulation_questa.py <L1Menu name> --url <url l1menu> --mp7_tag <local mp7 path> --ipb_fw_dir <local ipbus path>
```

Example
```bash
cd mp7_ugt_legacy/firmware/sim
python3 ../../scripts/run_simulation_questa.py L1Menu_Collisions2020_v0_1_8-d1 \
  --url https://raw.githubusercontent.com/cms-l1-globaltrigger/cms-l1-menu/master/2021 \
  --mp7_tag ~/gitlab/hbergaue/mp7
  --ipb_fw_dir ~/github/ipbus/ipbus-firmware
```

## Build

#### Remarks
- FW versions greater or equal 0x1130 are used for uGMT v6.1.0 and unpacker (with bug fix for shifted raw eta).
- FW versions greater or equal 0x1120 and lower 0x1130 are used for uGMT v6.0.0_patch1 and unpacker (with bug: shifted raw eta).

### Build `mp7_ugt` firmware using IPBB

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

### Setup using script

Set the following environment variables (preferably in bashrc):
```bash
VIVADO_VERSION - Vivado version (e.g. '2019.2')
VIVADO_BASE_DIR - installation directory of Vivado version (e.g. '/opt/xilinx/Vivado')
UGT_DP_MEM_VERSION - version of blk_mem_gen for DP_MEM (spy memories), export it in synthesis environment (e.g. 'blk_mem_gen_v8_4_4')
UGT_ROM_INV_DR_SQ_VERSION - version of blk_mem_gen for ROMs of LUT values of 1/DR2 (spy memories), export it in synthesis environment (e.g. 'blk_mem_gen_v8_4_4')
```
Example for creating a Questasim environment in bashrc:

```bash
alias @fw_ugt_build='
cd <home directory>;\
python3 -m venv env_build_ugt_fw;\
. env_build_ugt_fw/bin/activate;\
pip install -U pip;\
pip install -r <mp7_ugt_legacy directory>/scripts/requirements.txt;\
cd <mp7_ugt_legacy directory>;\
source ${VIVADO_BASE_DIR}/${VIVADO_VERSION}/settings64.sh;\
export UGT_DP_MEM_VERSION=blk_mem_gen_<blk_mem_gen version (e.g. blk_mem_gen_v8_4_2);\
export UGT_ROM_INV_DR_SQ_VERSION=blk_mem_gen_<blk_mem_gen version (e.g. blk_mem_gen_v8_4_4);\
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
python3 scripts/runIpbbSynth.py <L1Menu name> --mp7url <URL MP7 git repo> --mp7tag <MP7 tag> -p <work dir> --build <build-version> --ugturl <URL ugt git repo> -u <ugt tag in repo>
```

**Note:** inspect default values for arguments using
```bash
python3 scripts/runIpbbSynth.py -h
```

Example
```bash
python3 scripts/runIpbbSynth.py L1Menu_Collisions2020_v0_1_8-d1
  --menuurl https://raw.githubusercontent.com/cms-l1-globaltrigger/cms-l1-menu/L1Menu_Collisions2020_v0_1_8-d1/2021
  --ugturl https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy
  --ugt master
  --build 0x1138
  -p ~/work_synth/production/
```

Example
```bash
python3 scripts/runIpbbSynth.py L1Menu_Collisions2020_v0_1_8-d1
  --menuurl https://raw.githubusercontent.com/cms-l1-globaltrigger/cms-l1-menu/L1Menu_Collisions2020_v0_1_8-d1/2021
  --ugturl https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy
  --ugt master
  --build 0x1138
  -p ~/work_synth/production/
  --sim \
  --simmp7path ~/gitlab/hbergaue/mp7
```

### Setup (commands for one module)

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
