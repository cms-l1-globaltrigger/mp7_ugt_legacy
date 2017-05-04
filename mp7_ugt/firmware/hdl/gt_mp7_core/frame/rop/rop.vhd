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
-- $Date: 2015-06-15 $
-- $Author: HEPHY $
-- Warning:  The output dump is not validted systematically based on my .xml concept. If you would like to use the desing, please conatact developer.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;
use work.gt_mp7_core_pkg.all;
use work.lhc_data_pkg.all;
use work.rb_pkg.all;

entity rop is

   port
   (
      -- clk and reset signals
      lhc_clk : in  std_logic;
      lhc_rst : in  std_logic;

      daq_clk : in  std_logic;
      daq_rst : in  std_logic;

      -- sw interface
      sw_reg_in  : in  sw_reg_rop_in_t;
      sw_reg_out : out sw_reg_rop_out_t;

      -- tcm interface
      trigger_nr        : in  trigger_nr_t;
      orbit_nr          : in  orbit_nr_t;
      bx_nr             : in  bx_nr_t;
      luminosity_seg_nr : in  luminosity_seg_nr_t;
      event_nr          : in  event_nr_t;

      -- lhc interface
      lhc_data  : in  lhc_data_t;
      lhc_valid : in  std_logic;

      -- fdl interface
      algo_before_pre : in  std_logic_vector(MAX_NR_ALGOS-1 downto 0);
      algo_after_pre  : in  std_logic_vector(MAX_NR_ALGOS-1 downto 0);
      algo_after_mask : in  std_logic_vector(MAX_NR_ALGOS-1 downto 0);

      -- finors
      finors : in  std_logic_vector(FINOR_WIDTH-1 downto 0);

      -- l1a
      l1a   : in  std_logic;
      ready : out std_logic;

      -- daq interface
      daq_data  : out std_logic_vector (DAQ_INPUT_WIDTH-1 downto 0);
      daq_oe    : out std_logic;
      daq_stop  : out std_logic;
      daq_busy  : in  std_logic

   );

end rop;

architecture behavioral of rop is

   constant ADDR_WIDTH : integer := log2c(MAX_BX_IN_EVENT*MIN_L1A);
   constant MEM_DEPTH  : integer := 2**ADDR_WIDTH;

   type addr_chain_t is array(0 to MAX_BX_IN_EVENT-1) of std_logic_vector(ADDR_WIDTH-1 downto 0);

   type lhc_register_t is record
      pnt      : std_logic_vector(ADDR_WIDTH-1 downto 0);
      pnt_d    : addr_chain_t;
      new_addr : std_logic_vector(0 to MAX_BX_IN_EVENT-1);
   end record;

   constant lhc_reg_rst : lhc_register_t :=
   (
      pnt      => (others => '0'),
      pnt_d    => (others => (others => '0')),
      new_addr => (others => '0')
   );

   -- sw_regs
   signal sw_regs_daq : sw_reg_rop_in_t;

   -- address manager signals
   signal rd_addr_addr_m   : std_logic_vector(ADDR_WIDTH-1 downto 0);
   signal new_addr         : std_logic;
   signal process_addr     : std_logic;

   signal offset_fifo_empty : std_logic;
   signal offset_fifo_rd    : std_logic;
   signal offset_fifo_addr  : std_logic_vector(ADDR_WIDTH-1 downto 0);

   signal pkt_buffer_addr : std_logic_vector(ADDR_WIDTH-1 downto 0);
   signal pkt_buffer_rd   : std_logic;
   signal pkt_buffer_dout : std_logic_vector(ADDR_WIDTH-1 downto 0);

   -- delay line signals
	signal lhc_data_dli : std_logic_vector(LHC_DATA_WIDTH-1 downto 0);
	signal lhc_data_dlo : std_logic_vector(LHC_DATA_WIDTH-1 downto 0);

	signal tcm_dli : std_logic_vector(TRIGGER_NR_WIDTH+ORBIT_NR_WIDTH+BX_NR_WIDTH+LUM_SEG_NR_WIDTH+EVENT_NR_WIDTH-1 downto 0);
	signal tcm_dlo : std_logic_vector(TRIGGER_NR_WIDTH+ORBIT_NR_WIDTH+BX_NR_WIDTH+LUM_SEG_NR_WIDTH+EVENT_NR_WIDTH-1 downto 0);

	signal algos_dli : std_logic_vector(3*MAX_NR_ALGOS-1 downto 0);
	signal algos_dlo : std_logic_vector(3*MAX_NR_ALGOS-1 downto 0);

   -- main ram signals
   signal main_ram_wr_addr : std_logic_vector(ADDR_WIDTH-1 downto 0);
   signal main_ram_rd_addr : std_logic_vector(ADDR_WIDTH-1 downto 0);
   signal main_ram_rd      : std_logic;
   signal main_ram_rd_data : std_logic_vector(MAIN_RAM_DATA_WIDTH-1 downto 0);
   signal main_ram_wr_data : std_logic_vector(MAIN_RAM_DATA_WIDTH-1 downto 0);

   -- output logic signals
   signal lhc_data_int          : lhc_data_t;
   signal algo_after_mask_int   : std_logic_vector(MAX_NR_ALGOS-1 downto 0);
   signal algo_after_pre_int    : std_logic_vector(MAX_NR_ALGOS-1 downto 0);
   signal algo_before_pre_int   : std_logic_vector(MAX_NR_ALGOS-1 downto 0);
   signal event_nr_int          : event_nr_t;
   signal luminosity_seg_nr_int : luminosity_seg_nr_t;
   signal bx_nr_int             : bx_nr_t;
   signal orbit_nr_int          : orbit_nr_t;
   signal trigger_nr_int        : trigger_nr_t;
   signal finors_int            : std_logic_vector(FINOR_WIDTH-1 downto 0);

   signal bx_in_event : std_logic_vector(log2c(MAX_BX_IN_EVENT)-1 downto 0);

   signal pkt_available : std_logic;
   signal pkt_req       : std_logic;

   signal fdb_addr : std_logic_vector(ADDR_WIDTH-1 downto 0);
   signal fdb_wr   : std_logic;

   -- registers
   signal lhc_r, lhc_r_nxt : lhc_register_t := lhc_reg_rst;

