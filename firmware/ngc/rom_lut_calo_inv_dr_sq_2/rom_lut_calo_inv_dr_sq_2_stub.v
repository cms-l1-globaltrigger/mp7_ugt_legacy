// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2700185 Thu Oct 24 18:45:48 MDT 2019
// Date        : Tue Aug 24 09:13:25 2021
// Host        : ugt-synth running 64-bit Ubuntu 16.04.7 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/bergauer/github/cms-l1-globaltrigger/mp7_ugt_legacy/firmware/ngc/rom_lut_calo_inv_dr_sq_2/rom_lut_calo_inv_dr_sq_2_stub.v
// Design      : rom_lut_calo_inv_dr_sq_2
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx690tffg1927-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2019.2" *)
module rom_lut_calo_inv_dr_sq_2(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[11:0],douta[13:0]" */;
  input clka;
  input [11:0]addra;
  output [13:0]douta;
endmodule
