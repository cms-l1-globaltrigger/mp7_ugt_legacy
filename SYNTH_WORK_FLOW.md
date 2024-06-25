# Workflow creating uGT firmware

* Download menu XML to local
* Open new menu XML with **TME 0.17.1** for checks, but you **MUST NOT save** the XML file!

## Create VHDL files of new menu with VHDL Producer 2.19.0
```bash
$ python3 -m venv env
$ . env/bin/activate
$ pip install --upgrade pip
$ pip install git+https://github.com/cms-l1-globaltrigger/tm-vhdlproducer.git@2.19.0
$ tm-vhdlproducer <path local new menu XML file> -d 1 -o <dir path producer output files>
```
Example:
```bash
$ tm-vhdlproducer ~/L1Menu_Collisions2024_v1_4_0.xml -d 1 -o ~/vhdl_prod_out
```
## Commit VHDL Producer output in L1Menu repo
```bash
$ git clone https://github.com/cms-l1-globaltrigger/cms-l1-menu.git
$ cd cms-l1-menu
$ git checkout master
$ git checkout -b <new menu name>
$ cp -r ~/vhdl_prod_out 2024/.
$ git add 2024/vhdl_prod_out/
$ git commit -am "new menu added"
$ git push --set-upstream origin <new menu name> 
```

## Synthesis on CERN server
```bash
$ mkdir <dir for synthesis>
$ cd <dir synthesis>
$ mkdir <dir synthesis output>
$ git clone https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy.git
$ cd mp7_ugt_legacy
$ git checkout v1.27.0

$ touch setup_env_synth.sh
```

### Insert following lines in setup_env_synth.sh:
```bash
## Synthesis (Vivado)
export VIVADO_BASE_DIR=/opt/xilinx/Vivado
export UGT_VIVADO_BASE_DIR=${VIVADO_BASE_DIR}
export UGT_VIVADO_VERSION=2021.2
export UGT_BLK_MEM_GEN_VERSION_SYNTH=blk_mem_gen_v8_4_5
source ${VIVADO_BASE_DIR}/${UGT_VIVADO_VERSION}/settings64.sh
```

```bash
$ . setup_env_synth.sh

$ cd <dir for synthesis>
$ git clone https://github.com/cms-l1-globaltrigger/ugt-fwtools.git
$ cd ugt-fwtools
$ git checkout 0.6.0
$ python3 -m venv env
$ . env/bin/activate
$ ugt-synthesize https://raw.githubusercontent.com/cms-l1-globaltrigger/<new menu name>/2024/<new menu name>/xml/<new menu name>.xml --ugttag <ugt fw tag> --mp7tag <mp7 fw tag> --build <build number> --path <path sythesis outputs>
```
Example:
```bash
$ ugt-synthesize https://raw.githubusercontent.com/cms-l1-globaltrigger/L1Menu_Collisions2024_v1_4_0-d1/2024/L1Menu_Collisions2024_v1_4_0-d1/xml/L1Menu_Collisions2024_v1_4_0-d1.xml --ugttag v1.27.0 --mp7tag v3.2.2_Vivado2021+_ugt_v4 --build 0x1192 --path /home/../synthesis_dir/synthesis_output
```

## Check synthesis after finished
```bash
$ ugt-checksynth <dir for synthesis>/<dir synthesis output>/<build number>/build_<build number>.cfg
```
Example:
```bash
$ ugt-checksynth /home/../synthesis_dir/synthesis_output/0x1192/0x1192.cfg
```

## FW packing (creating TAR file)
```bash
$ ugt-fwpacker <dir for synthesis>/<dir synthesis output>/<build number>/build_<build number>.cfg
```

Example:
```bash
$ ugt-fwpacker /home/../synthesis_dir/synthesis_output/0x1192/0x1192.cfg
```

## Copy TAR file to firmware directory 
```bash
$ scp <dir for synthesis>/<dir synthesis output>/<build number>/<file name>.tar.gz /afs/cern.ch/user/<>/<user>/.
```
Example:
```bash
$ scp /home/../synthesis_dir/synthesis_output/0x1192/<file name>.tar.gz /afs/cern.ch/user/<>/<user>/.
```

### login lxplus and copy TAR file
```bash
$ scp <file name>.tar.gz <user>@cmsusr:.
```

### login in cmsusr and get XML and test vector file of new menu
```bash
$ wget https://raw.githubusercontent.com/cms-l1-globaltrigger/<new menu name>/2024/<new menu name>/xml/<new menu name>.xml
```
Example:
```bash
$ wget https://raw.githubusercontent.com/cms-l1-globaltrigger/L1Menu_Collisions2024_v1_4_0-d1/2024/L1Menu_Collisions2024_v1_4_0-d1/xml/L1Menu_Collisions2024_v1_4_0-d1.xml
```

```bash
$ wget https://raw.githubusercontent.com/cms-l1-globaltrigger/<new menu name>/2024/<new menu name>/testvectors/<test vector file>.txt
```

### login test crate and copy TAR file
```bash
$ cp ../<user>/<file name>.tar.gz firmware/.
```

## Upload FW on testcrate
```bash
$ tdf run uploadfw_gt firmware/<file name>.tar.gz --rebootfpga
$ tdf run crate_status
```

## Test FW
```bash
$ tdf run multiboard_function_test --menu ../<user>/<new menu name>.xml --testvector ../<user>/<test vector file>.txt --loopback
```
