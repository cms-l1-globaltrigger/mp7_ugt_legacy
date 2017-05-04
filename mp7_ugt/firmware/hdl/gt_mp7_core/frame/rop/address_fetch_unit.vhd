-------------------------------------------------------------------------------
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
-- The reset design logic is a bit changed but the reset logic design should be re-newed based on the new concept.
-- $Date: 2015-06-15 $
-- $Author: HEPHY $
-- Warning:  The output dump is not validted systematically based on my .xml concept. If you would like to use the desing, please conatact developer.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;
use work.gt_mp7_core_pkg.all;

entity address_fetch_unit is
   generic
   (
      ADDR_WIDTH : integer := 8;
      MEM_DEPTH  : integer := 8
   );
   port
   (
      daq_clk : in  std_logic;
      daq_rst : in  std_logic;

      offset_fifo_empty : in  std_logic;
      offset_fifo_rd    : out std_logic;
      offset_fifo_addr  : in  std_logic_vector (ADDR_WIDTH-1 downto 0);

      pkt_buffer_addr : out std_logic_vector (ADDR_WIDTH-1 downto 0);
      pkt_buffer_rd   : out std_logic;
      pkt_buffer_dout : in  std_logic_vector (ADDR_WIDTH-1 downto 0);

      bx_in_event : in  std_logic_vector (log2c(MAX_BX_IN_EVENT)-1 downto 0);

      pkt_available : out std_logic;
      pkt_req       : in  std_logic;

      free_addr : out std_logic_vector(ADDR_WIDTH-1 downto 0);
      free      : out std_logic;

      main_ram_addr : out std_logic_vector (ADDR_WIDTH-1 downto 0);
      main_ram_rd   : out std_logic
   );
end address_fetch_unit;

architecture behavioral of address_fetch_unit is

   type addr_reg_t is array(0 to MAX_BX_IN_EVENT-1) of std_logic_vector(ADDR_WIDTH-1 downto 0);

   type register_t is record
      offset_fifo_rd    : std_logic;
      pkt_buffer_addr   : std_logic_vector (ADDR_WIDTH-1 downto 0);
      en_cnt            : integer range 0 to MAX_BX_IN_EVENT+1;
      reg_chain_en      : std_logic;
      reg_chain         : addr_reg_t;
      out_reg           : addr_reg_t;
      first             : std_logic;
      nxt               : std_logic;
      set_pkt_available : std_logic;
      pkt_available     : std_logic;
      set_first_addr    : std_logic;
      first_addr        : std_logic_vector(ADDR_WIDTH-1 downto 0);
      first_free        : std_logic;
      free              : std_logic;
      free_addr         : std_logic_vector(ADDR_WIDTH-1 downto 0);
   end record;

   constant reg_rst : register_t :=
   (
      offset_fifo_rd    => '0',
      pkt_buffer_addr   => (others => '0'),
      en_cnt            => MAX_BX_IN_EVENT-1,
      reg_chain_en      => '0',
      reg_chain         => (others => (others => '0')),
      out_reg           => (others => (others => '0')),
      first             => '1',
      nxt               => '0',
      set_pkt_available => '0',
      pkt_available     => '0',
      set_first_addr    => '0',
      first_addr        => (others => '0'),
      first_free        => '1',
      free              => '0',
      free_addr         => (others => '0')
   );

   signal pkt_req_int : std_logic;

   signal offset_fifo_mux_ctrl : std_logic_vector(1 downto 0);
   signal offset_fifo_rd_int   : std_logic;

   signal en_cnt_en    : std_logic;
   signal en_cnt_max   : std_logic;
   signal en_cnt_max_n : std_logic;

   signal reg_chain_en      : std_logic;
   signal set_pkt_available : std_logic;
   signal avail_mux_ctrl    : std_logic_vector(1 downto 0);

   signal nxt_mux_ctrl : std_logic_vector(1 downto 0);

   signal set_first_addr   : std_logic;
   signal first_addr_match : std_logic;
   signal rst_free_addr    : std_logic;

   signal r, r_nxt : register_t;

