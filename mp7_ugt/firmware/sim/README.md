### Simulation of gtl_fdl_wrapper with Questa simulator for 6 ugt modules ###

* This is a draft description running script "run_simulation_questa.py" for simulation.
* If Questa sim libraries for Vivado do not exist in $HOME, they will be created for the selected Questa sim and Vivado versions.

    # Clone git repositories
    git clone https://gitlab.cern.ch/hbergaue/mp7.git <local path>/mp7
    cd <local path>/mp7
    git checkout mp7fw_v2_4_1_mp7_ugt
    git clone https://gitlab.cern.ch/hbergaue/ugt.git <local path>/ugt
    cd <local path>/ugt
    git checkout master
    git clone https://github.com/herbberg/l1menus.git <local path>/l1menus 
    
    # Run simulation
    cd <local path>/ugt/mp7_ugt/firmware/sim
    python scripts/run_simulation_questa.py --mp7_tag <path local mp7> --menu <path to local L1Menu> --testvector <path to local testvector file> --vivado <Vivado version> --questasim <Questa sim version>
    
    # Example
    python scripts/run_simulation_questa.py --mp7_tag ~/gitlab/hbergaue/mp7 --menu ~/github/herbberg/l1menus/L1Menu_Collisions2018_v2_1_0-d98 --testvector ~/github/herbberg/l1menus/L1Menu_Collisions2018_v2_1_0-d98/testvectors/TestVector_L1Menu_Collisions2018_v2_1_0.txt --vivado 2018.2 --questasim 10.6
