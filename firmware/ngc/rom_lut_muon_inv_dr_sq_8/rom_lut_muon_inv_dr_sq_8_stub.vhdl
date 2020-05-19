-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
-- Date        : Tue May 19 10:23:36 2020
-- Host        : bergauer-X1 running 64-bit Linux Mint 19.2 Tina
-- Command     : write_vhdl -force -mode synth_stub -rename_top rom_lut_muon_inv_dr_sq_8 -prefix
--               rom_lut_muon_inv_dr_sq_8_ rom_lut_muon_inv_dr_sq_8_stub.vhdl
-- Design      : rom_lut_muon_inv_dr_sq_8
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7vx690tffg1927-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rom_lut_muon_inv_dr_sq_8 is
  Port ( 
    clka : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 11 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 11 downto 0 )
  );

end rom_lut_muon_inv_dr_sq_8;

architecture stub of rom_lut_muon_inv_dr_sq_8 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,addra[11:0],douta[11:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_4,Vivado 2019.2";
begin
end;