begin

------------------------------
-------- assertions ----------
------------------------------

   assert (MAX_BX_IN_EVENT > 1) and (MAX_BX_IN_EVENT mod 2 = 1)
      report "ROP: MAX_BX_IN_EVENT must be greater than 1 and odd!" severity error;

 ------------------------------
-- component instantiations --
------------------------------

----------------------------------------
-- synchronizer for software register --
----------------------------------------

   sw_sync_inst: entity work.rop_sw_reg_synchronizer
   port map
   (
      lhc_clk	=> lhc_clk,
      lhc_rst	=> lhc_rst,

      daq_clk	=> daq_clk,
      daq_rst	=> daq_rst,

      sw_regs_lhc => sw_reg_in,
      sw_regs_daq => sw_regs_daq
   );

---------------------
-- address manager --
---------------------

   addr_manager_inst: entity work.address_manager
   generic map
   (
      ADDR_WIDTH	=> ADDR_WIDTH,
      MEM_DEPTH		=> MEM_DEPTH,

      MAX_BX_IN_EVENT	=> MAX_BX_IN_EVENT,
      RST_ACT_ROP	=> RST_ACT_ROP,
      RST_ACT		=> RST_ACT
   )
   port map
   (
      daq_clk  => daq_clk,
      daq_rst  => daq_rst,

      lhc_clk  => lhc_clk,
      lhc_rst  => lhc_rst,

      fdb_addr => fdb_addr,
      fdb_wr   => fdb_wr,

      l1a => l1a,

      ready => ready,

      wr_addr      => main_ram_wr_addr,
      rd_addr      => rd_addr_addr_m,
      new_addr     => new_addr,
      process_addr => process_addr
   );


------------------------
-- address fetch unit --
------------------------

   addr_fetch_unit_inst: entity work.address_fetch_unit
   generic map
   (
      ADDR_WIDTH => ADDR_WIDTH,
      MEM_DEPTH  => MEM_DEPTH
   )
   port map
   (
      daq_clk			=> daq_clk,
      daq_rst			=> daq_rst,

      offset_fifo_empty		=> offset_fifo_empty,
      offset_fifo_rd		=> offset_fifo_rd,
      offset_fifo_addr		=> offset_fifo_addr,

      pkt_buffer_addr		=> pkt_buffer_addr,
      pkt_buffer_rd		=> pkt_buffer_rd,
      pkt_buffer_dout		=> pkt_buffer_dout,

      bx_in_event		=> bx_in_event,

      pkt_available		=> pkt_available,
      pkt_req			=> pkt_req,

      free_addr			=> fdb_addr,
      free			=> fdb_wr,

      main_ram_addr		=> main_ram_rd_addr,
      main_ram_rd		=> main_ram_rd
   );

