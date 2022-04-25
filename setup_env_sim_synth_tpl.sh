export UGT_VIVADO_BASE_DIR=<Vivado installation dir>
export UGT_VIVADO_VERSION=<Vivado version>
export MGLS_LICENSE_FILE=<license server>
export UGT_GITLAB_USER_NAME=<gitlab user name>
export UGT_QUESTASIM_VERSION=<Questasim version>
export UGT_QUESTASIM_SIM_PATH=<Questasim installation dir>
export UGT_VIVADO_QUESTASIMLIBS_VERSION=<Questasim simlibs version>
export UGT_BLK_MEM_GEN_VERSION_SIM=<blk_mem_gen version for simulation (Questasim)>
export UGT_BLK_MEM_GEN_VERSION_SYNTH=<blk_mem_gen version for synthesis (Vivado)>
export UGT_QUESTASIM_LIBS_PATH=${UGT_QUESTASIM_SIM_PATH}/questalibs_vivado_${UGT_VIVADO_QUESTASIMLIBS_VERSION}
source ${UGT_VIVADO_BASE_DIR}/${UGT_VIVADO_VERSION}/settings64.sh
