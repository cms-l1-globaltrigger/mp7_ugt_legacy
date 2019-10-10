# Simulation of gtl_fdl_wrapper with Questa simulator for 6 ugt modules #

* This is a description running script "run_simulation_questa.py" for simulation.
* If Questa sim libraries for Vivado do not exist in $HOME/questasimlibs_xxx, they will be created for the selected Questa sim and Vivado versions.

#### Workflow ####
    # Clone git repositories
    git clone https://gitlab.cern.ch/hbergaue/mp7.git <local path>/mp7
    cd <local path>/mp7
    git checkout mp7fw_v2_4_1_mp7_ugt
    git clone https://gitlab.cern.ch/hbergaue/ugt.git <local path>/ugt
    cd <local path>/ugt
    git checkout master

    # Run simulation
    cd <local path>/ugt/
    python mp7_ugt/scripts/run_simulation_questa.py <L1Menu name> --mp7_tag <path local mp7>
    
    # Example
    cd ~/gitlab/hbergaue/ugt/mp7_ugt
    python mp7_ugt/scripts/run_simulation_questa.py L1Menu_Collisions2018_v2_1_0-d98 --mp7_tag ~/gitlab/hbergaue/mp7
