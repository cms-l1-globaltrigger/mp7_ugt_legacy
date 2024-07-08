# Workflow creating uGT firmware

* Download menu XML to local
* Open new menu XML with **TME 0.17.1** for checks, but you **MUST NOT save** the XML file!
* This workflow uses `L1Menu_Collisions2024_v1_4_0` as example.

**Note:** the following instructions assume Pyhon 3.9 as interpreter, but newer versions (3.10 and 3.11) will work too. At the moment some tools do not support Python 3.12.
  
## Create a menu distribution and commit to menu repo

Create VHDL code of a menu using [VHDL Producer](https://github.com/cms-l1-globaltrigger/tm-vhdlproducer) 2.20.0 and commit menu distribution to new menu repo branch (ideally a fork of [cms-l1-menu](https://github.com/cms-l1-globaltrigger/cms-l1-menu)).

Using a helper script for convenience:

```bash
wget https://raw.githubusercontent.com/cms-l1-globaltrigger/mp7_ugt_legacy/synth_work_flow/scripts/workflow_vhdl_prod_l1menu_commit.py
python3.9 workflow_vhdl_prod_l1menu_commit.py ~/L1Menu_Collisions2024_v1_4_0.xml --repo https://github.com/<username>/cms-l1-menu.git
```


## Synthesis with GitLab runner

CI/CD build system for automated synthesizing uGT firmware in [ugt-build](https://gitlab.cern.ch/cms-l1-globaltrigger/ugt-build/).

### Instructions

In `build.yml` adjust parameters `BUILD_ID` and `MENU_URL`.

In _Build_ -> _Pipelines_ start the pipeline manually.

On success download the `fwpacker:archive` artifact containing the bundled firmware tarball.


## Copy TAR file to firmware directory 

### Copy TAR file to cmsusr
```bash
scp L1Menu_Collisions2024_v1_4_0*.tar.gz $USER@cmsusr:
```

### Login in cmsusr and get XML and test vector file of new menu
```bash
wget https://raw.githubusercontent.com/cms-l1-globaltrigger/<new menu name>/2024/<new menu name>/xml/<new menu name>.xml
```
Example:
```bash
wget https://raw.githubusercontent.com/cms-l1-globaltrigger/L1Menu_Collisions2024_v1_4_0-d1/2024/L1Menu_Collisions2024_v1_4_0-d1/xml/L1Menu_Collisions2024_v1_4_0-d1.xml
```

```bash
wget https://raw.githubusercontent.com/cms-l1-globaltrigger/<new menu name>/2024/<new menu name>/testvectors/<test vector file>.txt
```

**Remark:** if there is no test vector file available for current uGT build number, use:
```bash
wget https://raw.githubusercontent.com/herbberg/l1menus/master/TestVector_empty.txt
```
to check whether multiboard_function_test runs with out errors

### Login test crate and copy TAR file
```bash
cp ../<user>/<file name>.tar.gz firmware/.
```

## Upload FW on testcrate
```bash
tdf run uploadfw_gt firmware/<file name>.tar.gz --rebootfpga
tdf run crate_status
```

## Test FW with multiboard_function_test
```bash
tdf run multiboard_function_test --menu ../<user>/<new menu name>.xml --testvector ../<user>/<test vector file>.txt --loopback
```
