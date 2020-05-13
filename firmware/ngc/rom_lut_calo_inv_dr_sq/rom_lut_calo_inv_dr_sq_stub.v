// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Sun May 10 13:41:25 2020
// Host        : bergauer-X1 running 64-bit Linux Mint 19.2 Tina
// Command     : write_verilog -force -mode synth_stub
//               /home/bergauer/github/cms-l1-globaltrigger/mp7_ugt_legacy/firmware/ngc/rom_lut_calo_inv_dr_sq/rom_lut_calo_inv_dr_sq_stub.v
// Design      : rom_lut_calo_inv_dr_sq
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx690tffg1927-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2019.2" *)
module rom_lut_calo_inv_dr_sq(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[15:0],douta[31:0]" */;
  input clka;
  input [15:0]addra;
  output [31:0]douta;
endmodule