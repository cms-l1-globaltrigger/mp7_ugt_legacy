// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Thu Dec  2 08:35:00 2021
// Host        : srv-b1b07-10-01.cern.ch running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub
//               /home/ugt-build/bergauer/github/cms-l1-globaltrigger/mp7_ugt_legacy/firmware/ngc/rom_lut_muon_inv_dr_sq_2/rom_lut_muon_inv_dr_sq_2_stub.v
// Design      : rom_lut_muon_inv_dr_sq_2
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx690tffg1927-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2021.2" *)
module rom_lut_muon_inv_dr_sq_2(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[12:0],douta[13:0]" */;
  input clka;
  input [12:0]addra;
  output [13:0]douta;
endmodule
