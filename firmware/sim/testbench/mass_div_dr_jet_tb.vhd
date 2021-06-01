
-- Description:
-- Testbench for simulation of mass div DR

-- Version history:
-- HB 2020-08-25: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.fixed_pkg.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library std;                  -- for Printing
use std.textio.all;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity mass_div_dr_jet_tb is
end mass_div_dr_jet_tb;

architecture beh of mass_div_dr_jet_tb is

    signal lhc_clk : std_logic;

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal jet_bx_0 : calo_objects_array(0 to NR_JET_OBJECTS-1) := (others => X"00000000");

    signal jet_bx_0_pt_vector: diff_inputs_array(0 to NR_JET_OBJECTS-1) := (others => (others => '0'));
    signal jet_bx_0_eta_integer: integer_array(0 to NR_JET_OBJECTS-1) := (others => 0);
    signal jet_bx_0_phi_integer: integer_array(0 to NR_JET_OBJECTS-1) := (others => 0);
    signal jet_bx_0_cos_phi: integer_array(0 to NR_JET_OBJECTS-1) := (others => 0);
    signal jet_bx_0_sin_phi: integer_array(0 to NR_JET_OBJECTS-1) := (others => 0);
    signal jet_bx_0_conv_cos_phi: integer_array(0 to NR_JET_OBJECTS-1) := (others => 0);
    signal jet_bx_0_conv_sin_phi: integer_array(0 to NR_JET_OBJECTS-1) := (others => 0);
    signal jet_bx_0_eta_conv_2_muon_eta_integer: integer_array(0 to NR_JET_OBJECTS-1) := (others => 0);
    signal jet_bx_0_phi_conv_2_muon_phi_integer: integer_array(0 to NR_JET_OBJECTS-1) := (others => 0);

    signal jet_jet_bx_0_bx_0_deta_integer: dim2_max_eta_range_array(0 to NR_JET_OBJECTS-1, 0 to NR_JET_OBJECTS-1) := (others => (others => 0));
    signal jet_jet_bx_0_bx_0_deta_vector: deta_dphi_vector_array(0 to NR_JET_OBJECTS-1, 0 to NR_JET_OBJECTS-1) := (others => (others => (others => '0')));
    signal jet_jet_bx_0_bx_0_dphi_integer: dim2_max_phi_range_array(0 to NR_JET_OBJECTS-1, 0 to NR_JET_OBJECTS-1) := (others => (others => 0));
    signal jet_jet_bx_0_bx_0_dphi_vector: deta_dphi_vector_array(0 to NR_JET_OBJECTS-1, 0 to NR_JET_OBJECTS-1) := (others => (others => (others => '0')));
    signal jet_jet_bx_0_bx_0_mass_over_dr : mass_div_dr_vector_array(0 to NR_JET_OBJECTS-1, 0 to NR_JET_OBJECTS-1) := (others => (others => (others => '0')));

--*********************************Main Body of Code**********************************
begin

    -- Clock
    process
    begin
        lhc_clk  <=  '1';
        wait for LHC_CLK_PERIOD/2;
        lhc_clk  <=  '0';
        wait for LHC_CLK_PERIOD/2;
    end process;

    process
    begin
	wait for LHC_CLK_PERIOD;
        jet_bx_0 <= (others => X"00000000");
	wait for LHC_CLK_PERIOD;
        jet_bx_0 <= (X"00978199", X"0000E1FD", X"0000E1FD", others => X"00000000");
	wait for LHC_CLK_PERIOD;
        jet_bx_0 <= (others => X"00000000");
	wait for LHC_CLK_PERIOD;
        jet_bx_0 <= (X"009781FD", X"0000E1CE", X"0000E1CE", others => X"00000000");
	wait for LHC_CLK_PERIOD;
        jet_bx_0 <= (others => X"00000000");
	wait for LHC_CLK_PERIOD;
        jet_bx_0 <= (X"0006D070", X"0000E080", X"0000E080", others => X"00000000");
	wait for LHC_CLK_PERIOD;
        jet_bx_0 <= (others => X"00000000");
	wait for LHC_CLK_PERIOD;
        jet_bx_0 <= (X"0006D070", X"0000E090", X"0000E090", others => X"00000000");
	wait for LHC_CLK_PERIOD;
        jet_bx_0 <= (others => X"00000000");
	wait for LHC_CLK_PERIOD;
        jet_bx_0 <= (X"00093014", X"00084012", X"00084012", others => X"00000000");
	wait for LHC_CLK_PERIOD;
        jet_bx_0 <= (others => X"00000000");
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------