begin

   main_ram_rd <= '1';

   exec: process(r,offset_fifo_empty,pkt_req_int,offset_fifo_rd_int,offset_fifo_mux_ctrl,
                 offset_fifo_addr,en_cnt_max,en_cnt_max_n,en_cnt_en,pkt_buffer_dout,
                 bx_in_event,pkt_req,reg_chain_en,set_pkt_available,avail_mux_ctrl,nxt_mux_ctrl,
                 set_first_addr,first_addr_match,rst_free_addr)
   begin

      r_nxt <= r;

      offset_fifo_rd_int <= not offset_fifo_empty and not en_cnt_en and (r.first or r.nxt);

      r_nxt.offset_fifo_rd <= offset_fifo_rd_int;

      if r.offset_fifo_rd = '1' then
         r_nxt.first <= '0';
      end if;

      offset_fifo_mux_ctrl(0) <= r.offset_fifo_rd;
      if to_integer(unsigned(r.pkt_buffer_addr)) = MEM_DEPTH-1 then
         offset_fifo_mux_ctrl(1) <= '1';
      else
         offset_fifo_mux_ctrl(1) <= '0';
      end if;

      case offset_fifo_mux_ctrl is
         when "00" =>   r_nxt.pkt_buffer_addr <= std_logic_vector(unsigned(r.pkt_buffer_addr)+1);
         when "01" =>   r_nxt.pkt_buffer_addr <= offset_fifo_addr;
         when others => r_nxt.pkt_buffer_addr <= (others => '0');
      end case;

      -- enable-counter

      if r.en_cnt = MAX_BX_IN_EVENT then
         en_cnt_max <= '1';
      else
         en_cnt_max <= '0';
      end if;
      en_cnt_max_n <= not en_cnt_max;

      en_cnt_en <= r.offset_fifo_rd or en_cnt_max_n;

      if en_cnt_en = '1' then
         if r.offset_fifo_rd = '1' then
            r_nxt.en_cnt <= 0;
         else
            r_nxt.en_cnt <= r.en_cnt+1;
         end if;
      end if;

      if r.reg_chain_en = '1' then
         r_nxt.reg_chain(0) <= pkt_buffer_dout;
         for i in 1 to MAX_BX_IN_EVENT-1 loop
            r_nxt.reg_chain(i) <= r.reg_chain(i-1);
         end loop;
      end if;

      r_nxt.free_addr <= r.reg_chain(MAX_BX_IN_EVENT-1);

      if pkt_req_int = '1' then
         for i in 0 to MAX_BX_IN_EVENT-1 loop
            r_nxt.out_reg(i) <= r.reg_chain(MAX_BX_IN_EVENT-1-i);
         end loop;
      end if;

      reg_chain_en <= not en_cnt_max and not r.first;
      r_nxt.reg_chain_en <= reg_chain_en;
      pkt_req_int <= pkt_req and r.pkt_available;

      set_pkt_available <= r.reg_chain_en and not reg_chain_en;
      avail_mux_ctrl(0) <= pkt_req_int;
      avail_mux_ctrl(1) <= set_pkt_available;

      r_nxt.set_pkt_available <= set_pkt_available;

      if set_pkt_available = '1' then
         r_nxt.first_free <= '0';
      end if;

      set_first_addr <= not r.reg_chain_en and reg_chain_en;
      r_nxt.set_first_addr <= set_first_addr;

      if r.set_first_addr = '1' then
         r_nxt.first_addr <= pkt_buffer_dout;
         r_nxt.free <= not r.first_free;
      end if;

      if unsigned(r.reg_chain(MAX_BX_IN_EVENT-1)) = unsigned(r.first_addr) then
         first_addr_match <= '1';
      else
         first_addr_match <= '0';
      end if;

      rst_free_addr <= r.set_pkt_available or (first_addr_match and not r.set_first_addr);

      --first_addr_match
      if rst_free_addr = '1' then
         r_nxt.free <= '0';
      end if;

      case avail_mux_ctrl is
         when "01" =>   r_nxt.pkt_available <= '0';
         when "10" =>   r_nxt.pkt_available <= '1';
         when others => r_nxt.pkt_available <= r.pkt_available;
      end case;

      nxt_mux_ctrl(0) <= offset_fifo_rd_int;
      nxt_mux_ctrl(1) <= pkt_req_int;

      case nxt_mux_ctrl is
         when "01" =>   r_nxt.nxt <= '0';
         when "10" =>   r_nxt.nxt <= '1';
         when others => r_nxt.nxt <= r.nxt;
      end case;

      -- output signals
      main_ram_addr   <= r.out_reg(to_integer(unsigned(bx_in_event)));
      pkt_buffer_addr <= r.pkt_buffer_addr;
      offset_fifo_rd  <= offset_fifo_rd_int;
      pkt_buffer_rd   <= en_cnt_max_n;
      pkt_available   <= r.pkt_available;

      free_addr <= r.free_addr;
      free <= r.free;

   end process;

   sync: process(daq_clk,daq_rst)
   begin

      if daq_rst = RST_ACT_ROP then
         r <= reg_rst;
      elsif rising_edge(daq_clk) then
         r <= r_nxt;
      end if;

   end process;

end behavioral;

