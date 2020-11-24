## Simulate

Simulation of gtl_fdl_wrapper with Questa simulator for 6 ugt modules

* This is a description running script `run_simulation_questa.py` for simulation.
* If Questa sim libraries for Vivado do not exist in `$HOME/questasimlibs_xxx`, they will be created for the selected Questa sim and Vivado versions.

### Workflow

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
python3 -m venv env
. env/bin/activate
pip install -U pip
pip install -r <mp7_ugt_legacy_path>/scripts/requirements.txt
```

Run simulation using Questa.
```bash
cd mp7_ugt_legacy
python scripts/run_simulation_questa.py <L1Menu name> --url <url l1menu> --mp7_tag <local mp7 path>
```

Example
```bash
cd mp7_ugt_legacy
python scripts/run_simulation_questa.py L1Menu_Collisions2018_v2_1_0-d4 \
  --url https://raw.githubusercontent.com/cms-l1-globaltrigger/cms-l1-menu/master/2020 \
  --mp7_tag ~/gitlab/hbergaue/mp7
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
  - added [l1menu_files.tcl](https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy/firmware/cfg/l1menu_files.tcl) for adding L1Menu VHDL files and inserted it into [top.dep](https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy/firmware/cfg/top.dep).

* Following scripts are available for firmware sythesis, checking used fpga resources and packing firmware files:
  - script [runIpbbSynth.py](https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy/scripts/runIpbbSynth.py) for IPBB synthesis (all 6 mp7_ugt modules) with the possibility of simulation.
  - script [checkIpbbSynth.py](https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy/scripts/checkIpbbSynth.py) for checking used fpga resources.
  - script [fwpackerIpbb.py](https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy/scripts/fwpackerIpbb.py) for packing firmware files in a tar file.

### Setup using script

Run kerberos for outside of CERN network.
```bash
kinit <username>@CERN.CH
```

Make local clone of ugt repositiory.
```bash
git clone https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy.git <local path>/mp7_ugt_legacy
cd <local path>/mp7_ugt_legacy
```

Run synthesis script (for all 6 modules).

```bash
python scripts/runIpbbSynth.py <L1Menu name> --mp7url <URL MP7 git repo> --mp7tag <MP7 tag> -p <work dir> --build <build-version> --ugturl <URL ugt git repo> -u <ugt tag in repo>
```

**Note:** inspect default values for arguments using
```bash
python scripts/runIpbbSynth.py -h
```

Example
```bash
python scripts/runIpbbSynth.py L1Menu_Collisions2018_v2_1_0-d4 \ 
  --menuurl https://raw.githubusercontent.com/cms-l1-globaltrigger/cms-l1-menu/master/2020 \
  --build 0x1123 \
  --ugturl https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy \
  --ugt v1.10.7
```

Run synthesis script (for all 6 modules) with simulation (Questasim)
```bash
git clone https://gitlab.cern.ch/hbergaue/mp7.git <local MP7 repo path>
git clone https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy.git <local path>/mp7_ugt_legacy
cd <local path>/mp7_ugt_legacy
python scripts/runIpbbSynth.py <L1Menu name> --mp7url <URL MP7 git repo> --mp7tag <MP7 tag> -p <work dir> --build <build version> --ugturl <URL ugt git repo> -u <ugt tag in repo> --sim --simmp7path <local MP7 repo path>
```

Example
```bash
python scripts/runIpbbSynth.py L1Menu_Collisions2018_v2_1_0-d2 \
  --build 0x1123 \
  --menuurl https://raw.githubusercontent.com/cms-l1-globaltrigger/cms-l1-menu/master/2020 \
  --ugturl https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy \
  --ugt v1.10.7 \
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
