#!/bin/bash

if [ -z ${XILINX_HLS} ]; then echo "XILINX_HLS is not set, did you source the HLS toolchain? Exiting"; exit; else echo "Including ap_fixed headers from \$XILINX_HLS set to '$XILINX_HLS'"; fi

PYBINDINCL=$(python -m pybind11 --includes)
if [ $? -eq 1 ]; then echo "Command 'python -m pybind11 --includes' returned an error. Is pybind11 installed?"; exit; else echo "Including pybind11 headers '$PYBINDINCL'"; fi

g++ -O3 -shared -std=c++11 -fPIC $PYBINDINCL -I$XILINX_HLS/include -I. -DWEIGHTS_DIR=\"anomaly_detection/NN/weights\" pybind11_bridge.cpp conversions.cpp anomaly_detection/anomaly_detection.cpp anomaly_detection/NN/VAE_HLS.cpp -o anomaly_detection_emulation.so 
