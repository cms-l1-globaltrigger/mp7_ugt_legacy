--------------------------------------------------------------------------------
-- Synthesizer : ISE 13.2
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/uGT_fw_integration/trunk/uGT_algos/firmware/hdl/gt_mp7_core/gtl_fdl_wrapper/gtl/p_m_2_bx_pipeline.vhd $
-- $Date: 2014-05-13 17:16:28 +0200 (Tue, 13 May 2014) $
-- $Author: bergauer $
-- $Revision: 2919 $
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity p_m_2_bx_pipeline is
	port(
        clk		     : in std_logic;
        muon_data    : in muon_objects_array(0 to nr_muon_objects-1);
        muon_bx_p2  : out muon_objects_array(0 to nr_muon_objects-1);
        muon_bx_p1  : out muon_objects_array(0 to nr_muon_objects-1);
        muon_bx_0    : out muon_objects_array(0 to nr_muon_objects-1);
        muon_bx_m1  : out muon_objects_array(0 to nr_muon_objects-1);
        muon_bx_m2  : out muon_objects_array(0 to nr_muon_objects-1);
        eg_data      : in calo_objects_array(0 to nr_eg_objects-1);
        eg_bx_p2    : out calo_objects_array(0 to nr_eg_objects-1);
        eg_bx_p1    : out calo_objects_array(0 to nr_eg_objects-1);
        eg_bx_0      : out calo_objects_array(0 to nr_eg_objects-1);
        eg_bx_m1    : out calo_objects_array(0 to nr_eg_objects-1);
        eg_bx_m2    : out calo_objects_array(0 to nr_eg_objects-1);
        jet_data     : in calo_objects_array(0 to nr_jet_objects-1);
        jet_bx_p2   : out calo_objects_array(0 to nr_jet_objects-1);
        jet_bx_p1   : out calo_objects_array(0 to nr_jet_objects-1);
        jet_bx_0     : out calo_objects_array(0 to nr_jet_objects-1);
        jet_bx_m1   : out calo_objects_array(0 to nr_jet_objects-1);
        jet_bx_m2   : out calo_objects_array(0 to nr_jet_objects-1);
        tau_data     : in calo_objects_array(0 to nr_tau_objects-1);
        tau_bx_p2   : out calo_objects_array(0 to nr_tau_objects-1);
        tau_bx_p1   : out calo_objects_array(0 to nr_tau_objects-1);
        tau_bx_0     : out calo_objects_array(0 to nr_tau_objects-1);
        tau_bx_m1   : out calo_objects_array(0 to nr_tau_objects-1);
        tau_bx_m2   : out calo_objects_array(0 to nr_tau_objects-1);
        ett_data     : in std_logic_vector(max_esums_bits-1 downto 0);
        ett_bx_p2   : out std_logic_vector(max_esums_bits-1 downto 0);
        ett_bx_p1   : out std_logic_vector(max_esums_bits-1 downto 0);
        ett_bx_0     : out std_logic_vector(max_esums_bits-1 downto 0);
        ett_bx_m1   : out std_logic_vector(max_esums_bits-1 downto 0);
        ett_bx_m2   : out std_logic_vector(max_esums_bits-1 downto 0);
        ht_data     : in std_logic_vector(max_esums_bits-1 downto 0);
        ht_bx_p2   : out std_logic_vector(max_esums_bits-1 downto 0);
        ht_bx_p1   : out std_logic_vector(max_esums_bits-1 downto 0);
        ht_bx_0     : out std_logic_vector(max_esums_bits-1 downto 0);
        ht_bx_m1   : out std_logic_vector(max_esums_bits-1 downto 0);
        ht_bx_m2   : out std_logic_vector(max_esums_bits-1 downto 0);
        etm_data     : in std_logic_vector(max_esums_bits-1 downto 0);
        etm_bx_p2   : out std_logic_vector(max_esums_bits-1 downto 0);
        etm_bx_p1   : out std_logic_vector(max_esums_bits-1 downto 0);
        etm_bx_0     : out std_logic_vector(max_esums_bits-1 downto 0);
        etm_bx_m1   : out std_logic_vector(max_esums_bits-1 downto 0);
        etm_bx_m2   : out std_logic_vector(max_esums_bits-1 downto 0);
        htm_data     : in std_logic_vector(max_esums_bits-1 downto 0);
        htm_bx_p2   : out std_logic_vector(max_esums_bits-1 downto 0);
        htm_bx_p1   : out std_logic_vector(max_esums_bits-1 downto 0);
        htm_bx_0     : out std_logic_vector(max_esums_bits-1 downto 0);
        htm_bx_m1   : out std_logic_vector(max_esums_bits-1 downto 0);
        htm_bx_m2   : out std_logic_vector(max_esums_bits-1 downto 0);
        ext_cond_data     : in std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_p2   : out std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_p1   : out std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_0     : out std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_m1   : out std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_m2   : out std_logic_vector(nr_external_conditions-1 downto 0)
    );
