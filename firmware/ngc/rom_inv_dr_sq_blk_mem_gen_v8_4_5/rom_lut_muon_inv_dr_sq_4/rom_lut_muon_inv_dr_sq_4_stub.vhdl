-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
-- Date        : Thu Dec  2 08:40:15 2021
-- Host        : srv-b1b07-10-01.cern.ch running 64-bit unknown
-- Command     : write_vhdl -force -mode synth_stub
--               /home/ugt-build/bergauer/github/cms-l1-globaltrigger/mp7_ugt_legacy/firmware/ngc/rom_lut_muon_inv_dr_sq_4/rom_lut_muon_inv_dr_sq_4_stub.vhdl
-- Design      : rom_lut_muon_inv_dr_sq_4
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7vx690tffg1927-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rom_lut_muon_inv_dr_sq_4 is
  Port ( 
    clka : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 12 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 13 downto 0 )
  );

end rom_lut_muon_inv_dr_sq_4;

architecture stub of rom_lut_muon_inv_dr_sq_4 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,addra[12:0],douta[13:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_5,Vivado 2021.2";
begin
end;
