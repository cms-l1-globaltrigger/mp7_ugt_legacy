--------------------------------------------------------------------------------
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 14.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
-- $HeadURL:  $
-- $Date:  $
-- $Author: Wittmann $
-- $Revision: 0.1  $
--------------------------------------------------------------------------------
--
-- JW 2015-09-17: started development of testpoint-mux module
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.ipbus.all;
use work.ipbus_reg_types.all;
use work.mp7_data_types.all;
use work.lhc_data_pkg.all;
use work.ipbus_decode_tp_mux.all;
use work.mp7_brd_decl.all;
use work.mp7_ttc_decl.all;
use work.top_decl.all;

entity tp_mux is
    port(
        clk: in std_logic; -- ipbus signals
        rst: in std_logic;
        ipb_in: in ipb_wbus;
        ipb_out: out ipb_rbus;
        clk_payload: in std_logic;
        rst_payload: in std_logic;
        clk_p: in std_logic;
        ctrs: in ttc_stuff_array;
        bc0: in std_logic;
        ec0: in std_logic;
        oc0: in std_logic;
        resync: in std_logic;
        finor: in std_logic;
        veto: in std_logic;
        out0: out std_logic;
        out1: out std_logic;
        out2: out std_logic
    );
end tp_mux;

architecture rtl of tp_mux is
    signal ipb_to_slaves    : ipb_wbus_array(NR_IPB_SLV_TP_MUX-1 downto 0);
    signal ipb_from_slaves  : ipb_rbus_array(NR_IPB_SLV_TP_MUX-1 downto 0);
    signal output_regs : ipb_reg_v(15 downto 0) := (others => (others => '0'));
    signal input_regs  : ipb_reg_v(15 downto 0) := (others => (others => '0'));

    constant TP_MUX_INDEX: integer := 0;
begin

    fabric_i: entity work.ipbus_fabric_sel
    generic map(
        NSLV => NR_IPB_SLV_TP_MUX,
        SEL_WIDTH => IPBUS_SEL_WIDTH)
    port map(
      ipb_in => ipb_in,
      ipb_out => ipb_out,
      sel => ipbus_sel_tp_mux(ipb_in.ipb_addr),
      ipb_to_slaves => ipb_to_slaves,
      ipb_from_slaves => ipb_from_slaves
    );

    -- MUX control register
    --===========================================--
    mux_ctrl_i: entity work.ipbus_ctrlreg_v
    --===========================================--
    generic map(
        N_CTRL => 16,
        N_STAT => 16
    )
    port map
    (
        clk              => clk,
        reset            => rst,
        ipbus_in         => ipb_to_slaves(C_IPB_TP_MUX0),
        ipbus_out        => ipb_from_slaves(C_IPB_TP_MUX0),
        d                => output_regs,
        q                => input_regs,
        stb              => open
    );
    --===========================================--


    out0   <=   finor                                   when    input_regs(TP_MUX_INDEX)(7 downto 0)     =   X"00"     else    --finor signal
                veto                                    when    input_regs(TP_MUX_INDEX)(7 downto 0)     =   X"01"     else    --veto signal
                clk_payload                             when    input_regs(TP_MUX_INDEX)(7 downto 0)     =   X"02"     else    --40MHz clk
                rst_payload                             when    input_regs(TP_MUX_INDEX)(7 downto 0)     =   X"03"     else    --lhc reset
                clk_p                                   when    input_regs(TP_MUX_INDEX)(7 downto 0)     =   X"04"     else    --240MHz clkl
                bc0                                     when    input_regs(TP_MUX_INDEX)(7 downto 0)     =   X"05"     else    --BCRes signal
                ec0                                     when    input_regs(TP_MUX_INDEX)(7 downto 0)     =   X"06"     else    --ECRes signal
                oc0                                     when    input_regs(TP_MUX_INDEX)(7 downto 0)     =   X"07"     else    --OCRes signal
                resync                                  when    input_regs(TP_MUX_INDEX)(7 downto 0)     =   X"08"     else    --Resync signal
                finor;

    out1   <=   finor                                   when    input_regs(TP_MUX_INDEX)(15 downto 8)    =   X"00"     else    --finor signal
                veto                                    when    input_regs(TP_MUX_INDEX)(15 downto 8)    =   X"01"     else    --veto signal
                clk_payload                             when    input_regs(TP_MUX_INDEX)(15 downto 8)    =   X"02"     else    --40MHz clk
                rst_payload                             when    input_regs(TP_MUX_INDEX)(15 downto 8)    =   X"03"     else    --lhc reset
                clk_p                                   when    input_regs(TP_MUX_INDEX)(15 downto 8)    =   X"04"     else    --240MHz clkl
                bc0                                     when    input_regs(TP_MUX_INDEX)(15 downto 8)    =   X"05"     else    --BCRes signal
                ec0                                     when    input_regs(TP_MUX_INDEX)(15 downto 8)    =   X"06"     else    --ECRes signal
                oc0                                     when    input_regs(TP_MUX_INDEX)(15 downto 8)    =   X"07"     else    --OCRes signal
                resync                                  when    input_regs(TP_MUX_INDEX)(15 downto 8)    =   X"08"     else    --Resync signal
                finor;

    out2   <=   finor                                   when    input_regs(TP_MUX_INDEX)(23 downto 16)    =   X"00"     else    --finor signal
                veto                                    when    input_regs(TP_MUX_INDEX)(23 downto 16)    =   X"01"     else    --veto signal
                clk_payload                             when    input_regs(TP_MUX_INDEX)(23 downto 16)    =   X"02"     else    --40MHz clk
                rst_payload                             when    input_regs(TP_MUX_INDEX)(23 downto 16)    =   X"03"     else    --lhc reset
                clk_p                                   when    input_regs(TP_MUX_INDEX)(23 downto 16)    =   X"04"     else    --240MHz clkl
                bc0                                     when    input_regs(TP_MUX_INDEX)(23 downto 16)    =   X"05"     else    --BCRes signal
                ec0                                     when    input_regs(TP_MUX_INDEX)(23 downto 16)    =   X"06"     else    --ECRes signal
                oc0                                     when    input_regs(TP_MUX_INDEX)(23 downto 16)    =   X"07"     else    --OCRes signal
                resync                                  when    input_regs(TP_MUX_INDEX)(23 downto 16)    =   X"08"     else    --Resync signal
                bc0;

end rtl;