end p_m_2_bx_pipeline;

architecture rtl of p_m_2_bx_pipeline is

    signal eg_bx_p1_tmp, eg_bx_0_tmp, eg_bx_m1_tmp, eg_bx_m2_tmp : calo_objects_array(0 to nr_eg_objects-1) := (others => (others => '0'));
    signal jet_bx_p1_tmp, jet_bx_0_tmp, jet_bx_m1_tmp, jet_bx_m2_tmp : calo_objects_array(0 to nr_jet_objects-1) := (others => (others => '0'));
    signal tau_bx_p1_tmp, tau_bx_0_tmp, tau_bx_m1_tmp, tau_bx_m2_tmp : calo_objects_array(0 to nr_tau_objects-1) := (others => (others => '0'));
    signal muon_bx_p1_tmp, muon_bx_0_tmp, muon_bx_m1_tmp, muon_bx_m2_tmp : muon_objects_array(0 to nr_muon_objects-1) := (others => (others => '0'));
    signal ett_bx_p1_tmp, ett_bx_0_tmp, ett_bx_m1_tmp, ett_bx_m2_tmp : std_logic_vector(max_esums_bits-1 downto 0) := (others => '0');
    signal ht_bx_p1_tmp, ht_bx_0_tmp, ht_bx_m1_tmp, ht_bx_m2_tmp : std_logic_vector(max_esums_bits-1 downto 0) := (others => '0');
    signal etm_bx_p1_tmp, etm_bx_0_tmp, etm_bx_m1_tmp, etm_bx_m2_tmp : std_logic_vector(max_esums_bits-1 downto 0) := (others => '0');
    signal htm_bx_p1_tmp, htm_bx_0_tmp, htm_bx_m1_tmp, htm_bx_m2_tmp : std_logic_vector(max_esums_bits-1 downto 0) := (others => '0');
    signal ext_cond_bx_p1_tmp, ext_cond_bx_0_tmp, ext_cond_bx_m1_tmp, ext_cond_bx_m2_tmp : std_logic_vector(nr_external_conditions-1 downto 0) := (others => '0');

begin