-----------------
-- offset fifo --
-----------------

   offset_fifo_inst: entity work.fifo_2c1r1w
   generic map
   (
      MIN_DEPTH 	=> MEM_DEPTH,
      ADDRESS_MANAGER	=> false,
      DATA_WIDTH	=> ADDR_WIDTH
   )
   port map
   (
      wr_clk	=> lhc_clk,
      wr_res_n	=> lhc_rst,

      rd_clk	=> daq_clk,
      rd_res_n	=> daq_rst,

      data_out1	=> offset_fifo_addr,
      rd1	=> offset_fifo_rd,

      data_in2	=> lhc_r.pnt_d(MAX_BX_IN_EVENT-1),
      wr2	=> lhc_r.new_addr(MAX_BX_IN_EVENT-1),

      empty	=> offset_fifo_empty,
      full	=> open
   );

-------------------
-- packet buffer --
-------------------

   pkt_buffer_inst: entity work.ram_2c1w1r
   generic map
   (
      DATA_WIDTH => ADDR_WIDTH,
      SIZE       => MEM_DEPTH
   )
   port map
   (
      wr_clk	=> lhc_clk,
      rd_clk	=> daq_clk,
      wr_en	=> '1',
      wr	=> process_addr,
      rd	=> '1',

    wr_addr	=> lhc_r.pnt,
    rd_addr	=> pkt_buffer_addr,

    rd_data	=> pkt_buffer_dout,
    wr_data	=> rd_addr_addr_m
   );

------------------
-- output logic --
------------------

   output_logic_inst: entity work.output_logic
   generic map
   (
      ADDR_WIDTH => ADDR_WIDTH
   )
   port map
   (
      daq_clk => daq_clk,
      daq_rst => daq_rst,

      -- software registers
      sw_reg_in => sw_regs_daq,

      -- interface to address fetch unit
      pkt_available => pkt_available,
      pkt_req       => pkt_req,

      addr_bx_in_event => bx_in_event,

      -- tcm interface
      trigger_nr        => trigger_nr_int,
      orbit_nr          => orbit_nr_int,
      bx_nr             => bx_nr_int,
      luminosity_seg_nr => luminosity_seg_nr_int,
      event_nr          => event_nr_int,

      -- lhc interface
      lhc_data  => lhc_data_int,

      -- fdl interface
      algo_before_pre => algo_before_pre_int,
      algo_after_pre  => algo_after_pre_int,
      algo_after_mask => algo_after_mask_int,

      -- finors
      finors => finors_int,

      daq_data => daq_data,
      daq_oe   => daq_oe,
      daq_stop => daq_stop,
      daq_busy => daq_busy
   );

-----------------
-- delay lines --
--STATIC_DELAY => 2 for lhc-data
--STATIC_DELAY => 2 for tcm
-- STATIC_DELAY => 0 for algos
-----------------

   lhc_data_dli <= lhc_data_t_to_std_logic_vector(lhc_data);
   tcm_dli      <= trigger_nr & orbit_nr & bx_nr & luminosity_seg_nr & event_nr;
   algos_dli    <= algo_before_pre & algo_after_pre & algo_after_mask;

   lhc_data_dl : entity work.dynamic_delay_line
   generic map
   (
      WIDTH		=> lhc_data_dli'length,
      MAX_DELAY		=> 1,
      STATIC_DELAY	=> 0
   )
   port map
   (
      clk   => lhc_clk,
      rst   => lhc_rst,
      delay => sw_reg_in.lhc_data_delay(0 downto 0),
      sig_i => lhc_data_dli,
      sig_o => lhc_data_dlo
   );

   tcm_dl : entity work.dynamic_delay_line
   generic map
   (
      WIDTH => tcm_dli'length,
      MAX_DELAY => 1,
      STATIC_DELAY => 0
   )
   port map
   (
      clk   => lhc_clk,
      rst   => lhc_rst,
      delay => sw_reg_in.tcm_delay(0 downto 0),
      sig_i => tcm_dli,
      sig_o => tcm_dlo
   );


   algos_dl : entity work.dynamic_delay_line
   generic map
   (
      WIDTH => algos_dli'length,
      MAX_DELAY => 1,
      STATIC_DELAY => 0
   )
   port map
   (
      clk   => lhc_clk,
      rst   => lhc_rst,
      delay => sw_reg_in.algo_delay(0 downto 0),
      sig_i => algos_dli,
      sig_o => algos_dlo
   );

