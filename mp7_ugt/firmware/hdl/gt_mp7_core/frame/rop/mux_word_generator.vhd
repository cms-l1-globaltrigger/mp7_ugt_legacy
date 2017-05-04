--------------------------------------------------------------------------------
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
---Description: Read-out Process, complex design, Specification and architecture design/implementation.
--             ROP moudule produce read-out recorrd for sending their to DAQ block in MP7 from there to
--              AMC13..
--              Please do not change any part of the design without to cousultate HEPHY, because the main part of design
--              will automated produced and you have to know, what do you do.
-- $Date: 2015-06-15 $
-- $Author: HEPHY $
-- Warning:  The output dump is not validted systematically based on my .xml concept. If you would like to use the desing, please conatact developer.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;
use work.gt_mp7_core_pkg.all;
use work.lhc_data_pkg.all;
use work.output_logic_pkg.all;

entity mux_word_generator is
   port
   (
      daq_clk : in  std_logic;
      daq_rst : in  std_logic;

      bx_in_event_array_in : in  bx_in_event_array_t;

      -- pkt_buffer interface
      pkt_available : in  std_logic;
      pkt_req       : out std_logic;

      addr_bx_in_event : out std_logic_vector(log2c(MAX_BX_IN_EVENT)-1 downto 0);
      mux_ctrl_word    : out std_logic_vector(OL_INSTR_MUX_WIDTH-1 downto 0);

      -- daq interface
      daq_oe   : out std_logic;
      daq_sof  : out std_logic;
      daq_stop : out std_logic;
      daq_busy : in  std_logic
   );
end mux_word_generator;

architecture behavioral of mux_word_generator is

   constant ROM_REG_STAGES : integer := 2;

   type register_t is record
      rom_addr_cnt  : std_logic_vector(OL_INSTR_ADDR_WIDTH-1 downto 0);
      history_cnt   : integer range 0 to MAX_BX_IN_EVENT+1;
      mux_ctrl_word : std_logic_vector(OL_INSTR_MUX_WIDTH-1 downto 0);
      daq_oe        : std_logic;
      daq_sof       : std_logic_vector(0 to 1);
      daq_stop      : std_logic;
      bx_in_event   : unsigned(log2c(MAX_BX_IN_EVENT)-1 downto 0);
      run           : std_logic;
      stall_cnt     : integer range 0 to OL_MUX_STAGES-1;
      stall_en      : std_logic_vector(0 to 1);
   end record;

   constant reg_rst : register_t :=
   (
      rom_addr_cnt  => (others => '0'),
      history_cnt   => 0,
      mux_ctrl_word => (others => '0'),
      daq_oe        => '0',
      daq_sof       => (others => '0'),
      daq_stop      => '0',
      bx_in_event   => to_unsigned(MAX_BX_IN_EVENT/2,log2c(MAX_BX_IN_EVENT)),
      run           => '0',
      stall_cnt     => 0,
      stall_en      => (others => '0')
   );

   signal r, r_nxt : register_t := reg_rst;

   signal instr    : std_logic_vector(OUTPUT_LOGIC_INSTR_WIDTH-1 downto 0);

   alias instr_mux_word : std_logic_vector(OL_INSTR_MUX_WIDTH-1 downto 0) is
                          instr(OL_INSTR_MUX_TO downto OL_INSTR_MUX_FROM);
   alias instr_bx_ie    : std_logic_vector(OL_INSTR_BX_IE_WIDTH-1 downto 0) is
                          instr(OL_INSTR_BX_IE_TO downto OL_INSTR_BX_IE_FROM);
   alias instr_ctrl     : std_logic_vector(OL_INSTR_CTRL_WIDTH-1 downto 0) is
                          instr(OL_INSTR_CTRL_TO downto OL_INSTR_CTRL_FROM);
   alias instr_addr     : std_logic_vector(OL_INSTR_ADDR_WIDTH-1 downto 0) is
                          instr(OL_INSTR_ADDR_TO downto OL_INSTR_ADDR_FROM);

   signal bx_in_event_array, bx_in_event_array_nxt : bx_in_event_array_t;
   signal bx_in_event_0, bx_in_event_0_nxt : std_logic_vector(BX_IN_EVENT_ITEMS-1 downto 0);

   signal rom_addr : std_logic_vector(OL_INSTR_ADDR_WIDTH-1 downto 0);
   signal rom_addr_mux : std_logic;

   signal rom_mask_instr : std_logic;

   signal history_cnt_match : std_logic;

   signal stall    : std_logic;
   signal rom_en   : std_logic;
   signal stall_en : std_logic;

