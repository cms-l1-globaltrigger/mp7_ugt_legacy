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
library ieee;
use ieee.std_logic_1164.all;

use ieee.numeric_std.all;

entity address_manager is
   generic
   (
      ADDR_WIDTH	: integer := 3;
      MEM_DEPTH		: integer := 8;

      MAX_BX_IN_EVENT	: integer := 7;

      RST_ACT_ROP	: std_logic := '0';
      RST_ACT		: std_logic := '1';
      SYNC_STAGES	: integer:= 2
   );
   port
   (
      daq_clk  : in  std_logic;
      daq_rst  : in  std_logic;

      lhc_clk  : in  std_logic;
      lhc_rst  : in  std_logic;

      fdb_addr : in  std_logic_vector (ADDR_WIDTH-1 downto 0);
      fdb_wr   : in  std_logic;

      l1a : in  std_logic;

      ready : out std_logic;

      wr_addr      : out std_logic_vector (ADDR_WIDTH-1 downto 0);
      rd_addr      : out std_logic_vector (ADDR_WIDTH-1 downto 0);
      new_addr     : out std_logic;
      process_addr : out std_logic
   );
end address_manager;

architecture behavioral of address_manager is

   type addr_delay_line_t is array (0 to MAX_BX_IN_EVENT-1) of std_logic_vector(ADDR_WIDTH-1 downto 0);

   type lhc_register_t is record
      addr_dl         : addr_delay_line_t;
      valid_dl        : std_logic_vector(0 to MAX_BX_IN_EVENT-1);
      l1a_dl          : std_logic_vector(0 to MAX_BX_IN_EVENT/2-1);
      addr_fifo_empty : std_logic;
      fdb_mux         : std_logic;
      use_addr        : std_logic;
      new_addr        : std_logic;
      daq_init        : std_logic_vector(0 to SYNC_STAGES-1);
   end record;

   constant lhc_reg_rst : lhc_register_t :=
   (
      addr_dl         => (others => (others => '0')),
      valid_dl        => (others => '0'),
      l1a_dl          => (others => '0'),
      addr_fifo_empty => '0',
      fdb_mux         => '0',
      use_addr        => '0',
      new_addr        => '0',
      daq_init        => (others => '1')
   );

   type daq_register_t is record
      init_cnt        : integer range 0 to MEM_DEPTH;
      init            : std_logic;
   end record;

   constant daq_reg_rst : daq_register_t :=
   (
      init_cnt => 0,
      init     => '1'
   );

   signal addr_fifo_din   : std_logic_vector(ADDR_WIDTH-1 downto 0);
   signal addr_fifo_wr    : std_logic;
   signal addr_fifo_dout  : std_logic_vector(ADDR_WIDTH-1 downto 0);
   signal addr_fifo_empty : std_logic;
   signal addr_fifo_rd    : std_logic;

   signal use_addr_flag : std_logic;
   signal use_addr      : std_logic;

   signal dl_all_valid : std_logic;

   signal lhc_r, lhc_r_nxt : lhc_register_t;
   signal daq_r, daq_r_nxt : daq_register_t;