---------------------------------------------------------------------------------------
-- concatenate inputs to one std_logic_vector, which is then written to the main ram --
---------------------------------------------------------------------------------------

   ram_mapping: process(finors,tcm_dlo,algos_dlo,lhc_data_dlo)
   begin

      main_ram_wr_data <= finors & tcm_dlo & algos_dlo & lhc_data_dlo;

   end process;

   main_ram_inst: entity work.ram_2c1w1r
   generic map
   (
      DATA_WIDTH => MAIN_RAM_DATA_WIDTH,
      SIZE       => MEM_DEPTH,

      USE_OUTPUT_REGISTER => false
   )
   port map
   (
      wr_clk  => lhc_clk,
		rd_clk  => daq_clk,

      wr_addr => main_ram_wr_addr,
      wr_data => main_ram_wr_data,
		wr_en   => '1',
		wr      => '1',

		rd_addr => main_ram_rd_addr,
      rd      => main_ram_rd,
		rd_data => main_ram_rd_data
   );

----------------------------------------------------------------------------------------
-- reverse map main ram word to original signals, which are processed by output logic --
----------------------------------------------------------------------------------------

   ram_reverse_mapping: process(main_ram_rd_data)
      variable i : integer := 0;
   begin

      i := 0;
      lhc_data_int <= std_logic_vector_to_lhc_data_t(main_ram_rd_data(i+LHC_DATA_WIDTH-1 downto i));
      i := i+LHC_DATA_WIDTH;
      algo_after_mask_int <= main_ram_rd_data(i+MAX_NR_ALGOS-1 downto i);
      i := i+MAX_NR_ALGOS;
      algo_after_pre_int <= main_ram_rd_data(i+MAX_NR_ALGOS-1 downto i);
      i := i+MAX_NR_ALGOS;
      algo_before_pre_int <= main_ram_rd_data(i+MAX_NR_ALGOS-1 downto i);
      i := i+MAX_NR_ALGOS;
      event_nr_int <= main_ram_rd_data(i+EVENT_NR_WIDTH-1 downto i);
      i := i+EVENT_NR_WIDTH;
      luminosity_seg_nr_int <= main_ram_rd_data(i+LUM_SEG_NR_WIDTH-1 downto i);
      i := i+LUM_SEG_NR_WIDTH;
      bx_nr_int <= main_ram_rd_data(i+BX_NR_WIDTH-1 downto i);
      i := i+BX_NR_WIDTH;
      orbit_nr_int <= main_ram_rd_data(i+ORBIT_NR_WIDTH-1 downto i);
      i := i+ORBIT_NR_WIDTH;
      trigger_nr_int <= main_ram_rd_data(i+TRIGGER_NR_WIDTH-1 downto i);
      i := i+TRIGGER_NR_WIDTH;
      finors_int <= main_ram_rd_data(i+FINOR_WIDTH-1 downto i);
      i := i+FINOR_WIDTH;

   end process;

   lhc_exec: process(lhc_r,process_addr,new_addr)
   begin

      lhc_r_nxt <= lhc_r;

      if process_addr = '1' then
         if to_integer(unsigned(lhc_r.pnt)) = MEM_DEPTH-1 then
            lhc_r_nxt.pnt <= (others => '0');
         else
            lhc_r_nxt.pnt <= std_logic_vector(unsigned(lhc_r.pnt)+1);
         end if;
      end if;

      lhc_r_nxt.pnt_d(0) <= lhc_r.pnt;
      lhc_r_nxt.new_addr(0) <= new_addr;
      for i in 1 to MAX_BX_IN_EVENT-1 loop
         lhc_r_nxt.pnt_d(i) <= lhc_r.pnt_d(i-1);
         lhc_r_nxt.new_addr(i) <= lhc_r.new_addr(i-1);
      end loop;

   end process;

   lhc_sync: process(lhc_clk,lhc_rst)
   begin

--      if lhc_rst = RST_ACT_ROP then
	if lhc_rst = RST_ACT then --change to HB Suggestion
         lhc_r <= lhc_reg_rst;
      elsif rising_edge(lhc_clk) then
         lhc_r <= lhc_r_nxt;
      end if;

   end process;
end behavioral;
