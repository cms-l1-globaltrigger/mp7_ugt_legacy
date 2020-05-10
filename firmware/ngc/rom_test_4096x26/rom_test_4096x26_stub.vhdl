-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
-- Date        : Sun May 10 13:21:48 2020
-- Host        : bergauer-X1 running 64-bit Linux Mint 19.2 Tina
-- Command     : write_vhdl -force -mode synth_stub
--               /home/bergauer/github/cms-l1-globaltrigger/mp7_ugt_legacy/firmware/ngc/rom_test_4096x26/rom_test_4096x26_stub.vhdl
-- Design      : rom_test_4096x26
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7vx690tffg1927-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rom_test_4096x26 is
  Port ( 
    clka : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 11 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 25 downto 0 )
  );

end rom_test_4096x26;

architecture stub of rom_test_4096x26 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,addra[11:0],douta[25:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_4,Vivado 2019.2";
begin
end;
