# Workflow creating uGT firmware

* Download menu XML to local
* Open new menu XML with **TME 0.17.1** for checks, but you **MUST NOT save** the XML file!
* This workflow uses `L1Menu_Collisions2024_v1_4_0` as example.
  
## Create a menu distribution

Create VHDL code of a menu using VHDL Producer 2.19.0. This can be done on lxplus nodes or a local Linux machine.

```bash
python3 -m venv env
. env/bin/activate
pip install --upgrade pip
pip install git+https://github.com/cms-l1-globaltrigger/tm-vhdlproducer.git@2.19.0
tm-vhdlproducer <xml_menu> -d 1 -o <output_path>
```

Example:
```bash
tm-vhdlproducer ~/L1Menu_Collisions2024_v1_4_0.xml -d 1 -o ~/vhdl_prod_out
```
## Commit menu distribution

Commit the VHDL Producer output in L1Menu repo

```bash
MENU_NAME=L1Menu_Collisions2024_v1_4_0
git clone https://github.com/cms-l1-globaltrigger/cms-l1-menu.git -b master
cd cms-l1-menu
git checkout -b $MENU_NAME-d1
cp -r <output_path>/$MENU_NAME-d1 2024/.
git add 2024/$MENU_NAME-d1
git commit -am "added $MENU_NAME"
git push --set-upstream origin $MENU_NAME-d1
```

## Synthesis on CERN server

### Install ugt-fwtools

See [cms-l1-globaltrigger/ugt-fwtools](https://github.com/cms-l1-globaltrigger/ugt-fwtools/) for details.

```bash
python3.9 -m venv env
. env/bin/activate
pip install git+https://github.com/cms-l1-globaltrigger/ugt-fwtools.git@0.6.0
```

### Create setup_env_synth.sh

```bash
cat <<EOF > setup_env_synth.sh
export VIVADO_BASE_DIR=/opt/xilinx/Vivado
export UGT_VIVADO_BASE_DIR=${VIVADO_BASE_DIR}
export UGT_VIVADO_VERSION=2021.2
export UGT_BLK_MEM_GEN_VERSION_SYNTH=blk_mem_gen_v8_4_5
source ${UGT_VIVADO_BASE_DIR}/${UGT_VIVADO_VERSION}/settings64.sh
EOF
```

```bash
. setup_env_synth.sh
```

```bash
MENU_NAME=L1Menu_Collisions2024_v1_4_0  # replace
XML_URL=https://raw.githubusercontent.com/cms-l1-globaltrigger/$MENU_NAME/2024/$MENU_NAME/xml/$MENU_NAME.xml
BUILD_ID=0x8001  # replace according to bookkeeping
ugt-synthesize $XML_URL --ugttag v1.27.0 --mp7tag v3.2.2_Vivado2021+_ugt_v4 --build $BUILD_ID --path synth
```

## Check synthesis after finished
```bash
ugt-checksynth synth/$BUILD_ID/build_$BUILD_ID.cfg
```

## Firmware packing (creating TAR file)
```bash
ugt-fwpacker synth/$BUILD_ID/build_$BUILD_ID.cfg
```

## Copy TAR file to firmware directory 
```bash
scp synth/$BUILD_ID/$MENU_NAME*.tar.gz $USER@lxplus.cern.ch:
```

### login lxplus and copy TAR file
```bash
scp L1Menu_Collisions2024_v1_4_0*.tar.gz $USER@cmsusr:
```

### login in cmsusr and get XML and test vector file of new menu
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

### login test crate and copy TAR file
```bash
cp ../<user>/<file name>.tar.gz firmware/.
```

## Upload FW on testcrate
```bash
tdf run uploadfw_gt firmware/<file name>.tar.gz --rebootfpga
tdf run crate_status
```

## Test FW
```bash
tdf run multiboard_function_test --menu ../<user>/<new menu name>.xml --testvector ../<user>/<test vector file>.txt --loopback
```