obj_parameter_jet_bx_0_i: entity work.obj_parameter
    generic map(
        nr_obj => NR_JET_OBJECTS,
        type_obj => JET_TYPE
    )
    port map(
        calo => jet_bx_0,
        phi_conv_2_muon_phi_integer => jet_bx_0_phi_conv_2_muon_phi_integer,
        pt_vector => jet_bx_0_pt_vector,
        eta_integer => jet_bx_0_eta_integer,
        phi_integer => jet_bx_0_phi_integer,
        cos_phi => jet_bx_0_cos_phi,
        sin_phi => jet_bx_0_sin_phi,
        conv_cos_phi => jet_bx_0_conv_cos_phi,
        conv_sin_phi => jet_bx_0_conv_sin_phi
    );

deta_dphi_integer_jet_jet_bx_0_bx_0_i: entity work.deta_dphi_calculations
    generic map(
        nr_obj1 => NR_JET_OBJECTS,
        type_obj1 => JET_TYPE,
        nr_obj2 => NR_JET_OBJECTS,
        type_obj2 => JET_TYPE
    )
    port map(
        eta_integer_obj1 => jet_bx_0_eta_integer,
        phi_integer_obj1 => jet_bx_0_phi_integer,
        eta_integer_obj2 => jet_bx_0_eta_integer,
        phi_integer_obj2 => jet_bx_0_phi_integer,
        deta_integer => jet_jet_bx_0_bx_0_deta_integer,
        dphi_integer => jet_jet_bx_0_bx_0_dphi_integer
    );

mass_over_dr_jet_jet_bx_0_bx_0_i: entity work.correlation_cuts_calculation
    generic map(
        nr_obj1 => NR_JET_OBJECTS,
        type_obj1 => JET_TYPE,
        nr_obj2 => NR_JET_OBJECTS,
        type_obj2 => JET_TYPE,
        pt1_width => JET_PT_VECTOR_WIDTH,
        pt2_width => JET_PT_VECTOR_WIDTH,
        cosh_cos_width => CALO_CALO_COSH_COS_VECTOR_WIDTH,
        mass_over_dr_cut => true,
        rom_sel => CALO_CALO_ROM,
        deta_bins_width => CALO_DETA_BINS_WIDTH_ROM,
        dphi_bins_width => CALO_DETA_BINS_WIDTH_ROM,
        inverted_dr_sq_width => CALO_CALO_INV_DR_SQ_VECTOR_WIDTH
    )
    port map(
        lhc_clk,
        deta_integer => jet_jet_bx_0_bx_0_deta_integer,
        dphi_integer => jet_jet_bx_0_bx_0_dphi_integer,
        pt1 => jet_bx_0_pt_vector,
        pt2 => jet_bx_0_pt_vector,
        mass_over_dr => jet_jet_bx_0_bx_0_mass_over_dr
    );

dut: entity work.correlation_conditions
    generic map(
-- slices for muon
        slice_low_obj1 => 0,
        slice_high_obj1 => 11,
        slice_low_obj2 => 0,
        slice_high_obj2 => 11,
-- obj cuts
        pt_threshold_obj1 => X"0002",
        pt_threshold_obj2 => X"0002",
-- correlation cuts
        mass_cut => true,
        mass_type => INVARIANT_MASS_DIV_DR_TYPE,
        mass_div_dr_vector_width => CALO_CALO_INV_DR_SQ_VECTOR_WIDTH,
        mass_div_dr_threshold => X"00000000000002FAF0800",
-- number of objects and type
        nr_obj1 => NR_JET_OBJECTS,
        type_obj1 => JET_TYPE,
        nr_obj2 => NR_JET_OBJECTS,
        type_obj2 => JET_TYPE,
-- selector same/different bunch crossings
        same_bx => true
    )
    port map(
        lhc_clk,
        calo_obj1 => jet_bx_0,
        calo_obj2 => jet_bx_0,
        mass_div_dr => jet_jet_bx_0_bx_0_mass_over_dr,
        condition_o => open
    );

end beh;