begin

   addr_fifo: entity work.fifo_2c1r1w
   generic map
   (
      MIN_DEPTH		=> MEM_DEPTH,
      ADDRESS_MANAGER	=> true,
      DATA_WIDTH	=> ADDR_WIDTH
   )
   port map
   (
      wr_clk   => daq_clk,
      wr_res_n => daq_rst,

      rd_clk   => lhc_clk,
      rd_res_n => lhc_rst,

      data_out1 => addr_fifo_dout,
      rd1       => addr_fifo_rd,

      data_in2 => addr_fifo_din,
      wr2      => addr_fifo_wr,

      empty => addr_fifo_empty,
      full  => open
   );

   stretch_unit_inst: entity work.stretch_unit
   generic map
   (
      MAX_BX_IN_EVENT => MAX_BX_IN_EVENT,

      RST_ACT => RST_ACT
   )
   port map
   (
      clk => lhc_clk,
      rst => lhc_rst,

      flag_i => use_addr_flag,
      sig_o  => use_addr
   );

   validity_checker_inst: entity work.validity_checker
   generic map
   (
      MAX_BX_IN_EVENT	=> MAX_BX_IN_EVENT,
      RST_ACT		=> RST_ACT
   )
   port map
   (
      clk => lhc_clk,
      rst => lhc_rst,

      valid_i => lhc_r.valid_dl(0),
      valid_o => dl_all_valid
   );

   lhc_exec: process(lhc_r,l1a,addr_fifo_dout,addr_fifo_empty,dl_all_valid,use_addr,daq_r.init)
      variable fifo_rd : std_logic;
      variable addr_i  : std_logic_vector(ADDR_WIDTH-1 downto 0);
      variable valid_i : std_logic;
      variable use_addr_flag_v : std_logic;
   begin

      lhc_r_nxt <= lhc_r;

      lhc_r_nxt.addr_fifo_empty <= addr_fifo_empty;

      -- l1a delay line
      lhc_r_nxt.l1a_dl(0) <= l1a;
      for i in 1 to MAX_BX_IN_EVENT/2-1 loop
         lhc_r_nxt.l1a_dl(i) <= lhc_r.l1a_dl(i-1);
      end loop;

      -- feedback-mux
      if lhc_r.fdb_mux = '0' then
         addr_i  := lhc_r.addr_dl(MAX_BX_IN_EVENT-1);
         valid_i := lhc_r.valid_dl(MAX_BX_IN_EVENT-1);
      else
         addr_i  := addr_fifo_dout;
         valid_i := not lhc_r.addr_fifo_empty;
      end if;

      -- address and valid-signal delay-line
      lhc_r_nxt.addr_dl(0)  <= addr_i;
      lhc_r_nxt.valid_dl(0) <= valid_i;

      for i in 1 to MAX_BX_IN_EVENT-1 loop
         lhc_r_nxt.addr_dl(i)  <= lhc_r.addr_dl(i-1);
         lhc_r_nxt.valid_dl(i) <= lhc_r.valid_dl(i-1);
      end loop;

      -- use address flag and use address signal
      use_addr_flag_v := valid_i and dl_all_valid and lhc_r.l1a_dl(MAX_BX_IN_EVENT/2-1);
      use_addr_flag      <= use_addr_flag_v;
      lhc_r_nxt.new_addr <= use_addr_flag_v;
      lhc_r_nxt.use_addr <= use_addr;

      -- address fifo induce signals
      fifo_rd := not lhc_r.valid_dl(MAX_BX_IN_EVENT-2) or use_addr;
      addr_fifo_rd  <= fifo_rd;
      lhc_r_nxt.fdb_mux <= fifo_rd;

      -- daq_init synchronizer
      lhc_r_nxt.daq_init(0) <= daq_r.init;
      for i in 1 to SYNC_STAGES-1 loop
         lhc_r_nxt.daq_init(i) <= lhc_r.daq_init(i-1);
      end loop;

      -- output signals
      wr_addr      <= addr_i;
      rd_addr      <= lhc_r.addr_dl(MAX_BX_IN_EVENT-1);
      new_addr     <= lhc_r.new_addr;
      process_addr <= lhc_r.use_addr;
      ready        <= not lhc_r.daq_init(SYNC_STAGES-1);

   end process;

   daq_exec: process(daq_r,fdb_addr,fdb_wr)
   begin

      daq_r_nxt <= daq_r;

      -- init components
      if daq_r.init_cnt = MEM_DEPTH-1 then
         daq_r_nxt.init <= '0';
      else
         daq_r_nxt.init_cnt <= daq_r.init_cnt+1;
      end if;

      if daq_r.init = '1' then
         addr_fifo_din <= std_logic_vector(to_unsigned(daq_r.init_cnt,ADDR_WIDTH));
      else
         addr_fifo_din <= fdb_addr;
      end if;

      addr_fifo_wr <= daq_r.init or fdb_wr;

   end process;

   lhc_sync: process(lhc_clk,lhc_rst)
   begin

      if lhc_rst = RST_ACT then
         lhc_r <= lhc_reg_rst;
      elsif rising_edge(lhc_clk) then
         lhc_r <= lhc_r_nxt;
      end if;

   end process;

   daq_sync: process(daq_clk,daq_rst)
   begin

      if daq_rst = RST_ACT_ROP then
         daq_r <= daq_reg_rst;
      elsif rising_edge(daq_clk) then
         daq_r <= daq_r_nxt;
      end if;

   end process;

end behavioral;

