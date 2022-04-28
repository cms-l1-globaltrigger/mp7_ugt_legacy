## Simulation (Questasim)
export MODELSIM_ROOT=<Questasim installation dir>
export MODELSIM_PATH=${MODELSIM_ROOT}/questasim/bin
export PATH=${MODELSIM_PATH}:${PATH}
export MTI_VCO_MODE=64
export MGLS_LICENSE_FILE=<license server>
export UGT_GITLAB_USER_NAME=<gitlab user name>
export UGT_QUESTASIMLIBS_DIR=<Questasim libs dir>
export UGT_QUESTASIM_VERSION=<Questasim version>
export UGT_QUESTASIM_SIM_PATH=${MODELSIM_ROOT}
export UGT_VIVADO_QUESTASIMLIBS_VERSION=<Questasim simlibs version>
export UGT_QUESTASIM_LIBS_PATH=${UGT_QUESTASIMLIBS_DIR}/questasimlibs_vivado_${UGT_VIVADO_QUESTASIMLIBS_VERSION}
export UGT_BLK_MEM_GEN_VERSION_SIM=<blk_mem_gen version for simulation (Questasim)>
## Synthesis (Vivado)
export VIVADO_BASE_DIR=<Vivado installation dir>
export UGT_VIVADO_BASE_DIR=${VIVADO_BASE_DIR}
export UGT_VIVADO_VERSION=<Vivado version>
export UGT_BLK_MEM_GEN_VERSION_SYNTH=<blk_mem_gen version for synthesis (Vivado)>
source ${VIVADO_BASE_DIR}/${UGT_VIVADO_VERSION}/settings64.sh