process(clk, eg_data, jet_data, tau_data, muon_data, ett_data, ht_data, etm_data, htm_data, ext_cond_data)
    begin
    if (clk'event and clk = '1') then
        muon_bx_p1_tmp <= muon_data;
        muon_bx_0_tmp <= muon_bx_p1_tmp;
        muon_bx_m1_tmp <= muon_bx_0_tmp;
        muon_bx_m2_tmp <= muon_bx_m1_tmp;

        eg_bx_p1_tmp <= eg_data;
        eg_bx_0_tmp <= eg_bx_p1_tmp;
        eg_bx_m1_tmp <= eg_bx_0_tmp;
        eg_bx_m2_tmp <= eg_bx_m1_tmp;

        jet_bx_p1_tmp <= jet_data;
        jet_bx_0_tmp <= jet_bx_p1_tmp;
        jet_bx_m1_tmp <= jet_bx_0_tmp;
        jet_bx_m2_tmp <= jet_bx_m1_tmp;

        tau_bx_p1_tmp <= tau_data;
        tau_bx_0_tmp <= tau_bx_p1_tmp;
        tau_bx_m1_tmp <= tau_bx_0_tmp;
        tau_bx_m2_tmp <= tau_bx_m1_tmp;

        ett_bx_p1_tmp <= ett_data;
        ett_bx_0_tmp <= ett_bx_p1_tmp;
        ett_bx_m1_tmp <= ett_bx_0_tmp;
        ett_bx_m2_tmp <= ett_bx_m1_tmp;

        ht_bx_p1_tmp <= ht_data;
        ht_bx_0_tmp <= ht_bx_p1_tmp;
        ht_bx_m1_tmp <= ht_bx_0_tmp;
        ht_bx_m2_tmp <= ht_bx_m1_tmp;

        etm_bx_p1_tmp <= etm_data;
        etm_bx_0_tmp <= etm_bx_p1_tmp;
        etm_bx_m1_tmp <= etm_bx_0_tmp;
        etm_bx_m2_tmp <= etm_bx_m1_tmp;

        htm_bx_p1_tmp <= htm_data;
        htm_bx_0_tmp <= htm_bx_p1_tmp;
        htm_bx_m1_tmp <= htm_bx_0_tmp;
        htm_bx_m2_tmp <= htm_bx_m1_tmp;

    end if;
end process;

    muon_bx_p2 <= muon_data;
    muon_bx_p1 <= muon_bx_p1_tmp;
    muon_bx_0 <= muon_bx_0_tmp;
    muon_bx_m1 <= muon_bx_m1_tmp;
    muon_bx_m2 <= muon_bx_m2_tmp;

    eg_bx_p2 <= eg_data;
    eg_bx_p1 <= eg_bx_p1_tmp;
    eg_bx_0 <= eg_bx_0_tmp;
    eg_bx_m1 <= eg_bx_m1_tmp;
    eg_bx_m2 <= eg_bx_m2_tmp;

    jet_bx_p2 <= jet_data;
    jet_bx_p1 <= jet_bx_p1_tmp;
    jet_bx_0 <= jet_bx_0_tmp;
    jet_bx_m1 <= jet_bx_m1_tmp;
    jet_bx_m2 <= jet_bx_m2_tmp;

    tau_bx_p2 <= tau_data;
    tau_bx_p1 <= tau_bx_p1_tmp;
    tau_bx_0 <= tau_bx_0_tmp;
    tau_bx_m1 <= tau_bx_m1_tmp;
    tau_bx_m2 <= tau_bx_m2_tmp;

    ett_bx_p2 <= ett_data;
    ett_bx_p1 <= ett_bx_p1_tmp;
    ett_bx_0 <= ett_bx_0_tmp;
    ett_bx_m1 <= ett_bx_m1_tmp;
    ett_bx_m2 <= ett_bx_m2_tmp;

    ht_bx_p2 <= ht_data;
    ht_bx_p1 <= ht_bx_p1_tmp;
    ht_bx_0 <= ht_bx_0_tmp;
    ht_bx_m1 <= ht_bx_m1_tmp;
    ht_bx_m2 <= ht_bx_m2_tmp;

    etm_bx_p2 <= etm_data;
    etm_bx_p1 <= etm_bx_p1_tmp;
    etm_bx_0 <= etm_bx_0_tmp;
    etm_bx_m1 <= etm_bx_m1_tmp;
    etm_bx_m2 <= etm_bx_m2_tmp;

    htm_bx_p2 <= htm_data;
    htm_bx_p1 <= htm_bx_p1_tmp;
    htm_bx_0 <= htm_bx_0_tmp;
    htm_bx_m1 <= htm_bx_m1_tmp;
    htm_bx_m2 <= htm_bx_m2_tmp;

    ext_cond_bx_p2 <= ext_cond_data;
    ext_cond_bx_p1 <= ext_cond_bx_p1_tmp;
    ext_cond_bx_0 <= ext_cond_bx_0_tmp;
    ext_cond_bx_m1 <= ext_cond_bx_m1_tmp;
    ext_cond_bx_m2 <= ext_cond_bx_m2_tmp;

end architecture rtl;
