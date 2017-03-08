#!/bin/bash
set -e
# Any subsequent(*) commands which fail will cause the shell script to exit immediately

## Description:
## runs TME, VHDL Producer, creates project for FW synthesis, executes "make project" and starts screen for synthesis

nr_arguments=8
max_nr_modules=3

if [ "$1" == "-h" -o "$1" == "--help" ]
then
    echo 
    echo ========================
    echo List of $nr_arguments arguments: Xml4Tme PathUtm NumberModules PathL1MenuDir PathFw MP7FwTag UserName FWVersion
    echo 
    echo Description of $nr_arguments arguments:
    echo 
    echo Xml4Tme: location of xml file for TME
    echo PathUtm: location of utm directory [for executing tmVhdlProducer]
    echo NumberModules: number of ugt MP7 modules [used for this FW version]
    echo PathL1MenuDir: location of L1Menu directory
    echo PathFw: location of mp7_ugt directory [for making FW project]
    echo MP7FwTag: [currently: mp7fw_v2_2_0]
    echo UserName: CERN user name
    echo FWVersion: FW version [e.g.: 10a2]
    echo ========================
    echo 
    exit 0
else
    if [[ $# -ne $nr_arguments ]] ; then
	echo ========================
	echo ERROR: number of arguments not equal $nr_arguments [found $# arguments]
	echo ========================
	exit 1
    fi
    if [ ! -f $1 ] ; then
	echo ========================
	echo ERROR: XML file NOT found - $1 does NOT exist
	echo ========================
	exit 1
    fi
    if [ $3 -eq 0 -o $3 -gt $max_nr_modules ] ; then
	echo ========================
	echo ERROR: number of modules is out of range [1 to $max_nr_modules] - number of modules = $3
	echo ========================
	exit 1
    fi
## HB 2016-12-01: extract L1MenuName from XML file from <name>...</name>
#     l1_menu_name=$(sed -n '/L1Menu/p' $1 | cut -d'>' -f2 | cut -d'<' -f1)
    l1_menu_name=$(sed -n '/<name>L1Menu/p' $1 | cut -d'>' -f2 | cut -d'<' -f1)
    cd
## HB 2016-12-01: used a temporary file as output of TME for VHDL Producer
    echo ========================
    echo INFO: TME is checking $1 and exporting a temporary file [~/$l1_menu_name\_temp.xml] for VHDL Producer
    echo ========================
    tm-editor $1 --export-xml ~/$l1_menu_name\_temp.xml
    cd $2
    source setup.sh
    cd $2/tmVhdlProducer
    tm-vhdlproducer ~/$l1_menu_name\_temp.xml --output=$4 --modules $3
    cd
    echo ========================
    echo INFO: removed ~/$l1_menu_name\_temp.xml
    echo ========================
    rm $l1_menu_name\_temp.xml
    cd $5/scripts
    python makeProject.py -t $6 -u $7 -b 0x$8 -p ~/work/mp7fwdir/ -m $4/$l1_menu_name\_m$3
## HB 2017-03-08: switched to Vivado 2016.4
#    source /opt/xilinx/Vivado/2016.2/settings64.sh
    source /opt/xilinx/Vivado/2016.4/settings64.sh
    nr_modules=0
    while [ $nr_modules -lt $3 ]; do
	cd ~/work/mp7fwdir/$6/build_0x$8/$l1_menu_name\_m$3/module_$nr_modules
	make project
## HB 2016-12-01: starting synthesis in screen
	screen -S $8_$nr_modules -dm make bitfile
	nr_modules=$((nr_modules + 1))
    done
    echo ========================
    echo INFO: synthesis for $nr_modules modules of FW 0x$8 started [screen]
    echo ========================
    screen -r
    exit 0
fi


