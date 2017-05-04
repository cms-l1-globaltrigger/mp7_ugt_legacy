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
-- Output logic is now configured for 32-bit. The 64-bit vesion is not more supported, becuase the input vector of MP7 is fixed to 32-bit
-------------------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;
use work.gt_mp7_core_pkg.all;
use work.lhc_data_pkg.all;
use work.output_logic_pkg.all;
use work.rb_pkg.all;

entity output_logic is
   generic
   (
      ADDR_WIDTH : integer := 3
   );
   port
   (
      daq_clk : in  std_logic;
      daq_rst : in  std_logic;

      -- software registers
      sw_reg_in : in  sw_reg_rop_in_t;

      -- interface to address fetch unit
      pkt_available : in  std_logic;
      pkt_req       : out std_logic;

      addr_bx_in_event : out std_logic_vector(log2c(MAX_BX_IN_EVENT)-1 downto 0);

      -- tcm interface
      trigger_nr        : in  trigger_nr_t;
      orbit_nr          : in  orbit_nr_t;
      bx_nr             : in  bx_nr_t;
      luminosity_seg_nr : in  luminosity_seg_nr_t;
      event_nr          : in  event_nr_t;

      -- lhc interface
      lhc_data  : in  lhc_data_t;

      -- fdl interface
      algo_before_pre : in  std_logic_vector(MAX_NR_ALGOS-1 downto 0);
      algo_after_pre  : in  std_logic_vector(MAX_NR_ALGOS-1 downto 0);
      algo_after_mask : in  std_logic_vector(MAX_NR_ALGOS-1 downto 0);

      -- finors
      finors : in  std_logic_vector(FINOR_WIDTH-1 downto 0);

      -- daq interface
      daq_data : out std_logic_vector (DAQ_INPUT_WIDTH-1 downto 0);
      daq_oe   : out std_logic;
      daq_stop : out std_logic;
      daq_busy : in  std_logic
   );
end output_logic;