begin

   rom_en <= not stall;
   instruction_rom_instr: entity work.output_instruction_rom
   generic map
   (
      ADDR_WIDTH  => OUTPUT_LOGIC_INSTR_ADDR_WIDTH,
      INSTR_WIDTH => OUTPUT_LOGIC_INSTR_WIDTH
   )
   port map
   (
      clk   => daq_clk,
      rst   => daq_rst,
      en    => rom_en,
      addr  => rom_addr,
      instr => instr
   );

   rom_addr_mux_ctrl: process(bx_in_event_array_in,bx_in_event_0)
   begin

      for i in 0 to BX_IN_EVENT_ITEMS-1 loop
         if bx_in_event_array_in(i) = 0 then
            bx_in_event_0_nxt(i) <= '1';
         else
            bx_in_event_0_nxt(i) <= '0';
         end if;
      end loop;

   end process;

   exec: process(r,instr_ctrl,instr_bx_ie,instr_addr,instr_mux_word,rom_mask_instr,rom_addr_mux,rom_addr,
                 history_cnt_match,pkt_available,daq_busy,bx_in_event_array,bx_in_event_0,stall,stall_en)
      variable bx_index    : integer;
   begin

      r_nxt <= r;

      if stall = '0' then
         r_nxt.rom_addr_cnt <= std_logic_vector(unsigned(rom_addr)+1);
      end if;

      pkt_req <= '0';
      r_nxt.daq_sof(0) <= '0';
      if (pkt_available and not r.run and not daq_busy) = '1' then
         r_nxt.run <= '1';
         pkt_req <= '1';
         r_nxt.daq_sof(0) <= '1';
      end if;

      r_nxt.daq_sof(1) <= r.daq_sof(0);

      bx_index := to_integer(unsigned(instr_bx_ie));

      if r.history_cnt = bx_in_event_array(bx_index) then
         history_cnt_match <= '1';
      else
         history_cnt_match <= '0';
      end if;

      -- branch
      rom_addr_mux <= (instr_ctrl(OL_INSTR_SOH) and bx_in_event_0(bx_index)) or
                      (instr_ctrl(OL_INSTR_EOH) and not history_cnt_match);

      if instr_ctrl(OL_INSTR_SOH) = '1' then
         r_nxt.history_cnt <= 1;
         r_nxt.bx_in_event <= to_unsigned(MAX_BX_IN_EVENT/2,log2c(MAX_BX_IN_EVENT))-
                                          bx_in_event_array(bx_index)(log2c(MAX_BX_IN_EVENT)-1 downto 1);
      end if;

      if instr_ctrl(OL_INSTR_EOH) = '1' then
         r_nxt.history_cnt <= r.history_cnt+1;
         r_nxt.bx_in_event <= r.bx_in_event+1;
      end if;

      if (instr_ctrl(OL_INSTR_EOH) and history_cnt_match) = '1' then
         r_nxt.bx_in_event <= to_unsigned(MAX_BX_IN_EVENT/2,log2c(MAX_BX_IN_EVENT));
      end if;

      if (instr_ctrl(OL_INSTR_EOF) and not stall) = '1' then
         r_nxt.run <= '0';
      end if;

      stall <= '0';
      r_nxt.stall_en(0) <= '1';
      stall_en <= '1';
      if instr_ctrl(OL_INSTR_CRC) = '1' then
         if r.stall_cnt = OL_MUX_STAGES-1 then
            r_nxt.stall_cnt <= 0;
         else
            r_nxt.stall_cnt <= r.stall_cnt+1;
            stall <= '1';
            stall_en <= '0';
            r_nxt.stall_en(0) <= '0';
         end if;
      end if;
      r_nxt.stall_en(1) <= r.stall_en(0);

      if r.run = '1' then
         if rom_addr_mux = '0' then
            rom_addr <= r.rom_addr_cnt;
         else
            rom_addr <= instr_addr;
         end if;
      else
         rom_addr <= (others => '0');
      end if;

      r_nxt.daq_oe <= r.run and not(instr_ctrl(OL_INSTR_SOH) or instr_ctrl(OL_INSTR_EOH)) and not
                      (instr_ctrl(OL_INSTR_EOH) and instr_ctrl(OL_INSTR_EOF)) and stall_en;
      r_nxt.daq_stop <= instr_ctrl(OL_INSTR_EOF) and not stall;

      r_nxt.mux_ctrl_word <= instr_mux_word;
      mux_ctrl_word <= r.mux_ctrl_word;
      addr_bx_in_event <= std_logic_vector(r.bx_in_event);

      daq_oe <= r.daq_oe;
      daq_sof <= r.daq_sof(1);
      daq_stop <= r.daq_stop;

   end process;

   sync: process(daq_clk,daq_rst)
   begin

      if daq_rst = RST_ACT_ROP then
         r <= reg_rst;
         bx_in_event_array <= (others => (others => '0'));
         bx_in_event_0 <= (others => '0');
      elsif rising_edge(daq_clk) then
         if daq_busy = '0' then
            r <= r_nxt;
            bx_in_event_array <= bx_in_event_array_in;
            bx_in_event_0 <= bx_in_event_0_nxt;
         end if;
      end if;

   end process;

end behavioral;

