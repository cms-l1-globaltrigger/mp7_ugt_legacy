#!/bin/bash
set -e
# Any subsequent(*) commands which fail will cause the shell script to exit immediately

## Description:
## runs TME, VHDL Producer, creates project for FW synthesis, executes "make project" and starts screen for synthesis

nr_arguments=8
max_nr_modules=6

function error_exit
{
	echo "$@" 1>&2
	exit 1
}

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
    echo MP7FwTag: [currently: mp7fw_v2_2_1]
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
    tm-editor $1 --export-xml ~/$l1_menu_name\_temp.xml || error_exit "Could not open tm-editor! Aborting"
    cd $2 || error_exit "Cannot change directory! Aborting"
    source setup.sh || error_exit "Could not source setup.sh! Aborting"
    cd $2/tmVhdlProducer || error_exit "Cannot change directory! Aborting"
    tm-vhdlproducer ~/$l1_menu_name\_temp.xml --output=$4 --modules $3 || error_exit "VHDL producer failed! Aborting"
    cd
    echo ========================
    echo INFO: removed ~/$l1_menu_name\_temp.xml
    echo ========================
    rm $l1_menu_name\_temp.xml || error_exit "Cannot remove temp XML! Aborting"
    cd $5/scripts || error_exit "Cannot change directory! Aborting"
    python makeProject.py -t $6 -u $7 -b 0x$8 -p ~/work/mp7fwdir/ -m $4/$l1_menu_name\_m$3 || error_exit "makePropject.py script failed! Aborting"
    nr_modules=0
    while [ $nr_modules -lt $3 ]; do
## HB 2016-12-01: starting synthesis in screen
	screen -dmS $8_$nr_modules bash -c "source /opt/xilinx/Vivado/2016.4/settings64.sh; cd ~/work/mp7fwdir/$6/build_0x$8/$l1_menu_name\_m$3/module_$nr_modules; make project && make bitfile" || error_exit "Failed opening screen! Aborting"
	nr_modules=$((nr_modules + 1))
    done
    echo ========================
    echo INFO: synthesis for $nr_modules modules of FW 0x$8 started [screen]
    echo ========================
    screen -ls
    exit 0
fi
