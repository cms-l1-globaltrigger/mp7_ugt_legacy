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
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/software/l1triggermenu/compiler/trunk/templates/mp7/gtl_pkg.vhd $
-- $Date: 2015-04-28 13:46:23 +0200 (Die, 28 Apr 2015) $
-- $Author: bergauer $
-- $Revision: 3858 $
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.lhc_data_pkg.all;
use work.math_pkg.all;
-- use work.gt_mp7_core_pkg.all;
-- use work.l1tm_pkg.all;

package gtl_pkg is

-- -- Boards
-- constant MAX_NR_GT_BOARDS : positive := 7; -- written by TME ---real available boards
-- constant USED_GT_BOARDS : positive := 1; -- written by TME ---needed by the menu
-- 
-- -- Algorithms
-- constant NR_ALGOS : positive := 16; -- number of algorithmns (min. 32 for FDL registers width !!!) - written by TME
-- 
-- -- ==== FDL definitions - begin ============================================================
-- -- Definitions for prescalers (for FDL !)
-- constant PRESCALER_COUNTER_WIDTH : integer := 24;
-- type prescale_factor_array is array (NR_ALGOS-1 downto 0) of std_logic_vector(31 downto 0); -- same width as PCIe data
-- constant PRESCALE_FACTOR_INIT : ipb_regs_array(0 to MAX_NR_ALGOS-1) := ( others => X"00000001"); -- written by TME
-- 
-- -- Definitions for rate counters
-- constant RATE_COUNTER_WIDTH : integer := 32;
-- type rate_counter_array is array (NR_ALGOS-1 downto 0) of std_logic_vector(RATE_COUNTER_WIDTH-1 downto 0);
-- 
-- -- HB 2014-02-28: changed vector length of init values for finor- and veto-maks, because of min. 32 bits for register
-- constant MASKS_INIT : ipb_regs_array(0 to MAX_NR_ALGOS-1) := ( others => X"00000001"); --Finor and veto masks registers (bit 0 = finor, bit 1 = veto)
-- -- ==== FDL definitions - end ============================================================

-- -- ==== Versions - begin ============================================================
-- -- HB 2015-05-28: see l1tm_pkg.vhd in l1tm/...
-- constant L1TM_UID : std_logic_vector(127 downto 0) := L1TM_L1TM_UID;
-- constant L1TM_NAME : std_logic_vector(128*8-1 downto 0) := L1TM_L1TM_NAME;
-- constant L1TM_FW_UID : std_logic_vector(127 downto 0) := L1TM_L1TM_FW_UID;
-- 
-- -- Trigger Menu Editor software version - written by TME
-- constant L1TM_COMPILER_MAJOR_VERSION      : integer range 0 to 255 := 0;
-- constant L1TM_COMPILER_MINOR_VERSION      : integer range 0 to 255 := 3;
-- constant L1TM_COMPILER_REV_VERSION        : integer range 0 to 255 := 11;
-- constant L1TM_COMPILER_VERSION : std_logic_vector(31 downto 0) := X"00" &
--            std_logic_vector(to_unsigned(L1TM_COMPILER_MAJOR_VERSION, 8)) &
--            std_logic_vector(to_unsigned(L1TM_COMPILER_MINOR_VERSION, 8)) &
--            std_logic_vector(to_unsigned(L1TM_COMPILER_REV_VERSION, 8));
-- 
-- -- HB 2014-09-09: GTL and FDL firmware major, minor and revision versions moved to gt_mp7_core_pkg.vhd (GTL_FW_MAJOR_VERSION, etc.)
-- --                for creating a tag name by a script independent from L1Menu.
-- -- GTL firmware (fix part) version
-- -- constant GTL_FW_MAJOR_VERSION      : integer range 0 to 255 := 1;
-- -- constant GTL_FW_MINOR_VERSION      : integer range 0 to 255 := 2;
-- -- constant GTL_FW_REV_VERSION        : integer range 0 to 255 := 0;
-- constant GTL_FW_VERSION : std_logic_vector(31 downto 0) := X"00" &
--            std_logic_vector(to_unsigned(GTL_FW_MAJOR_VERSION, 8)) &
--            std_logic_vector(to_unsigned(GTL_FW_MINOR_VERSION, 8)) &
--            std_logic_vector(to_unsigned(GTL_FW_REV_VERSION, 8));
-- 
-- -- FDL firmware version
-- -- constant FDL_FW_MAJOR_VERSION      : integer range 0 to 255 := 2;
-- -- constant FDL_FW_MINOR_VERSION      : integer range 0 to 255 := 1;
-- -- constant FDL_FW_REV_VERSION        : integer range 0 to 255 := 0;
-- constant FDL_FW_VERSION : std_logic_vector(31 downto 0) := X"00" &
--            std_logic_vector(to_unsigned(FDL_FW_MAJOR_VERSION, 8)) &
--            std_logic_vector(to_unsigned(FDL_FW_MINOR_VERSION, 8)) &
--            std_logic_vector(to_unsigned(FDL_FW_REV_VERSION, 8));
-- 
-- -- ==== Versions - end ============================================================

-- ==== MUONs - begin ============================================================
-- MUONs
constant NR_MUON_TEMPLATES : positive range 1 to 4 := 4; -- number of max. templates for muon conditions
constant NR_MUON_OBJECTS : positive := MUON_ARRAY_LENGTH; -- from lhc_data_pkg.vhd
constant MAX_MUON_BITS : positive := MUON_DATA_WIDTH; -- from lhc_data_pkg.vhd

type d_s_i_muon_record is record
    charge_high, charge_low, iso_high, iso_low, eta_high, eta_low, qual_high, qual_low, pt_high, pt_low, phi_high, phi_low : natural range MAX_MUON_BITS-1 downto 0;
end record d_s_i_muon_record;

constant d_s_i_muon : d_s_i_muon_record := (35,34,33,32,31,23,22,19,18,10,9,0);

type muon_objects_array is array (natural range <>) of std_logic_vector(MAX_MUON_BITS-1 downto 0);
constant MAX_MUON_TEMPLATES_BITS : positive range 1 to MUON_DATA_WIDTH := 16;
type muon_templates_array is array (1 to NR_MUON_TEMPLATES) of std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);

-- type muon_templates_quality_array is array (1 to NR_MUON_TEMPLATES) of std_logic_vector((2**(d_s_i_muon.qual_high-d_s_i_muon.qual_low+1))-1 downto 0);
type muon_templates_quality_array is array (1 to NR_MUON_TEMPLATES) of std_logic_vector(15 downto 0);
-- type muon_templates_iso_array is array (1 to NR_MUON_TEMPLATES) of std_logic_vector((2**(d_s_i_muon.iso_high-d_s_i_muon.iso_low+1))-1 downto 0);
type muon_templates_iso_array is array (1 to NR_MUON_TEMPLATES) of std_logic_vector(3 downto 0);

type muon_templates_boolean_array is array (1 to NR_MUON_TEMPLATES) of boolean;
type muon_templates_string_array is array (1 to NR_MUON_TEMPLATES) of string(1 to 3);

-- HB 2014-04-15: types for muon_charge_correlations.vhd
type muon_charcorr_double_array is array (0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) of std_logic;
type muon_charcorr_triple_array is array (0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) of std_logic;
type muon_charcorr_quad_array is array (0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) of std_logic;
-- ==== MUONs - end ============================================================

-- ==== CALOs - begin ============================================================
-- CALOs
constant NR_CALO_TEMPLATES : positive range 1 to 4 := 4; -- number of max. templates for calorimeter conditions
constant NR_EG_OBJECTS : positive := EG_ARRAY_LENGTH; -- number eg objects, from lhc_data_pkg.vhd
constant NR_JET_OBJECTS : positive := JET_ARRAY_LENGTH; -- number jet objects, from lhc_data_pkg.vhd
constant NR_TAU_OBJECTS : positive := TAU_ARRAY_LENGTH; -- number tau objects, from lhc_data_pkg.vhd
constant MAX_CALO_BITS : positive := max(EG_DATA_WIDTH, JET_DATA_WIDTH, TAU_DATA_WIDTH);

-- d_s_i_calo_record used for calo_conditions.vhd
type d_s_i_calo_record is record
    phi_high, phi_low, eta_high, eta_low, et_high, et_low : natural range MAX_CALO_BITS-1 downto 0;
end record d_s_i_calo_record;

constant d_s_i_eg : d_s_i_calo_record := (24,17,16,9,8,0);
constant d_s_i_jet : d_s_i_calo_record := (26,19,18,11,10,0);
constant d_s_i_tau : d_s_i_calo_record := (24,17,16,9,8,0);

-- HB 2015-02-16: changed for different "calo_records", each for eg, jet and tau.
-- different records used for calo_conditions_v2.vhd
-- used natural instead of string for object types
constant EG_TYPE : natural range 0 to 2 := 0;
constant JET_TYPE : natural range 0 to 2 := 1;
constant TAU_TYPE : natural range 0 to 2 := 2;

type d_s_i_eg_record is record
    iso_high, iso_low, phi_high, phi_low, eta_high, eta_low, et_high, et_low : natural range MAX_CALO_BITS-1 downto 0;
end record d_s_i_eg_record;

type d_s_i_jet_record is record
    phi_high, phi_low, eta_high, eta_low, et_high, et_low : natural range MAX_CALO_BITS-1 downto 0;
end record d_s_i_jet_record;

type d_s_i_tau_record is record
    iso_high, iso_low, phi_high, phi_low, eta_high, eta_low, et_high, et_low : natural range MAX_CALO_BITS-1 downto 0;
end record d_s_i_tau_record;

constant D_S_I_EG_V2: d_s_i_eg_record := (26,25,24,17,16,9,8,0);
constant D_S_I_JET_V2 : d_s_i_jet_record := (26,19,18,11,10,0);
constant D_S_I_TAU_V2 : d_s_i_tau_record := (26,25,24,17,16,9,8,0);

type calo_objects_array is array (natural range <>) of std_logic_vector(MAX_CALO_BITS-1 downto 0);
constant MAX_CALO_TEMPLATES_BITS : positive range 1 to MAX_CALO_BITS := 16;
type calo_templates_array is array (1 to NR_CALO_TEMPLATES) of std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
type calo_templates_boolean_array is array (1 to NR_CALO_TEMPLATES) of boolean;

-- ESUMs
constant MAX_ESUMS_BITS_TEMP : positive := max(ETT_DATA_WIDTH, HT_DATA_WIDTH, ETM_DATA_WIDTH);
constant MAX_ESUMS_BITS : positive := max(MAX_ESUMS_BITS_TEMP, HTM_DATA_WIDTH);
constant MAX_ESUMS_TEMPLATES_BITS : positive range 1 to MAX_ESUMS_BITS := 16;

constant ETT_TYPE : natural range 0 to 3 := 0;
constant HTT_TYPE : natural range 0 to 3 := 1;
constant ETM_TYPE : natural range 0 to 3 := 2;
constant HTM_TYPE : natural range 0 to 3 := 3;

type d_s_i_ett_record is record
    et_high, et_low : natural range MAX_ESUMS_BITS-1 downto 0;
end record d_s_i_ett_record;

type d_s_i_htt_record is record
    et_high, et_low : natural range MAX_ESUMS_BITS-1 downto 0;
end record d_s_i_htt_record;

type d_s_i_etm_record is record
    phi_high, phi_low, et_high, et_low : natural range MAX_ESUMS_BITS-1 downto 0;
end record d_s_i_etm_record;

type d_s_i_htm_record is record
    phi_high, phi_low, et_high, et_low : natural range MAX_ESUMS_BITS-1 downto 0;
end record d_s_i_htm_record;

constant D_S_I_ETT : d_s_i_ett_record := (11,0);
constant D_S_I_HTT : d_s_i_htt_record := (11,0);
constant D_S_I_ETM : d_s_i_etm_record := (19,12,11,0);
constant D_S_I_HTM : d_s_i_htm_record := (19,12,11,0);
-- ==== CALOs - end ============================================================
-- Correlations

-- Subtractors
constant MAX_DIFF_BITS : positive := 16;
type diff_inputs_array is array (natural range <>) of std_logic_vector(MAX_DIFF_BITS-1 downto 0);
type diff_integer_inputs_array is array (natural range <>) of integer;
type diff_2dim_integer_array is array (natural range <>, natural range <>) of integer;

-- "External conditions" (former "Technical Triggers" and "External Algorithms") definitions
constant NR_EXTERNAL_CONDITIONS : positive := EXTERNAL_CONDITIONS_DATA_WIDTH; -- number of "External conditions" inputs (proposed max. NR_EXTERNAL_CONDITIONS = 256), from lhc_data_pkg.vhd

-- Parameter for sub_phi_obj_vs_obj instances of wsc conditions

constant PHI_HALF_RANGE : positive := 3142; -- or 31415, depends on how many digits after comma used - here 3 digits
-- constant PHI_HALF_RANGE_REAL : real := 3.14159;
constant PHI_HALF_RANGE_REAL : real := 3.14159 * 2;
constant ETA_RANGE_REAL : real := 10.0; -- eta range max.: -5.0 to +5.0
subtype dr_squared_range_real is real range 0.0 to ((ETA_RANGE_REAL**2)+(PHI_HALF_RANGE_REAL**2));
subtype diff_eta_range_real is real range -ETA_RANGE_REAL to ETA_RANGE_REAL;
subtype diff_phi_range_real is real range 0.0 to PHI_HALF_RANGE_REAL;
type diff_eta_2dim_real_array is array (natural range <>, natural range <>) of diff_eta_range_real;
type diff_phi_2dim_real_array is array (natural range <>, natural range <>) of diff_phi_range_real;

constant PHI_BINS_DIV2_eg : positive := 72; -- number of phi bins (144 for calos) divided by 2
constant PHI_BINS_DIV2_jet : positive := 72;
constant PHI_BINS_DIV2_tau : positive := 72;
constant PHI_BINS_DIV2_muon : positive := 288; -- number of phi bins (576 for muon) divided by 2

-- Parameter for sub_eta_obj_vs_obj and sub_phi_obj_vs_obj instances of correlation conditions
-- constant ETA_WIDTH_eg_jet : positive := max((D_S_I_EG_V2.eta_high-D_S_I_EG_V2.eta_low+1), (D_S_I_JET_V2.eta_high-D_S_I_JET_V2.eta_low+1));
-- constant ETA_WIDTH_eg_tau : positive := max((D_S_I_EG_V2.eta_high-D_S_I_EG_V2.eta_low+1), (D_S_I_TAU_V2.eta_high-D_S_I_TAU_V2.eta_low+1));
-- constant ETA_WIDTH_jet_tau : positive := max((D_S_I_TAU_V2.eta_high-D_S_I_TAU_V2.eta_low+1), (D_S_I_JET_V2.eta_high-D_S_I_JET_V2.eta_low+1));
-- constant ETA_WIDTH_eg_muon : positive := (max((D_S_I_EG_V2.eta_high-D_S_I_EG_V2.eta_low+1), (d_s_i_muon.eta_high-d_s_i_muon.eta_low+1)))+2; -- common eta width for calo and muon
-- constant ETA_WIDTH_jet_muon : positive := (max((D_S_I_JET_V2.eta_high-D_S_I_JET_V2.eta_low+1), (d_s_i_muon.eta_high-d_s_i_muon.eta_low+1)))+2;
-- constant ETA_WIDTH_tau_muon : positive := (max((D_S_I_TAU_V2.eta_high-D_S_I_TAU_V2.eta_low+1), (d_s_i_muon.eta_high-d_s_i_muon.eta_low+1)))+2;

constant PHI_WIDTH_eg_jet : positive := max((D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low+1), (D_S_I_JET_V2.phi_high-D_S_I_JET_V2.phi_low+1));
constant PHI_WIDTH_eg_tau : positive := max((D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low+1), (D_S_I_TAU_V2.phi_high-D_S_I_TAU_V2.phi_low+1));
constant PHI_WIDTH_jet_tau : positive := max((D_S_I_TAU_V2.phi_high-D_S_I_TAU_V2.phi_low+1), (D_S_I_JET_V2.phi_high-D_S_I_JET_V2.phi_low+1));
constant PHI_WIDTH_eg_etm : positive := max((D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low+1), (D_S_I_ETM.phi_high-D_S_I_ETM.phi_low+1));
constant PHI_WIDTH_eg_htm : positive := max((D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low+1), (D_S_I_HTM.phi_high-D_S_I_HTM.phi_low+1));
constant PHI_WIDTH_jet_etm : positive := max((D_S_I_JET_V2.phi_high-D_S_I_JET_V2.phi_low+1), (D_S_I_ETM.phi_high-D_S_I_ETM.phi_low+1));
constant PHI_WIDTH_jet_htm : positive := max((D_S_I_JET_V2.phi_high-D_S_I_JET_V2.phi_low+1), (D_S_I_HTM.phi_high-D_S_I_HTM.phi_low+1));
constant PHI_WIDTH_tau_etm : positive := max((D_S_I_TAU_V2.phi_high-D_S_I_TAU_V2.phi_low+1), (D_S_I_ETM.phi_high-D_S_I_ETM.phi_low+1));
constant PHI_WIDTH_tau_htm : positive := max((D_S_I_TAU_V2.phi_high-D_S_I_TAU_V2.phi_low+1), (D_S_I_HTM.phi_high-D_S_I_HTM.phi_low+1));
-- constant PHI_WIDTH_eg_muon : positive := (max((D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low+1), (d_s_i_muon.phi_high-d_s_i_muon.phi_low+1)))+1; ---- common phi width for calo and muon
-- constant PHI_WIDTH_jet_muon : positive := (max((D_S_I_JET_V2.phi_high-D_S_I_JET_V2.phi_low+1), (d_s_i_muon.phi_high-d_s_i_muon.phi_low+1)))+1;
-- constant PHI_WIDTH_tau_muon : positive := (max((D_S_I_TAU_V2.phi_high-D_S_I_TAU_V2.phi_low+1), (d_s_i_muon.phi_high-d_s_i_muon.phi_low+1)))+1;
-- constant PHI_WIDTH_muon_etm : positive := (max((D_S_I_ETM.phi_high-D_S_I_ETM.phi_low+1), (d_s_i_muon.phi_high-d_s_i_muon.phi_low+1)))+1;
-- constant PHI_WIDTH_muon_htm : positive := (max((D_S_I_HTM.phi_high-D_S_I_HTM.phi_low+1), (d_s_i_muon.phi_high-d_s_i_muon.phi_low+1)))+1;
constant PHI_WIDTH_eg_muon : positive := (max((D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low+1), (d_s_i_muon.phi_high-d_s_i_muon.phi_low+1))); ---- common phi width for calo and muon
constant PHI_WIDTH_jet_muon : positive := (max((D_S_I_JET_V2.phi_high-D_S_I_JET_V2.phi_low+1), (d_s_i_muon.phi_high-d_s_i_muon.phi_low+1)));
constant PHI_WIDTH_tau_muon : positive := (max((D_S_I_TAU_V2.phi_high-D_S_I_TAU_V2.phi_low+1), (d_s_i_muon.phi_high-d_s_i_muon.phi_low+1)));
constant PHI_WIDTH_muon_etm : positive := (max((D_S_I_ETM.phi_high-D_S_I_ETM.phi_low+1), (d_s_i_muon.phi_high-d_s_i_muon.phi_low+1)));
constant PHI_WIDTH_muon_htm : positive := (max((D_S_I_HTM.phi_high-D_S_I_HTM.phi_low+1), (d_s_i_muon.phi_high-d_s_i_muon.phi_low+1)));

constant PHI_BINS_DIV2_eg_jet : positive := 72;
constant PHI_BINS_DIV2_eg_tau : positive := 72;
constant PHI_BINS_DIV2_jet_tau : positive := 72;
constant PHI_BINS_DIV2_eg_etm : positive := 72;
constant PHI_BINS_DIV2_eg_htm : positive := 72;
constant PHI_BINS_DIV2_jet_etm : positive := 72;
constant PHI_BINS_DIV2_jet_htm : positive := 72;
constant PHI_BINS_DIV2_tau_etm : positive := 72;
constant PHI_BINS_DIV2_tau_htm : positive := 72;
-- constant PHI_BINS_DIV2_eg_muon : positive := 576; -- number of "common" phi bins (11 bits => 1142 for calo and muon) divided by 2
-- constant PHI_BINS_DIV2_jet_muon : positive := 576;
-- constant PHI_BINS_DIV2_tau_muon : positive := 576;
-- constant PHI_BINS_DIV2_muon_etm : positive := 576;
-- constant PHI_BINS_DIV2_muon_htm : positive := 576;
constant PHI_BINS_DIV2_eg_muon : positive := 288; -- number of "common" phi bins (= muon bins = 10 bits => 576 for calo and muon) divided by 2
constant PHI_BINS_DIV2_jet_muon : positive := 288;
constant PHI_BINS_DIV2_tau_muon : positive := 288;
constant PHI_BINS_DIV2_muon_etm : positive := 288;
constant PHI_BINS_DIV2_muon_htm : positive := 288;

-- *************************************************************************************************************
-- HB 2015-06-12: LUTs for correlation conditions (esums not implemented yet)

constant eg_eta_bits : positive := D_S_I_EG_V2.eta_high-D_S_I_EG_V2.eta_low+1;
constant jet_eta_bits : positive := D_S_I_JET_V2.eta_high-D_S_I_JET_V2.eta_low+1;
constant tau_eta_bits : positive := D_S_I_TAU_V2.eta_high-D_S_I_TAU_V2.eta_low+1;
constant muon_eta_bits : positive := d_s_i_muon.eta_high-d_s_i_muon.eta_low+1;
constant common_eta_bits : positive := 11;

type eg_eta_nonlin_2_lin_lut_array is array (0 to 2**eg_eta_bits-1) of std_logic_vector(eg_eta_bits-1 downto 0);
constant eg_eta_nonlin_2_lin_lut : eg_eta_nonlin_2_lin_lut_array := (
X"00", X"01", X"02", X"03", X"04", X"05", X"06", X"07", X"08", X"09", X"0A", X"0B", X"0C", X"0D", X"0E", X"0F",
X"10", X"11", X"12", X"13", X"14", X"15", X"16", X"17", X"18", X"19", X"1A", X"1B", X"1C", X"1D", X"1E", X"1F",
X"20", X"21", X"22", X"23", X"24", X"25", X"26", X"27", X"28", X"29", X"2A", X"2B", X"2C", X"2D", X"2E", X"2F",
X"30", X"31", X"32", X"33", X"34", X"35", X"36", X"37", X"38", X"39", X"3A", X"3B", X"3C", X"3D", X"3E", X"3F",
X"40", X"41", X"42", X"43", X"44", X"45", X"46", X"47", X"48", X"49", X"4A", X"4B", X"4C", X"4D", X"4E", X"4F",
X"50", X"51", X"52", X"53", X"54", X"55", X"56", X"57", X"58", X"59", X"5A", X"5B", X"5C", X"5D", X"5E", X"5F",
X"60", X"61", X"62", X"63", X"64", X"65", X"66", X"67", X"68", X"69", X"6A", X"6B", X"6C", X"6D", X"6E", X"6F",
X"70", X"71", X"72", X"73", X"74", X"75", X"76", X"77", X"78", X"79", X"7A", X"7B", X"7C", X"7D", X"7E", X"7F",
X"80", X"81", X"82", X"83", X"84", X"85", X"86", X"87", X"88", X"89", X"8A", X"8B", X"8C", X"8D", X"8E", X"8F",
X"90", X"91", X"92", X"93", X"94", X"95", X"96", X"97", X"98", X"99", X"9A", X"9B", X"9C", X"9D", X"9E", X"9F",
X"A0", X"A1", X"A2", X"A3", X"A4", X"A5", X"A6", X"A7", X"A8", X"A9", X"AA", X"AB", X"AC", X"AD", X"AE", X"AF",
X"B0", X"B1", X"B2", X"B3", X"B4", X"B5", X"B6", X"B7", X"B8", X"B9", X"BA", X"BB", X"BC", X"BD", X"BE", X"BF",
X"C0", X"C1", X"C2", X"C3", X"C4", X"C5", X"C6", X"C7", X"C8", X"C9", X"CA", X"CB", X"CC", X"CD", X"CE", X"CF",
X"D0", X"D1", X"D2", X"D3", X"D4", X"D5", X"D6", X"D7", X"D8", X"D9", X"DA", X"DB", X"DC", X"DD", X"DE", X"DF",
X"E0", X"E1", X"E2", X"E3", X"E4", X"E5", X"E6", X"E7", X"E8", X"E9", X"EA", X"EB", X"EC", X"ED", X"EE", X"EF",
X"F0", X"F1", X"F2", X"F3", X"F4", X"F5", X"F6", X"F7", X"F8", X"F9", X"FA", X"FB", X"FC", X"FD", X"FE", X"FF"
);

type jet_eta_nonlin_2_lin_lut_array is array (0 to 2**jet_eta_bits-1) of std_logic_vector(jet_eta_bits-1 downto 0);
constant jet_eta_nonlin_2_lin_lut : jet_eta_nonlin_2_lin_lut_array := (
X"00", X"01", X"02", X"03", X"04", X"05", X"06", X"07", X"08", X"09", X"0A", X"0B", X"0C", X"0D", X"0E", X"0F",
X"10", X"11", X"12", X"13", X"14", X"15", X"16", X"17", X"18", X"19", X"1A", X"1B", X"1C", X"1D", X"1E", X"1F",
X"20", X"21", X"22", X"23", X"24", X"25", X"26", X"27", X"28", X"29", X"2A", X"2B", X"2C", X"2D", X"2E", X"2F",
X"30", X"31", X"32", X"33", X"34", X"35", X"36", X"37", X"38", X"39", X"3A", X"3B", X"3C", X"3D", X"3E", X"3F",
X"40", X"41", X"42", X"43", X"44", X"45", X"46", X"47", X"48", X"49", X"4A", X"4B", X"4C", X"4D", X"4E", X"4F",
X"50", X"51", X"52", X"53", X"54", X"55", X"56", X"57", X"58", X"59", X"5A", X"5B", X"5C", X"5D", X"5E", X"5F",
X"60", X"61", X"62", X"63", X"64", X"65", X"66", X"67", X"68", X"69", X"6A", X"6B", X"6C", X"6D", X"6E", X"6F",
X"70", X"71", X"72", X"73", X"74", X"75", X"76", X"77", X"78", X"79", X"7A", X"7B", X"7C", X"7D", X"7E", X"7F",
X"80", X"81", X"82", X"83", X"84", X"85", X"86", X"87", X"88", X"89", X"8A", X"8B", X"8C", X"8D", X"8E", X"8F",
X"90", X"91", X"92", X"93", X"94", X"95", X"96", X"97", X"98", X"99", X"9A", X"9B", X"9C", X"9D", X"9E", X"9F",
X"A0", X"A1", X"A2", X"A3", X"A4", X"A5", X"A6", X"A7", X"A8", X"A9", X"AA", X"AB", X"AC", X"AD", X"AE", X"AF",
X"B0", X"B1", X"B2", X"B3", X"B4", X"B5", X"B6", X"B7", X"B8", X"B9", X"BA", X"BB", X"BC", X"BD", X"BE", X"BF",
X"C0", X"C1", X"C2", X"C3", X"C4", X"C5", X"C6", X"C7", X"C8", X"C9", X"CA", X"CB", X"CC", X"CD", X"CE", X"CF",
X"D0", X"D1", X"D2", X"D3", X"D4", X"D5", X"D6", X"D7", X"D8", X"D9", X"DA", X"DB", X"DC", X"DD", X"DE", X"DF",
X"E0", X"E1", X"E2", X"E3", X"E4", X"E5", X"E6", X"E7", X"E8", X"E9", X"EA", X"EB", X"EC", X"ED", X"EE", X"EF",
X"F0", X"F1", X"F2", X"F3", X"F4", X"F5", X"F6", X"F7", X"F8", X"F9", X"FA", X"FB", X"FC", X"FD", X"FE", X"FF"
);

type tau_eta_nonlin_2_lin_lut_array is array (0 to 2**tau_eta_bits-1) of std_logic_vector(tau_eta_bits-1 downto 0);
constant tau_eta_nonlin_2_lin_lut : tau_eta_nonlin_2_lin_lut_array := (
X"00", X"01", X"02", X"03", X"04", X"05", X"06", X"07", X"08", X"09", X"0A", X"0B", X"0C", X"0D", X"0E", X"0F",
X"10", X"11", X"12", X"13", X"14", X"15", X"16", X"17", X"18", X"19", X"1A", X"1B", X"1C", X"1D", X"1E", X"1F",
X"20", X"21", X"22", X"23", X"24", X"25", X"26", X"27", X"28", X"29", X"2A", X"2B", X"2C", X"2D", X"2E", X"2F",
X"30", X"31", X"32", X"33", X"34", X"35", X"36", X"37", X"38", X"39", X"3A", X"3B", X"3C", X"3D", X"3E", X"3F",
X"40", X"41", X"42", X"43", X"44", X"45", X"46", X"47", X"48", X"49", X"4A", X"4B", X"4C", X"4D", X"4E", X"4F",
X"50", X"51", X"52", X"53", X"54", X"55", X"56", X"57", X"58", X"59", X"5A", X"5B", X"5C", X"5D", X"5E", X"5F",
X"60", X"61", X"62", X"63", X"64", X"65", X"66", X"67", X"68", X"69", X"6A", X"6B", X"6C", X"6D", X"6E", X"6F",
X"70", X"71", X"72", X"73", X"74", X"75", X"76", X"77", X"78", X"79", X"7A", X"7B", X"7C", X"7D", X"7E", X"7F",
X"80", X"81", X"82", X"83", X"84", X"85", X"86", X"87", X"88", X"89", X"8A", X"8B", X"8C", X"8D", X"8E", X"8F",
X"90", X"91", X"92", X"93", X"94", X"95", X"96", X"97", X"98", X"99", X"9A", X"9B", X"9C", X"9D", X"9E", X"9F",
X"A0", X"A1", X"A2", X"A3", X"A4", X"A5", X"A6", X"A7", X"A8", X"A9", X"AA", X"AB", X"AC", X"AD", X"AE", X"AF",
X"B0", X"B1", X"B2", X"B3", X"B4", X"B5", X"B6", X"B7", X"B8", X"B9", X"BA", X"BB", X"BC", X"BD", X"BE", X"BF",
X"C0", X"C1", X"C2", X"C3", X"C4", X"C5", X"C6", X"C7", X"C8", X"C9", X"CA", X"CB", X"CC", X"CD", X"CE", X"CF",
X"D0", X"D1", X"D2", X"D3", X"D4", X"D5", X"D6", X"D7", X"D8", X"D9", X"DA", X"DB", X"DC", X"DD", X"DE", X"DF",
X"E0", X"E1", X"E2", X"E3", X"E4", X"E5", X"E6", X"E7", X"E8", X"E9", X"EA", X"EB", X"EC", X"ED", X"EE", X"EF",
X"F0", X"F1", X"F2", X"F3", X"F4", X"F5", X"F6", X"F7", X"F8", X"F9", X"FA", X"FB", X"FC", X"FD", X"FE", X"FF"
);

type eg_eta_lin_2_common_lut_array is array (0 to 2**eg_eta_bits-1) of std_logic_vector(common_eta_bits-1 downto 0);
constant eg_eta_lin_2_common_lut : eg_eta_lin_2_common_lut_array := (
"000"&X"03", "000"&X"0B", "000"&X"13", "000"&X"1B", "000"&X"23", "000"&X"2B", "000"&X"33", "000"&X"3B", "000"&X"43", "000"&X"4B", "000"&X"53", "000"&X"5B", "000"&X"63", "000"&X"6B", "000"&X"73", "000"&X"7B",
"000"&X"83", "000"&X"8B", "000"&X"93", "000"&X"9B", "000"&X"A3", "000"&X"AB", "000"&X"B3", "000"&X"BB", "000"&X"C3", "000"&X"CB", "000"&X"D3", "000"&X"DB", "000"&X"E3", "000"&X"EB", "000"&X"F3", "000"&X"FB",
"001"&X"03", "001"&X"0B", "001"&X"13", "001"&X"1B", "001"&X"23", "001"&X"2B", "001"&X"33", "001"&X"3B", "001"&X"43", "001"&X"4B", "001"&X"53", "001"&X"5B", "001"&X"63", "001"&X"6B", "001"&X"73", "001"&X"7B",
"001"&X"83", "001"&X"8B", "001"&X"93", "001"&X"9B", "001"&X"A3", "001"&X"AB", "001"&X"B3", "001"&X"BB", "001"&X"C3", "001"&X"CB", "001"&X"D3", "001"&X"DB", "001"&X"E3", "001"&X"EB", "001"&X"F3", "001"&X"FB",
"010"&X"03", "010"&X"0B", "010"&X"13", "010"&X"1B", "010"&X"23", "010"&X"2B", "010"&X"33", "010"&X"3B", "010"&X"43", "010"&X"4B", "010"&X"53", "010"&X"5B", "010"&X"63", "010"&X"6B", "010"&X"73", "010"&X"7B",
"010"&X"83", "010"&X"8B", "010"&X"93", "010"&X"9B", "010"&X"A3", "010"&X"AB", "010"&X"B3", "010"&X"BB", "010"&X"C3", "010"&X"CB", "010"&X"D3", "010"&X"DB", "010"&X"E3", "010"&X"EB", "010"&X"F3", "010"&X"FB",
"011"&X"03", "011"&X"0B", "011"&X"13", "011"&X"1B", "011"&X"23", "011"&X"2B", "011"&X"33", "011"&X"3B", "011"&X"43", "011"&X"4B", "011"&X"53", "011"&X"5B", "011"&X"63", "011"&X"6B", "011"&X"73", "011"&X"7B",
"011"&X"83", "011"&X"8B", "011"&X"93", "011"&X"9B", "011"&X"A3", "011"&X"AB", "011"&X"B3", "011"&X"BB", "011"&X"C3", "011"&X"CB", "011"&X"D3", "011"&X"DB", "011"&X"E3", "011"&X"EB", "011"&X"F3", "011"&X"FB",
"100"&X"04", "100"&X"0C", "100"&X"14", "100"&X"1C", "100"&X"24", "100"&X"2C", "100"&X"34", "100"&X"3C", "100"&X"44", "100"&X"4C", "100"&X"54", "100"&X"5C", "100"&X"64", "100"&X"6C", "100"&X"74", "100"&X"7C",
"100"&X"84", "100"&X"8C", "100"&X"94", "100"&X"9C", "100"&X"A4", "100"&X"AC", "100"&X"B4", "100"&X"BC", "100"&X"C4", "100"&X"CC", "100"&X"D4", "100"&X"DC", "100"&X"E4", "100"&X"EC", "100"&X"F4", "100"&X"FC",
"101"&X"04", "101"&X"0C", "101"&X"14", "101"&X"1C", "101"&X"24", "101"&X"2C", "101"&X"34", "101"&X"3C", "101"&X"44", "101"&X"4C", "101"&X"54", "101"&X"5C", "101"&X"64", "101"&X"6C", "101"&X"74", "101"&X"7C",
"101"&X"84", "101"&X"8C", "101"&X"94", "101"&X"9C", "101"&X"A4", "101"&X"AC", "101"&X"B4", "101"&X"BC", "101"&X"C4", "101"&X"CC", "101"&X"D4", "101"&X"DC", "101"&X"E4", "101"&X"EC", "101"&X"F4", "101"&X"FC",
"110"&X"04", "110"&X"0C", "110"&X"14", "110"&X"1C", "110"&X"24", "110"&X"2C", "110"&X"34", "110"&X"3C", "110"&X"44", "110"&X"4C", "110"&X"54", "110"&X"5C", "110"&X"64", "110"&X"6C", "110"&X"74", "110"&X"7C",
"110"&X"84", "110"&X"8C", "110"&X"94", "110"&X"9C", "110"&X"A4", "110"&X"AC", "110"&X"B4", "110"&X"BC", "110"&X"C4", "110"&X"CC", "110"&X"D4", "110"&X"DC", "110"&X"E4", "110"&X"EC", "110"&X"F4", "110"&X"FC",
"111"&X"04", "111"&X"0C", "111"&X"14", "111"&X"1C", "111"&X"24", "111"&X"2C", "111"&X"34", "111"&X"3C", "111"&X"44", "111"&X"4C", "111"&X"54", "111"&X"5C", "111"&X"64", "111"&X"6C", "111"&X"74", "111"&X"7C",
"111"&X"84", "111"&X"8C", "111"&X"94", "111"&X"9C", "111"&X"A4", "111"&X"AC", "111"&X"B4", "111"&X"BC", "111"&X"C4", "111"&X"CC", "111"&X"D4", "111"&X"DC", "111"&X"E4", "111"&X"EC", "111"&X"F4", "111"&X"FC"
);

type jet_eta_lin_2_common_lut_array is array (0 to 2**jet_eta_bits-1) of std_logic_vector(common_eta_bits-1 downto 0);
constant jet_eta_lin_2_common_lut : jet_eta_lin_2_common_lut_array := (
"000"&X"03", "000"&X"0B", "000"&X"13", "000"&X"1B", "000"&X"23", "000"&X"2B", "000"&X"33", "000"&X"3B", "000"&X"43", "000"&X"4B", "000"&X"53", "000"&X"5B", "000"&X"63", "000"&X"6B", "000"&X"73", "000"&X"7B",
"000"&X"83", "000"&X"8B", "000"&X"93", "000"&X"9B", "000"&X"A3", "000"&X"AB", "000"&X"B3", "000"&X"BB", "000"&X"C3", "000"&X"CB", "000"&X"D3", "000"&X"DB", "000"&X"E3", "000"&X"EB", "000"&X"F3", "000"&X"FB",
"001"&X"03", "001"&X"0B", "001"&X"13", "001"&X"1B", "001"&X"23", "001"&X"2B", "001"&X"33", "001"&X"3B", "001"&X"43", "001"&X"4B", "001"&X"53", "001"&X"5B", "001"&X"63", "001"&X"6B", "001"&X"73", "001"&X"7B",
"001"&X"83", "001"&X"8B", "001"&X"93", "001"&X"9B", "001"&X"A3", "001"&X"AB", "001"&X"B3", "001"&X"BB", "001"&X"C3", "001"&X"CB", "001"&X"D3", "001"&X"DB", "001"&X"E3", "001"&X"EB", "001"&X"F3", "001"&X"FB",
"010"&X"03", "010"&X"0B", "010"&X"13", "010"&X"1B", "010"&X"23", "010"&X"2B", "010"&X"33", "010"&X"3B", "010"&X"43", "010"&X"4B", "010"&X"53", "010"&X"5B", "010"&X"63", "010"&X"6B", "010"&X"73", "010"&X"7B",
"010"&X"83", "010"&X"8B", "010"&X"93", "010"&X"9B", "010"&X"A3", "010"&X"AB", "010"&X"B3", "010"&X"BB", "010"&X"C3", "010"&X"CB", "010"&X"D3", "010"&X"DB", "010"&X"E3", "010"&X"EB", "010"&X"F3", "010"&X"FB",
"011"&X"03", "011"&X"0B", "011"&X"13", "011"&X"1B", "011"&X"23", "011"&X"2B", "011"&X"33", "011"&X"3B", "011"&X"43", "011"&X"4B", "011"&X"53", "011"&X"5B", "011"&X"63", "011"&X"6B", "011"&X"73", "011"&X"7B",
"011"&X"83", "011"&X"8B", "011"&X"93", "011"&X"9B", "011"&X"A3", "011"&X"AB", "011"&X"B3", "011"&X"BB", "011"&X"C3", "011"&X"CB", "011"&X"D3", "011"&X"DB", "011"&X"E3", "011"&X"EB", "011"&X"F3", "011"&X"FB",
"100"&X"04", "100"&X"0C", "100"&X"14", "100"&X"1C", "100"&X"24", "100"&X"2C", "100"&X"34", "100"&X"3C", "100"&X"44", "100"&X"4C", "100"&X"54", "100"&X"5C", "100"&X"64", "100"&X"6C", "100"&X"74", "100"&X"7C",
"100"&X"84", "100"&X"8C", "100"&X"94", "100"&X"9C", "100"&X"A4", "100"&X"AC", "100"&X"B4", "100"&X"BC", "100"&X"C4", "100"&X"CC", "100"&X"D4", "100"&X"DC", "100"&X"E4", "100"&X"EC", "100"&X"F4", "100"&X"FC",
"101"&X"04", "101"&X"0C", "101"&X"14", "101"&X"1C", "101"&X"24", "101"&X"2C", "101"&X"34", "101"&X"3C", "101"&X"44", "101"&X"4C", "101"&X"54", "101"&X"5C", "101"&X"64", "101"&X"6C", "101"&X"74", "101"&X"7C",
"101"&X"84", "101"&X"8C", "101"&X"94", "101"&X"9C", "101"&X"A4", "101"&X"AC", "101"&X"B4", "101"&X"BC", "101"&X"C4", "101"&X"CC", "101"&X"D4", "101"&X"DC", "101"&X"E4", "101"&X"EC", "101"&X"F4", "101"&X"FC",
"110"&X"04", "110"&X"0C", "110"&X"14", "110"&X"1C", "110"&X"24", "110"&X"2C", "110"&X"34", "110"&X"3C", "110"&X"44", "110"&X"4C", "110"&X"54", "110"&X"5C", "110"&X"64", "110"&X"6C", "110"&X"74", "110"&X"7C",
"110"&X"84", "110"&X"8C", "110"&X"94", "110"&X"9C", "110"&X"A4", "110"&X"AC", "110"&X"B4", "110"&X"BC", "110"&X"C4", "110"&X"CC", "110"&X"D4", "110"&X"DC", "110"&X"E4", "110"&X"EC", "110"&X"F4", "110"&X"FC",
"111"&X"04", "111"&X"0C", "111"&X"14", "111"&X"1C", "111"&X"24", "111"&X"2C", "111"&X"34", "111"&X"3C", "111"&X"44", "111"&X"4C", "111"&X"54", "111"&X"5C", "111"&X"64", "111"&X"6C", "111"&X"74", "111"&X"7C",
"111"&X"84", "111"&X"8C", "111"&X"94", "111"&X"9C", "111"&X"A4", "111"&X"AC", "111"&X"B4", "111"&X"BC", "111"&X"C4", "111"&X"CC", "111"&X"D4", "111"&X"DC", "111"&X"E4", "111"&X"EC", "111"&X"F4", "111"&X"FC"
);

type tau_eta_lin_2_common_lut_array is array (0 to 2**tau_eta_bits-1) of std_logic_vector(common_eta_bits-1 downto 0);
constant tau_eta_lin_2_common_lut : tau_eta_lin_2_common_lut_array := (
"000"&X"03", "000"&X"0B", "000"&X"13", "000"&X"1B", "000"&X"23", "000"&X"2B", "000"&X"33", "000"&X"3B", "000"&X"43", "000"&X"4B", "000"&X"53", "000"&X"5B", "000"&X"63", "000"&X"6B", "000"&X"73", "000"&X"7B",
"000"&X"83", "000"&X"8B", "000"&X"93", "000"&X"9B", "000"&X"A3", "000"&X"AB", "000"&X"B3", "000"&X"BB", "000"&X"C3", "000"&X"CB", "000"&X"D3", "000"&X"DB", "000"&X"E3", "000"&X"EB", "000"&X"F3", "000"&X"FB",
"001"&X"03", "001"&X"0B", "001"&X"13", "001"&X"1B", "001"&X"23", "001"&X"2B", "001"&X"33", "001"&X"3B", "001"&X"43", "001"&X"4B", "001"&X"53", "001"&X"5B", "001"&X"63", "001"&X"6B", "001"&X"73", "001"&X"7B",
"001"&X"83", "001"&X"8B", "001"&X"93", "001"&X"9B", "001"&X"A3", "001"&X"AB", "001"&X"B3", "001"&X"BB", "001"&X"C3", "001"&X"CB", "001"&X"D3", "001"&X"DB", "001"&X"E3", "001"&X"EB", "001"&X"F3", "001"&X"FB",
"010"&X"03", "010"&X"0B", "010"&X"13", "010"&X"1B", "010"&X"23", "010"&X"2B", "010"&X"33", "010"&X"3B", "010"&X"43", "010"&X"4B", "010"&X"53", "010"&X"5B", "010"&X"63", "010"&X"6B", "010"&X"73", "010"&X"7B",
"010"&X"83", "010"&X"8B", "010"&X"93", "010"&X"9B", "010"&X"A3", "010"&X"AB", "010"&X"B3", "010"&X"BB", "010"&X"C3", "010"&X"CB", "010"&X"D3", "010"&X"DB", "010"&X"E3", "010"&X"EB", "010"&X"F3", "010"&X"FB",
"011"&X"03", "011"&X"0B", "011"&X"13", "011"&X"1B", "011"&X"23", "011"&X"2B", "011"&X"33", "011"&X"3B", "011"&X"43", "011"&X"4B", "011"&X"53", "011"&X"5B", "011"&X"63", "011"&X"6B", "011"&X"73", "011"&X"7B",
"011"&X"83", "011"&X"8B", "011"&X"93", "011"&X"9B", "011"&X"A3", "011"&X"AB", "011"&X"B3", "011"&X"BB", "011"&X"C3", "011"&X"CB", "011"&X"D3", "011"&X"DB", "011"&X"E3", "011"&X"EB", "011"&X"F3", "011"&X"FB",
"100"&X"04", "100"&X"0C", "100"&X"14", "100"&X"1C", "100"&X"24", "100"&X"2C", "100"&X"34", "100"&X"3C", "100"&X"44", "100"&X"4C", "100"&X"54", "100"&X"5C", "100"&X"64", "100"&X"6C", "100"&X"74", "100"&X"7C",
"100"&X"84", "100"&X"8C", "100"&X"94", "100"&X"9C", "100"&X"A4", "100"&X"AC", "100"&X"B4", "100"&X"BC", "100"&X"C4", "100"&X"CC", "100"&X"D4", "100"&X"DC", "100"&X"E4", "100"&X"EC", "100"&X"F4", "100"&X"FC",
"101"&X"04", "101"&X"0C", "101"&X"14", "101"&X"1C", "101"&X"24", "101"&X"2C", "101"&X"34", "101"&X"3C", "101"&X"44", "101"&X"4C", "101"&X"54", "101"&X"5C", "101"&X"64", "101"&X"6C", "101"&X"74", "101"&X"7C",
"101"&X"84", "101"&X"8C", "101"&X"94", "101"&X"9C", "101"&X"A4", "101"&X"AC", "101"&X"B4", "101"&X"BC", "101"&X"C4", "101"&X"CC", "101"&X"D4", "101"&X"DC", "101"&X"E4", "101"&X"EC", "101"&X"F4", "101"&X"FC",
"110"&X"04", "110"&X"0C", "110"&X"14", "110"&X"1C", "110"&X"24", "110"&X"2C", "110"&X"34", "110"&X"3C", "110"&X"44", "110"&X"4C", "110"&X"54", "110"&X"5C", "110"&X"64", "110"&X"6C", "110"&X"74", "110"&X"7C",
"110"&X"84", "110"&X"8C", "110"&X"94", "110"&X"9C", "110"&X"A4", "110"&X"AC", "110"&X"B4", "110"&X"BC", "110"&X"C4", "110"&X"CC", "110"&X"D4", "110"&X"DC", "110"&X"E4", "110"&X"EC", "110"&X"F4", "110"&X"FC",
"111"&X"04", "111"&X"0C", "111"&X"14", "111"&X"1C", "111"&X"24", "111"&X"2C", "111"&X"34", "111"&X"3C", "111"&X"44", "111"&X"4C", "111"&X"54", "111"&X"5C", "111"&X"64", "111"&X"6C", "111"&X"74", "111"&X"7C",
"111"&X"84", "111"&X"8C", "111"&X"94", "111"&X"9C", "111"&X"A4", "111"&X"AC", "111"&X"B4", "111"&X"BC", "111"&X"C4", "111"&X"CC", "111"&X"D4", "111"&X"DC", "111"&X"E4", "111"&X"EC", "111"&X"F4", "111"&X"FC"
);

type muon_eta_lin_2_common_lut_array is array (0 to 2**muon_eta_bits-1) of std_logic_vector(common_eta_bits-1 downto 0);
constant muon_eta_lin_2_common_lut : muon_eta_lin_2_common_lut_array := (
"000"&X"01", "000"&X"05", "000"&X"09", "000"&X"0D", "000"&X"11", "000"&X"15", "000"&X"19", "000"&X"1D", 
"000"&X"21", "000"&X"25", "000"&X"29", "000"&X"2D", "000"&X"31", "000"&X"35", "000"&X"39", "000"&X"3D", 
"000"&X"41", "000"&X"45", "000"&X"49", "000"&X"4D", "000"&X"31", "000"&X"35", "000"&X"39", "000"&X"3D", 
"000"&X"61", "000"&X"65", "000"&X"69", "000"&X"6D", "000"&X"71", "000"&X"75", "000"&X"79", "000"&X"7D", 
"000"&X"81", "000"&X"85", "000"&X"89", "000"&X"8D", "000"&X"91", "000"&X"95", "000"&X"99", "000"&X"9D", 
"000"&X"A1", "000"&X"A5", "000"&X"A9", "000"&X"AD", "000"&X"B1", "000"&X"B5", "000"&X"B9", "000"&X"BD", 
"000"&X"C1", "000"&X"C5", "000"&X"C9", "000"&X"CD", "000"&X"D1", "000"&X"D5", "000"&X"D9", "000"&X"DD", 
"000"&X"E1", "000"&X"E5", "000"&X"E9", "000"&X"ED", "000"&X"F1", "000"&X"F5", "000"&X"F9", "000"&X"FD", 
"001"&X"01", "001"&X"05", "001"&X"09", "001"&X"0D", "001"&X"11", "001"&X"15", "001"&X"19", "001"&X"1D", 
"001"&X"21", "001"&X"25", "001"&X"29", "001"&X"2D", "001"&X"31", "001"&X"35", "001"&X"39", "001"&X"3D", 
"001"&X"41", "001"&X"45", "001"&X"49", "001"&X"4D", "001"&X"31", "001"&X"35", "001"&X"39", "001"&X"3D", 
"001"&X"61", "001"&X"65", "001"&X"69", "001"&X"6D", "001"&X"71", "001"&X"75", "001"&X"79", "001"&X"7D", 
"001"&X"81", "001"&X"85", "001"&X"89", "001"&X"8D", "001"&X"91", "001"&X"95", "001"&X"99", "001"&X"9D", 
"001"&X"A1", "001"&X"A5", "001"&X"A9", "001"&X"AD", "001"&X"B1", "001"&X"B5", "001"&X"B9", "001"&X"BD", 
"001"&X"C1", "001"&X"C5", "001"&X"C9", "001"&X"CD", "001"&X"D1", "001"&X"D5", "001"&X"D9", "001"&X"DD", 
"001"&X"E1", "001"&X"E5", "001"&X"E9", "001"&X"ED", "001"&X"F1", "001"&X"F5", "001"&X"F9", "001"&X"FD", 
"010"&X"01", "010"&X"05", "010"&X"09", "010"&X"0D", "010"&X"11", "010"&X"15", "010"&X"19", "010"&X"1D", 
"010"&X"21", "010"&X"25", "010"&X"29", "010"&X"2D", "010"&X"31", "010"&X"35", "010"&X"39", "010"&X"3D", 
"010"&X"41", "010"&X"45", "010"&X"49", "010"&X"4D", "010"&X"31", "010"&X"35", "010"&X"39", "010"&X"3D", 
"010"&X"61", "010"&X"65", "010"&X"69", "010"&X"6D", "010"&X"71", "010"&X"75", "010"&X"79", "010"&X"7D", 
"010"&X"81", "010"&X"85", "010"&X"89", "010"&X"8D", "010"&X"91", "010"&X"95", "010"&X"99", "010"&X"9D", 
"010"&X"A1", "010"&X"A5", "010"&X"A9", "010"&X"AD", "010"&X"B1", "010"&X"B5", "010"&X"B9", "010"&X"BD", 
"010"&X"C1", "010"&X"C5", "010"&X"C9", "010"&X"CD", "010"&X"D1", "010"&X"D5", "010"&X"D9", "010"&X"DD", 
"010"&X"E1", "010"&X"E5", "010"&X"E9", "010"&X"ED", "010"&X"F1", "010"&X"F5", "010"&X"F9", "010"&X"FD", 
"011"&X"01", "011"&X"05", "011"&X"09", "011"&X"0D", "011"&X"11", "011"&X"15", "011"&X"19", "011"&X"1D", 
"011"&X"21", "011"&X"25", "011"&X"29", "011"&X"2D", "011"&X"31", "011"&X"35", "011"&X"39", "011"&X"3D", 
"011"&X"41", "011"&X"45", "011"&X"49", "011"&X"4D", "011"&X"31", "011"&X"35", "011"&X"39", "011"&X"3D", 
"011"&X"61", "011"&X"65", "011"&X"69", "011"&X"6D", "011"&X"71", "011"&X"75", "011"&X"79", "011"&X"7D", 
"011"&X"81", "011"&X"85", "011"&X"89", "011"&X"8D", "011"&X"91", "011"&X"95", "011"&X"99", "011"&X"9D", 
"011"&X"A1", "011"&X"A5", "011"&X"A9", "011"&X"AD", "011"&X"B1", "011"&X"B5", "011"&X"B9", "011"&X"BD", 
"011"&X"C1", "011"&X"C5", "011"&X"C9", "011"&X"CD", "011"&X"D1", "011"&X"D5", "011"&X"D9", "011"&X"DD", 
"011"&X"E1", "011"&X"E5", "011"&X"E9", "011"&X"ED", "011"&X"F1", "011"&X"F5", "011"&X"F9", "011"&X"FD", 
"100"&X"02", "100"&X"06", "100"&X"0A", "100"&X"0E", "100"&X"10", "100"&X"16", "100"&X"1A", "100"&X"1E",
"100"&X"22", "100"&X"26", "100"&X"2A", "100"&X"2E", "100"&X"30", "100"&X"36", "100"&X"3A", "100"&X"3E",
"100"&X"42", "100"&X"46", "100"&X"4A", "100"&X"4E", "100"&X"50", "100"&X"56", "100"&X"5A", "100"&X"5E",
"100"&X"62", "100"&X"66", "100"&X"6A", "100"&X"6E", "100"&X"70", "100"&X"76", "100"&X"7A", "100"&X"7E",
"100"&X"82", "100"&X"86", "100"&X"8A", "100"&X"8E", "100"&X"90", "100"&X"96", "100"&X"9A", "100"&X"9E",
"100"&X"A2", "100"&X"A6", "100"&X"AA", "100"&X"AE", "100"&X"B0", "100"&X"B6", "100"&X"BA", "100"&X"BE",
"100"&X"C2", "100"&X"C6", "100"&X"CA", "100"&X"CE", "100"&X"D0", "100"&X"D6", "100"&X"DA", "100"&X"DE",
"100"&X"E2", "100"&X"E6", "100"&X"EA", "100"&X"EE", "100"&X"F0", "100"&X"F6", "100"&X"FA", "100"&X"FE",
"101"&X"02", "101"&X"06", "101"&X"0A", "101"&X"0E", "101"&X"10", "101"&X"16", "101"&X"1A", "101"&X"1E",
"101"&X"22", "101"&X"26", "101"&X"2A", "101"&X"2E", "101"&X"30", "101"&X"36", "101"&X"3A", "101"&X"3E",
"101"&X"42", "101"&X"46", "101"&X"4A", "101"&X"4E", "101"&X"50", "101"&X"56", "101"&X"5A", "101"&X"5E",
"101"&X"62", "101"&X"66", "101"&X"6A", "101"&X"6E", "101"&X"70", "101"&X"76", "101"&X"7A", "101"&X"7E",
"101"&X"82", "101"&X"86", "101"&X"8A", "101"&X"8E", "101"&X"90", "101"&X"96", "101"&X"9A", "101"&X"9E",
"101"&X"A2", "101"&X"A6", "101"&X"AA", "101"&X"AE", "101"&X"B0", "101"&X"B6", "101"&X"BA", "101"&X"BE",
"101"&X"C2", "101"&X"C6", "101"&X"CA", "101"&X"CE", "101"&X"D0", "101"&X"D6", "101"&X"DA", "101"&X"DE",
"101"&X"E2", "101"&X"E6", "101"&X"EA", "101"&X"EE", "101"&X"F0", "101"&X"F6", "101"&X"FA", "101"&X"FE",
"110"&X"02", "110"&X"06", "110"&X"0A", "110"&X"0E", "110"&X"10", "110"&X"16", "110"&X"1A", "110"&X"1E",
"110"&X"22", "110"&X"26", "110"&X"2A", "110"&X"2E", "110"&X"30", "110"&X"36", "110"&X"3A", "110"&X"3E",
"110"&X"42", "110"&X"46", "110"&X"4A", "110"&X"4E", "110"&X"50", "110"&X"56", "110"&X"5A", "110"&X"5E",
"110"&X"62", "110"&X"66", "110"&X"6A", "110"&X"6E", "110"&X"70", "110"&X"76", "110"&X"7A", "110"&X"7E",
"110"&X"82", "110"&X"86", "110"&X"8A", "110"&X"8E", "110"&X"90", "110"&X"96", "110"&X"9A", "110"&X"9E",
"110"&X"A2", "110"&X"A6", "110"&X"AA", "110"&X"AE", "110"&X"B0", "110"&X"B6", "110"&X"BA", "110"&X"BE",
"110"&X"C2", "110"&X"C6", "110"&X"CA", "110"&X"CE", "110"&X"D0", "110"&X"D6", "110"&X"DA", "110"&X"DE",
"110"&X"E2", "110"&X"E6", "110"&X"EA", "110"&X"EE", "110"&X"F0", "110"&X"F6", "110"&X"FA", "110"&X"FE",
"111"&X"02", "111"&X"06", "111"&X"0A", "111"&X"0E", "111"&X"10", "111"&X"16", "111"&X"1A", "111"&X"1E",
"111"&X"22", "111"&X"26", "111"&X"2A", "111"&X"2E", "111"&X"30", "111"&X"36", "111"&X"3A", "111"&X"3E",
"111"&X"42", "111"&X"46", "111"&X"4A", "111"&X"4E", "111"&X"50", "111"&X"56", "111"&X"5A", "111"&X"5E",
"111"&X"62", "111"&X"66", "111"&X"6A", "111"&X"6E", "111"&X"70", "111"&X"76", "111"&X"7A", "111"&X"7E",
"111"&X"82", "111"&X"86", "111"&X"8A", "111"&X"8E", "111"&X"90", "111"&X"96", "111"&X"9A", "111"&X"9E",
"111"&X"A2", "111"&X"A6", "111"&X"AA", "111"&X"AE", "111"&X"B0", "111"&X"B6", "111"&X"BA", "111"&X"BE",
"111"&X"C2", "111"&X"C6", "111"&X"CA", "111"&X"CE", "111"&X"D0", "111"&X"D6", "111"&X"DA", "111"&X"DE",
"111"&X"E2", "111"&X"E6", "111"&X"EA", "111"&X"EE", "111"&X"F0", "111"&X"F6", "111"&X"FA", "111"&X"FE");

-- see ../src/../gtl/calo_eta_scales_luts.ods

type eg_eta_scale_array is array (0 to 2**eg_eta_bits-1) of real;
constant eg_eta_real_lut : eg_eta_scale_array := (
0.02175, 0.06525, 0.10875, 0.15225, 0.19575, 0.23925, 0.28275, 0.32625, 0.36975, 0.41325, 0.45675, 0.50025, 0.54375, 0.58725, 0.63075, 0.67425,
0.71775, 0.76125, 0.80475, 0.84825, 0.89175, 0.93525, 0.97875, 1.02225, 1.06575, 1.10925, 1.15275, 1.19625, 1.23975, 1.28325, 1.32675, 1.37025,
1.41375, 1.45725, 1.50075, 1.54425, 1.58775, 1.63125, 1.67475, 1.71825, 1.76175, 1.80525, 1.84875, 1.89225, 1.93575, 1.97925, 2.02275, 2.06625,
2.10975, 2.15325, 2.19675, 2.24025, 2.28375, 2.32725, 2.37075, 2.41425, 2.45775, 2.50125, 2.54475, 2.58825, 2.63175, 2.67525, 2.71875, 2.76225,
2.80575, 2.84925, 2.89275, 2.93625, 2.97975, 3.02325, 3.06675, 3.11025, 3.15375, 3.19725, 3.24075, 3.28425, 3.32775, 3.37125, 3.41475, 3.45825,
3.50175, 3.54525, 3.58875, 3.63225, 3.67575, 3.71925, 3.76275, 3.80625, 3.84975, 3.89325, 3.93675, 3.98025, 4.02375, 4.06725, 4.11075, 4.15425,
4.19775, 4.24125, 4.28475, 4.32825, 4.37175, 4.41525, 4.45875, 4.50225, 4.54575, 4.58925, 4.63275, 4.67625, 4.71975, 4.76325, 4.80675, 4.85025,
4.89375, 4.93725, 4.98075, 5.02425, 5.06775, 5.11125, 5.15475, 5.19825, 5.24175, 5.28525, 5.32875, 5.37225, 5.41575, 5.45925, 5.50275, 5.54625,
-5.54625, -5.50275, -5.45925, -5.41575, -5.37225, -5.32875, -5.28525, -5.24175, -5.19825, -5.15475, -5.11125, -5.06775, -5.02425, -4.98075, 4.93725, -4.89375,
-4.85025, -4.80675, -4.76325, -4.71975, -4.67625, -4.63275, -4.58925, -4.54575, -4.50225, -4.45875, -4.41525, -4.37175, -4.32825, -4.28475, 4.24125, -4.19775,
-4.15425, -4.11075, -4.06725, -4.02375, -3.98025, -3.93675, -3.89325, -3.84975, -3.80625, -3.76275, -3.71925, -3.67575, -3.63225, -3.58875, 3.54525, -3.50175,
-3.45825, -3.41475, -3.37125, -3.32775, -3.28425, -3.24075, -3.19725, -3.15375, -3.11025, -3.06675, -3.02325, -2.97975, -2.93625, -2.89275, 2.84925, -2.80575,
-2.76225, -2.71875, -2.67525, -2.63175, -2.58825, -2.54475, -2.50125, -2.45775, -2.41425, -2.37075, -2.32725, -2.28375, -2.24025, -2.19675, 2.15325, -2.10975,
-2.06625, -2.02275, -1.97925, -1.93575, -1.89225, -1.84875, -1.80525, -1.76175, -1.71825, -1.67475, -1.63125, -1.58775, -1.54425, -1.50075, 1.45725, -1.41375,
-1.37025, -1.32675, -1.28325, -1.23975, -1.19625, -1.15275, -1.10925, -1.06575, -1.02225, -0.97875, -0.93525, -0.89175, -0.84825, -0.80475, 0.76125, -0.71775,
-0.67425, -0.63075, -0.58725, -0.54375, -0.50025, -0.45675, -0.41325, -0.36975, -0.32625, -0.28275, -0.23925, -0.19575, -0.15225, -0.10875, 0.06525, -0.02175
);

type jet_eta_scale_array is array (0 to 2**jet_eta_bits-1) of real;
constant jet_eta_real_lut : jet_eta_scale_array := (
0.02175, 0.06525, 0.10875, 0.15225, 0.19575, 0.23925, 0.28275, 0.32625, 0.36975, 0.41325, 0.45675, 0.50025, 0.54375, 0.58725, 0.63075, 0.67425,
0.71775, 0.76125, 0.80475, 0.84825, 0.89175, 0.93525, 0.97875, 1.02225, 1.06575, 1.10925, 1.15275, 1.19625, 1.23975, 1.28325, 1.32675, 1.37025,
1.41375, 1.45725, 1.50075, 1.54425, 1.58775, 1.63125, 1.67475, 1.71825, 1.76175, 1.80525, 1.84875, 1.89225, 1.93575, 1.97925, 2.02275, 2.06625,
2.10975, 2.15325, 2.19675, 2.24025, 2.28375, 2.32725, 2.37075, 2.41425, 2.45775, 2.50125, 2.54475, 2.58825, 2.63175, 2.67525, 2.71875, 2.76225,
2.80575, 2.84925, 2.89275, 2.93625, 2.97975, 3.02325, 3.06675, 3.11025, 3.15375, 3.19725, 3.24075, 3.28425, 3.32775, 3.37125, 3.41475, 3.45825,
3.50175, 3.54525, 3.58875, 3.63225, 3.67575, 3.71925, 3.76275, 3.80625, 3.84975, 3.89325, 3.93675, 3.98025, 4.02375, 4.06725, 4.11075, 4.15425,
4.19775, 4.24125, 4.28475, 4.32825, 4.37175, 4.41525, 4.45875, 4.50225, 4.54575, 4.58925, 4.63275, 4.67625, 4.71975, 4.76325, 4.80675, 4.85025,
4.89375, 4.93725, 4.98075, 5.02425, 5.06775, 5.11125, 5.15475, 5.19825, 5.24175, 5.28525, 5.32875, 5.37225, 5.41575, 5.45925, 5.50275, 5.54625,
-5.54625, -5.50275, -5.45925, -5.41575, -5.37225, -5.32875, -5.28525, -5.24175, -5.19825, -5.15475, -5.11125, -5.06775, -5.02425, -4.98075, 4.93725, -4.89375,
-4.85025, -4.80675, -4.76325, -4.71975, -4.67625, -4.63275, -4.58925, -4.54575, -4.50225, -4.45875, -4.41525, -4.37175, -4.32825, -4.28475, 4.24125, -4.19775,
-4.15425, -4.11075, -4.06725, -4.02375, -3.98025, -3.93675, -3.89325, -3.84975, -3.80625, -3.76275, -3.71925, -3.67575, -3.63225, -3.58875, 3.54525, -3.50175,
-3.45825, -3.41475, -3.37125, -3.32775, -3.28425, -3.24075, -3.19725, -3.15375, -3.11025, -3.06675, -3.02325, -2.97975, -2.93625, -2.89275, 2.84925, -2.80575,
-2.76225, -2.71875, -2.67525, -2.63175, -2.58825, -2.54475, -2.50125, -2.45775, -2.41425, -2.37075, -2.32725, -2.28375, -2.24025, -2.19675, 2.15325, -2.10975,
-2.06625, -2.02275, -1.97925, -1.93575, -1.89225, -1.84875, -1.80525, -1.76175, -1.71825, -1.67475, -1.63125, -1.58775, -1.54425, -1.50075, 1.45725, -1.41375,
-1.37025, -1.32675, -1.28325, -1.23975, -1.19625, -1.15275, -1.10925, -1.06575, -1.02225, -0.97875, -0.93525, -0.89175, -0.84825, -0.80475, 0.76125, -0.71775,
-0.67425, -0.63075, -0.58725, -0.54375, -0.50025, -0.45675, -0.41325, -0.36975, -0.32625, -0.28275, -0.23925, -0.19575, -0.15225, -0.10875, 0.06525, -0.02175
);

type tau_eta_scale_array is array (0 to 2**tau_eta_bits-1) of real;
constant tau_eta_real_lut : tau_eta_scale_array := (
0.02175, 0.06525, 0.10875, 0.15225, 0.19575, 0.23925, 0.28275, 0.32625, 0.36975, 0.41325, 0.45675, 0.50025, 0.54375, 0.58725, 0.63075, 0.67425,
0.71775, 0.76125, 0.80475, 0.84825, 0.89175, 0.93525, 0.97875, 1.02225, 1.06575, 1.10925, 1.15275, 1.19625, 1.23975, 1.28325, 1.32675, 1.37025,
1.41375, 1.45725, 1.50075, 1.54425, 1.58775, 1.63125, 1.67475, 1.71825, 1.76175, 1.80525, 1.84875, 1.89225, 1.93575, 1.97925, 2.02275, 2.06625,
2.10975, 2.15325, 2.19675, 2.24025, 2.28375, 2.32725, 2.37075, 2.41425, 2.45775, 2.50125, 2.54475, 2.58825, 2.63175, 2.67525, 2.71875, 2.76225,
2.80575, 2.84925, 2.89275, 2.93625, 2.97975, 3.02325, 3.06675, 3.11025, 3.15375, 3.19725, 3.24075, 3.28425, 3.32775, 3.37125, 3.41475, 3.45825,
3.50175, 3.54525, 3.58875, 3.63225, 3.67575, 3.71925, 3.76275, 3.80625, 3.84975, 3.89325, 3.93675, 3.98025, 4.02375, 4.06725, 4.11075, 4.15425,
4.19775, 4.24125, 4.28475, 4.32825, 4.37175, 4.41525, 4.45875, 4.50225, 4.54575, 4.58925, 4.63275, 4.67625, 4.71975, 4.76325, 4.80675, 4.85025,
4.89375, 4.93725, 4.98075, 5.02425, 5.06775, 5.11125, 5.15475, 5.19825, 5.24175, 5.28525, 5.32875, 5.37225, 5.41575, 5.45925, 5.50275, 5.54625,
-5.54625, -5.50275, -5.45925, -5.41575, -5.37225, -5.32875, -5.28525, -5.24175, -5.19825, -5.15475, -5.11125, -5.06775, -5.02425, -4.98075, 4.93725, -4.89375,
-4.85025, -4.80675, -4.76325, -4.71975, -4.67625, -4.63275, -4.58925, -4.54575, -4.50225, -4.45875, -4.41525, -4.37175, -4.32825, -4.28475, 4.24125, -4.19775,
-4.15425, -4.11075, -4.06725, -4.02375, -3.98025, -3.93675, -3.89325, -3.84975, -3.80625, -3.76275, -3.71925, -3.67575, -3.63225, -3.58875, 3.54525, -3.50175,
-3.45825, -3.41475, -3.37125, -3.32775, -3.28425, -3.24075, -3.19725, -3.15375, -3.11025, -3.06675, -3.02325, -2.97975, -2.93625, -2.89275, 2.84925, -2.80575,
-2.76225, -2.71875, -2.67525, -2.63175, -2.58825, -2.54475, -2.50125, -2.45775, -2.41425, -2.37075, -2.32725, -2.28375, -2.24025, -2.19675, 2.15325, -2.10975,
-2.06625, -2.02275, -1.97925, -1.93575, -1.89225, -1.84875, -1.80525, -1.76175, -1.71825, -1.67475, -1.63125, -1.58775, -1.54425, -1.50075, 1.45725, -1.41375,
-1.37025, -1.32675, -1.28325, -1.23975, -1.19625, -1.15275, -1.10925, -1.06575, -1.02225, -0.97875, -0.93525, -0.89175, -0.84825, -0.80475, 0.76125, -0.71775,
-0.67425, -0.63075, -0.58725, -0.54375, -0.50025, -0.45675, -0.41325, -0.36975, -0.32625, -0.28275, -0.23925, -0.19575, -0.15225, -0.10875, 0.06525, -0.02175
);

-- muon_eta_real_lut is used as "common" scale for correlations, too
type muon_eta_scale_array is array (0 to 2**muon_eta_bits-1) of real;
constant muon_eta_real_lut : muon_eta_scale_array := (
0.0054375, 0.010875, 0.0163125, 0.02175, 0.0271875, 0.032625, 0.0380625, 0.0435, 0.0489375, 0.054375, 0.0598125, 0.06525, 0.0706875, 0.076125, 0.0815625, 0.087,
0.1794375, 0.184875, 0.1903125, 0.19575, 0.2011875, 0.206625, 0.2120625, 0.2175, 0.2229375, 0.228375, 0.2338125, 0.23925, 0.2446875, 0.250125, 0.2555625, 0.261,
0.3534375, 0.358875, 0.3643125, 0.36975, 0.3751875, 0.380625, 0.3860625, 0.3915, 0.3969375, 0.402375, 0.4078125, 0.41325, 0.4186875, 0.424125, 0.4295625, 0.435,
0.5274375, 0.532875, 0.5383125, 0.54375, 0.5491875, 0.554625, 0.5600625, 0.5655, 0.5709375, 0.576375, 0.5818125, 0.58725, 0.5926875, 0.598125, 0.6035625, 0.609,
0.7014375, 0.706875, 0.7123125, 0.71775, 0.7231875, 0.728625, 0.7340625, 0.7395, 0.7449375, 0.750375, 0.7558125, 0.76125, 0.7666875, 0.772125, 0.7775625, 0.783,
0.8754375, 0.880875, 0.8863125, 0.89175, 0.8971875, 0.902625, 0.9080625, 0.9135, 0.9189375, 0.924375, 0.9298125, 0.93525, 0.9406875, 0.946125, 0.9515625, 0.957,
1.0494375, 1.054875, 1.0603125, 1.06575, 1.0711875, 1.076625, 1.0820625, 1.0875, 1.0929375, 1.098375, 1.1038125, 1.10925, 1.1146875, 1.120125, 1.1255625, 1.131,
1.2234375, 1.228875, 1.2343125, 1.23975, 1.2451875, 1.250625, 1.2560625, 1.2615, 1.2669375, 1.272375, 1.2778125, 1.28325, 1.2886875, 1.294125, 1.2995625, 1.305,
1.3974375, 1.402875, 1.4083125, 1.41375, 1.4191875, 1.424625, 1.4300625, 1.4355, 1.4409375, 1.446375, 1.4518125, 1.45725, 1.4626875, 1.468125, 1.4735625, 1.479,
1.5714375, 1.576875, 1.5823125, 1.58775, 1.5931875, 1.598625, 1.6040625, 1.6095, 1.6149375, 1.620375, 1.6258125, 1.63125, 1.6366875, 1.642125, 1.6475625, 1.653,
1.7454375, 1.750875, 1.7563125, 1.76175, 1.7671875, 1.772625, 1.7780625, 1.7835, 1.7889375, 1.794375, 1.7998125, 1.80525, 1.8106875, 1.816125, 1.8215625, 1.827,
1.9194375, 1.924875, 1.9303125, 1.93575, 1.9411875, 1.946625, 1.9520625, 1.9575, 1.9629375, 1.968375, 1.9738125, 1.97925, 1.9846875, 1.990125, 1.9955625, 2.001,
2.0934375, 2.098875, 2.1043125, 2.10975, 2.1151875, 2.120625, 2.1260625, 2.1315, 2.1369375, 2.142375, 2.1478125, 2.15325, 2.1586875, 2.164125, 2.1695625, 2.175,
2.2674375, 2.272875, 2.2783125, 2.28375, 2.2891875, 2.294625, 2.3000625, 2.3055, 2.3109375, 2.316375, 2.3218125, 2.32725, 2.3326875, 2.338125, 2.3435625, 2.349,
2.4414375, 2.446875, 2.4523125, 2.45775, 2.4631875, 2.468625, 2.4740625, 2.4795, 2.4849375, 2.490375, 2.4958125, 2.50125, 2.5066875, 2.512125, 2.5175625, 2.523,
2.6154375, 2.620875, 2.6263125, 2.63175, 2.6371875, 2.642625, 2.6480625, 2.6535, 2.6589375, 2.664375, 2.6698125, 2.67525, 2.6806875, 2.686125, 2.6915625, 2.697,
-2.697, -2.6915625, -2.686125, -2.6806875, -2.67525, -2.6698125, -2.664375, -2.6589375, -2.6535, -2.6480625, -2.642625, -2.6371875, -2.63175, -2.6263125, 2.620875, -2.6154375,
-2.523, -2.5175625, -2.512125, -2.5066875, -2.50125, -2.4958125, -2.490375, -2.4849375, -2.4795, -2.4740625, -2.468625, -2.4631875, -2.45775, -2.4523125, 2.446875, -2.4414375,
-2.349, -2.3435625, -2.338125, -2.3326875, -2.32725, -2.3218125, -2.316375, -2.3109375, -2.3055, -2.3000625, -2.294625, -2.2891875, -2.28375, -2.2783125, 2.272875, -2.2674375,
-2.175, -2.1695625, -2.164125, -2.1586875, -2.15325, -2.1478125, -2.142375, -2.1369375, -2.1315, -2.1260625, -2.120625, -2.1151875, -2.10975, -2.1043125, 2.098875, -2.0934375,
-2.001, -1.9955625, -1.990125, -1.9846875, -1.97925, -1.9738125, -1.968375, -1.9629375, -1.9575, -1.9520625, -1.946625, -1.9411875, -1.93575, -1.9303125, 1.924875, -1.9194375,
-1.827, -1.8215625, -1.816125, -1.8106875, -1.80525, -1.7998125, -1.794375, -1.7889375, -1.7835, -1.7780625, -1.772625, -1.7671875, -1.76175, -1.7563125, 1.750875, -1.7454375,
-1.653, -1.6475625, -1.642125, -1.6366875, -1.63125, -1.6258125, -1.620375, -1.6149375, -1.6095, -1.6040625, -1.598625, -1.5931875, -1.58775, -1.5823125, 1.576875, -1.5714375,
-1.479, -1.4735625, -1.468125, -1.4626875, -1.45725, -1.4518125, -1.446375, -1.4409375, -1.4355, -1.4300625, -1.424625, -1.4191875, -1.41375, -1.4083125, 1.402875, -1.3974375,
-1.305, -1.2995625, -1.294125, -1.2886875, -1.28325, -1.2778125, -1.272375, -1.2669375, -1.2615, -1.2560625, -1.250625, -1.2451875, -1.23975, -1.2343125, 1.228875, -1.2234375,
-1.131, -1.1255625, -1.120125, -1.1146875, -1.10925, -1.1038125, -1.098375, -1.0929375, -1.0875, -1.0820625, -1.076625, -1.0711875, -1.06575, -1.0603125, 1.054875, -1.0494375,
-0.957, -0.9515625, -0.946125, -0.9406875, -0.93525, -0.9298125, -0.924375, -0.9189375, -0.9135, -0.9080625, -0.902625, -0.8971875, -0.89175, -0.8863125, 0.880875, -0.8754375,
-0.783, -0.7775625, -0.772125, -0.7666875, -0.76125, -0.7558125, -0.750375, -0.7449375, -0.7395, -0.7340625, -0.728625, -0.7231875, -0.71775, -0.7123125, 0.706875, -0.7014375,
-0.609, -0.6035625, -0.598125, -0.5926875, -0.58725, -0.5818125, -0.576375, -0.5709375, -0.5655, -0.5600625, -0.554625, -0.5491875, -0.54375, -0.5383125, 0.532875, -0.5274375,
-0.435, -0.4295625, -0.424125, -0.4186875, -0.41325, -0.4078125, -0.402375, -0.3969375, -0.3915, -0.3860625, -0.380625, -0.3751875, -0.36975, -0.3643125, 0.358875, -0.3534375,
-0.261, -0.2555625, -0.250125, -0.2446875, -0.23925, -0.2338125, -0.228375, -0.2229375, -0.2175, -0.2120625, -0.206625, -0.2011875, -0.19575, -0.1903125, 0.184875, -0.1794375,
-0.087, -0.0815625, -0.076125, -0.0706875, -0.06525, -0.0598125, -0.054375, -0.0489375, -0.0435, -0.0380625, -0.032625, -0.0271875, -0.02175, -0.0163125, 0.010875, -0.0054375
);

type common_eta_scale_array is array (0 to 2**common_eta_bits-1) of real;
constant common_eta_real_lut : common_eta_scale_array := (
0.00271875, 0.00815625, 0.01359375, 0.01903125, 0.02446875, 0.02990625, 0.03534375, 0.04078125, 0.04621875, 0.05165625, 0.05709375, 0.06253125, 0.06796875, 0.07340625, 0.07884375, 0.08428125,
0.08971875, 0.09515625, 0.10059375, 0.10603125, 0.11146875, 0.11690625, 0.12234375, 0.12778125, 0.13321875, 0.13865625, 0.14409375, 0.14953125, 0.15496875, 0.16040625, 0.16584375, 0.17128125,
0.17671875, 0.18215625, 0.18759375, 0.19303125, 0.19846875, 0.20390625, 0.20934375, 0.21478125, 0.22021875, 0.22565625, 0.23109375, 0.23653125, 0.24196875, 0.24740625, 0.25284375, 0.25828125,
0.26371875, 0.26915625, 0.27459375, 0.28003125, 0.28546875, 0.29090625, 0.29634375, 0.30178125, 0.30721875, 0.31265625, 0.31809375, 0.32353125, 0.32896875, 0.33440625, 0.33984375, 0.34528125,
0.35071875, 0.35615625, 0.36159375, 0.36703125, 0.37246875, 0.37790625, 0.38334375, 0.38878125, 0.39421875, 0.39965625, 0.40509375, 0.41053125, 0.41596875, 0.42140625, 0.42684375, 0.43228125,
0.43771875, 0.44315625, 0.44859375, 0.45403125, 0.45946875, 0.46490625, 0.47034375, 0.47578125, 0.48121875, 0.48665625, 0.49209375, 0.49753125, 0.50296875, 0.50840625, 0.51384375, 0.51928125,
0.52471875, 0.53015625, 0.53559375, 0.54103125, 0.54646875, 0.55190625, 0.55734375, 0.56278125, 0.56821875, 0.57365625, 0.57909375, 0.58453125, 0.58996875, 0.59540625, 0.60084375, 0.60628125,
0.61171875, 0.61715625, 0.62259375, 0.62803125, 0.63346875, 0.63890625, 0.64434375, 0.64978125, 0.65521875, 0.66065625, 0.66609375, 0.67153125, 0.67696875, 0.68240625, 0.68784375, 0.69328125,
0.69871875, 0.70415625, 0.70959375, 0.71503125, 0.72046875, 0.72590625, 0.73134375, 0.73678125, 0.74221875, 0.74765625, 0.75309375, 0.75853125, 0.76396875, 0.76940625, 0.77484375, 0.78028125,
0.78571875, 0.79115625, 0.79659375, 0.80203125, 0.80746875, 0.81290625, 0.81834375, 0.82378125, 0.82921875, 0.83465625, 0.84009375, 0.84553125, 0.85096875, 0.85640625, 0.86184375, 0.86728125,
0.87271875, 0.87815625, 0.88359375, 0.88903125, 0.89446875, 0.89990625, 0.90534375, 0.91078125, 0.91621875, 0.92165625, 0.92709375, 0.93253125, 0.93796875, 0.94340625, 0.94884375, 0.95428125,
0.95971875, 0.96515625, 0.97059375, 0.97603125, 0.98146875, 0.98690625, 0.99234375, 0.99778125, 1.00321875, 1.00865625, 1.01409375, 1.01953125, 1.02496875, 1.03040625, 1.03584375, 1.04128125,
1.04671875, 1.05215625, 1.05759375, 1.06303125, 1.06846875, 1.07390625, 1.07934375, 1.08478125, 1.09021875, 1.09565625, 1.10109375, 1.10653125, 1.11196875, 1.11740625, 1.12284375, 1.12828125,
1.13371875, 1.13915625, 1.14459375, 1.15003125, 1.15546875, 1.16090625, 1.16634375, 1.17178125, 1.17721875, 1.18265625, 1.18809375, 1.19353125, 1.19896875, 1.20440625, 1.20984375, 1.21528125,
1.22071875, 1.22615625, 1.23159375, 1.23703125, 1.24246875, 1.24790625, 1.25334375, 1.25878125, 1.26421875, 1.26965625, 1.27509375, 1.28053125, 1.28596875, 1.29140625, 1.29684375, 1.30228125,
1.30771875, 1.31315625, 1.31859375, 1.32403125, 1.32946875, 1.33490625, 1.34034375, 1.34578125, 1.35121875, 1.35665625, 1.36209375, 1.36753125, 1.37296875, 1.37840625, 1.38384375, 1.38928125,
1.39471875, 1.40015625, 1.40559375, 1.41103125, 1.41646875, 1.42190625, 1.42734375, 1.43278125, 1.43821875, 1.44365625, 1.44909375, 1.45453125, 1.45996875, 1.46540625, 1.47084375, 1.47628125,
1.48171875, 1.48715625, 1.49259375, 1.49803125, 1.50346875, 1.50890625, 1.51434375, 1.51978125, 1.52521875, 1.53065625, 1.53609375, 1.54153125, 1.54696875, 1.55240625, 1.55784375, 1.56328125,
1.56871875, 1.57415625, 1.57959375, 1.58503125, 1.59046875, 1.59590625, 1.60134375, 1.60678125, 1.61221875, 1.61765625, 1.62309375, 1.62853125, 1.63396875, 1.63940625, 1.64484375, 1.65028125,
1.65571875, 1.66115625, 1.66659375, 1.67203125, 1.67746875, 1.68290625, 1.68834375, 1.69378125, 1.69921875, 1.70465625, 1.71009375, 1.71553125, 1.72096875, 1.72640625, 1.73184375, 1.73728125,
1.74271875, 1.74815625, 1.75359375, 1.75903125, 1.76446875, 1.76990625, 1.77534375, 1.78078125, 1.78621875, 1.79165625, 1.79709375, 1.80253125, 1.80796875, 1.81340625, 1.81884375, 1.82428125,
1.82971875, 1.83515625, 1.84059375, 1.84603125, 1.85146875, 1.85690625, 1.86234375, 1.86778125, 1.87321875, 1.87865625, 1.88409375, 1.88953125, 1.89496875, 1.90040625, 1.90584375, 1.91128125,
1.91671875, 1.92215625, 1.92759375, 1.93303125, 1.93846875, 1.94390625, 1.94934375, 1.95478125, 1.96021875, 1.96565625, 1.97109375, 1.97653125, 1.98196875, 1.98740625, 1.99284375, 1.99828125,
2.00371875, 2.00915625, 2.01459375, 2.02003125, 2.02546875, 2.03090625, 2.03634375, 2.04178125, 2.04721875, 2.05265625, 2.05809375, 2.06353125, 2.06896875, 2.07440625, 2.07984375, 2.08528125,
2.09071875, 2.09615625, 2.10159375, 2.10703125, 2.11246875, 2.11790625, 2.12334375, 2.12878125, 2.13421875, 2.13965625, 2.14509375, 2.15053125, 2.15596875, 2.16140625, 2.16684375, 2.17228125,
2.17771875, 2.18315625, 2.18859375, 2.19403125, 2.19946875, 2.20490625, 2.21034375, 2.21578125, 2.22121875, 2.22665625, 2.23209375, 2.23753125, 2.24296875, 2.24840625, 2.25384375, 2.25928125,
2.26471875, 2.27015625, 2.27559375, 2.28103125, 2.28646875, 2.29190625, 2.29734375, 2.30278125, 2.30821875, 2.31365625, 2.31909375, 2.32453125, 2.32996875, 2.33540625, 2.34084375, 2.34628125,
2.35171875, 2.35715625, 2.36259375, 2.36803125, 2.37346875, 2.37890625, 2.38434375, 2.38978125, 2.39521875, 2.40065625, 2.40609375, 2.41153125, 2.41696875, 2.42240625, 2.42784375, 2.43328125,
2.43871875, 2.44415625, 2.44959375, 2.45503125, 2.46046875, 2.46590625, 2.47134375, 2.47678125, 2.48221875, 2.48765625, 2.49309375, 2.49853125, 2.50396875, 2.50940625, 2.51484375, 2.52028125,
2.52571875, 2.53115625, 2.53659375, 2.54203125, 2.54746875, 2.55290625, 2.55834375, 2.56378125, 2.56921875, 2.57465625, 2.58009375, 2.58553125, 2.59096875, 2.59640625, 2.60184375, 2.60728125,
2.61271875, 2.61815625, 2.62359375, 2.62903125, 2.63446875, 2.63990625, 2.64534375, 2.65078125, 2.65621875, 2.66165625, 2.66709375, 2.67253125, 2.67796875, 2.68340625, 2.68884375, 2.69428125,
2.69971875, 2.70515625, 2.71059375, 2.71603125, 2.72146875, 2.72690625, 2.73234375, 2.73778125, 2.74321875, 2.74865625, 2.75409375, 2.75953125, 2.76496875, 2.77040625, 2.77584375, 2.78128125,
2.78671875, 2.79215625, 2.79759375, 2.80303125, 2.80846875, 2.81390625, 2.81934375, 2.82478125, 2.83021875, 2.83565625, 2.84109375, 2.84653125, 2.85196875, 2.85740625, 2.86284375, 2.86828125,
2.87371875, 2.87915625, 2.88459375, 2.89003125, 2.89546875, 2.90090625, 2.90634375, 2.91178125, 2.91721875, 2.92265625, 2.92809375, 2.93353125, 2.93896875, 2.94440625, 2.94984375, 2.95528125,
2.96071875, 2.96615625, 2.97159375, 2.97703125, 2.98246875, 2.98790625, 2.99334375, 2.99878125, 3.00421875, 3.00965625, 3.01509375, 3.02053125, 3.02596875, 3.03140625, 3.03684375, 3.04228125,
3.04771875, 3.05315625, 3.05859375, 3.06403125, 3.06946875, 3.07490625, 3.08034375, 3.08578125, 3.09121875, 3.09665625, 3.10209375, 3.10753125, 3.11296875, 3.11840625, 3.12384375, 3.12928125,
3.13471875, 3.14015625, 3.14559375, 3.15103125, 3.15646875, 3.16190625, 3.16734375, 3.17278125, 3.17821875, 3.18365625, 3.18909375, 3.19453125, 3.19996875, 3.20540625, 3.21084375, 3.21628125,
3.22171875, 3.22715625, 3.23259375, 3.23803125, 3.24346875, 3.24890625, 3.25434375, 3.25978125, 3.26521875, 3.27065625, 3.27609375, 3.28153125, 3.28696875, 3.29240625, 3.29784375, 3.30328125,
3.30871875, 3.31415625, 3.31959375, 3.32503125, 3.33046875, 3.33590625, 3.34134375, 3.34678125, 3.35221875, 3.35765625, 3.36309375, 3.36853125, 3.37396875, 3.37940625, 3.38484375, 3.39028125,
3.39571875, 3.40115625, 3.40659375, 3.41203125, 3.41746875, 3.42290625, 3.42834375, 3.43378125, 3.43921875, 3.44465625, 3.45009375, 3.45553125, 3.46096875, 3.46640625, 3.47184375, 3.47728125,
3.48271875, 3.48815625, 3.49359375, 3.49903125, 3.50446875, 3.50990625, 3.51534375, 3.52078125, 3.52621875, 3.53165625, 3.53709375, 3.54253125, 3.54796875, 3.55340625, 3.55884375, 3.56428125,
3.56971875, 3.57515625, 3.58059375, 3.58603125, 3.59146875, 3.59690625, 3.60234375, 3.60778125, 3.61321875, 3.61865625, 3.62409375, 3.62953125, 3.63496875, 3.64040625, 3.64584375, 3.65128125,
3.65671875, 3.66215625, 3.66759375, 3.67303125, 3.67846875, 3.68390625, 3.68934375, 3.69478125, 3.70021875, 3.70565625, 3.71109375, 3.71653125, 3.72196875, 3.72740625, 3.73284375, 3.73828125,
3.74371875, 3.74915625, 3.75459375, 3.76003125, 3.76546875, 3.77090625, 3.77634375, 3.78178125, 3.78721875, 3.79265625, 3.79809375, 3.80353125, 3.80896875, 3.81440625, 3.81984375, 3.82528125,
3.83071875, 3.83615625, 3.84159375, 3.84703125, 3.85246875, 3.85790625, 3.86334375, 3.86878125, 3.87421875, 3.87965625, 3.88509375, 3.89053125, 3.89596875, 3.90140625, 3.90684375, 3.91228125,
3.91771875, 3.92315625, 3.92859375, 3.93403125, 3.93946875, 3.94490625, 3.95034375, 3.95578125, 3.96121875, 3.96665625, 3.97209375, 3.97753125, 3.98296875, 3.98840625, 3.99384375, 3.99928125,
4.00471875, 4.01015625, 4.01559375, 4.02103125, 4.02646875, 4.03190625, 4.03734375, 4.04278125, 4.04821875, 4.05365625, 4.05909375, 4.06453125, 4.06996875, 4.07540625, 4.08084375, 4.08628125,
4.09171875, 4.09715625, 4.10259375, 4.10803125, 4.11346875, 4.11890625, 4.12434375, 4.12978125, 4.13521875, 4.14065625, 4.14609375, 4.15153125, 4.15696875, 4.16240625, 4.16784375, 4.17328125,
4.17871875, 4.18415625, 4.18959375, 4.19503125, 4.20046875, 4.20590625, 4.21134375, 4.21678125, 4.22221875, 4.22765625, 4.23309375, 4.23853125, 4.24396875, 4.24940625, 4.25484375, 4.26028125,
4.26571875, 4.27115625, 4.27659375, 4.28203125, 4.28746875, 4.29290625, 4.29834375, 4.30378125, 4.30921875, 4.31465625, 4.32009375, 4.32553125, 4.33096875, 4.33640625, 4.34184375, 4.34728125,
4.35271875, 4.35815625, 4.36359375, 4.36903125, 4.37446875, 4.37990625, 4.38534375, 4.39078125, 4.39621875, 4.40165625, 4.40709375, 4.41253125, 4.41796875, 4.42340625, 4.42884375, 4.43428125,
4.43971875, 4.44515625, 4.45059375, 4.45603125, 4.46146875, 4.46690625, 4.47234375, 4.47778125, 4.48321875, 4.48865625, 4.49409375, 4.49953125, 4.50496875, 4.51040625, 4.51584375, 4.52128125,
4.52671875, 4.53215625, 4.53759375, 4.54303125, 4.54846875, 4.55390625, 4.55934375, 4.56478125, 4.57021875, 4.57565625, 4.58109375, 4.58653125, 4.59196875, 4.59740625, 4.60284375, 4.60828125,
4.61371875, 4.61915625, 4.62459375, 4.63003125, 4.63546875, 4.64090625, 4.64634375, 4.65178125, 4.65721875, 4.66265625, 4.66809375, 4.67353125, 4.67896875, 4.68440625, 4.68984375, 4.69528125,
4.70071875, 4.70615625, 4.71159375, 4.71703125, 4.72246875, 4.72790625, 4.73334375, 4.73878125, 4.74421875, 4.74965625, 4.75509375, 4.76053125, 4.76596875, 4.77140625, 4.77684375, 4.78228125,
4.78771875, 4.79315625, 4.79859375, 4.80403125, 4.80946875, 4.81490625, 4.82034375, 4.82578125, 4.83121875, 4.83665625, 4.84209375, 4.84753125, 4.85296875, 4.85840625, 4.86384375, 4.86928125,
4.87471875, 4.88015625, 4.88559375, 4.89103125, 4.89646875, 4.90190625, 4.90734375, 4.91278125, 4.91821875, 4.92365625, 4.92909375, 4.93453125, 4.93996875, 4.94540625, 4.95084375, 4.95628125,
4.96171875, 4.96715625, 4.97259375, 4.97803125, 4.98346875, 4.98890625, 4.99434375, 4.99978125, 5.00521875, 5.01065625, 5.01609375, 5.02153125, 5.02696875, 5.03240625, 5.03784375, 5.04328125,
5.04871875, 5.05415625, 5.05959375, 5.06503125, 5.07046875, 5.07590625, 5.08134375, 5.08678125, 5.09221875, 5.09765625, 5.10309375, 5.10853125, 5.11396875, 5.11940625, 5.12484375, 5.13028125,
5.13571875, 5.14115625, 5.14659375, 5.15203125, 5.15746875, 5.16290625, 5.16834375, 5.17378125, 5.17921875, 5.18465625, 5.19009375, 5.19553125, 5.20096875, 5.20640625, 5.21184375, 5.21728125,
5.22271875, 5.22815625, 5.23359375, 5.23903125, 5.24446875, 5.24990625, 5.25534375, 5.26078125, 5.26621875, 5.27165625, 5.27709375, 5.28253125, 5.28796875, 5.29340625, 5.29884375, 5.30428125,
5.30971875, 5.31515625, 5.32059375, 5.32603125, 5.33146875, 5.33690625, 5.34234375, 5.34778125, 5.35321875, 5.35865625, 5.36409375, 5.36953125, 5.37496875, 5.38040625, 5.38584375, 5.39128125,
5.39671875, 5.40215625, 5.40759375, 5.41303125, 5.41846875, 5.42390625, 5.42934375, 5.43478125, 5.44021875, 5.44565625, 5.45109375, 5.45653125, 5.46196875, 5.46740625, 5.47284375, 5.47828125,
5.48371875, 5.48915625, 5.49459375, 5.50003125, 5.50546875, 5.51090625, 5.51634375, 5.52178125, 5.52721875, 5.53265625, 5.53809375, 5.54353125, 5.54896875, 5.55440625, 5.55984375, 5.56528125,
-5.56528125, -5.55984375, -5.55440625, -5.54896875, -5.54353125, -5.53809375, -5.53265625, -5.52721875, -5.52178125, -5.51634375, -5.51090625, -5.50546875, -5.50003125, -5.49459375, -5.48915625, -5.48371875,
-5.47828125, -5.47284375, -5.46740625, -5.46196875, -5.45653125, -5.45109375, -5.44565625, -5.44021875, -5.43478125, -5.42934375, -5.42390625, -5.41846875, -5.41303125, -5.40759375, -5.40215625, -5.39671875,
-5.39128125, -5.38584375, -5.38040625, -5.37496875, -5.36953125, -5.36409375, -5.35865625, -5.35321875, -5.34778125, -5.34234375, -5.33690625, -5.33146875, -5.32603125, -5.32059375, -5.31515625, -5.30971875,
-5.30428125, -5.29884375, -5.29340625, -5.28796875, -5.28253125, -5.27709375, -5.27165625, -5.26621875, -5.26078125, -5.25534375, -5.24990625, -5.24446875, -5.23903125, -5.23359375, -5.22815625, -5.22271875,
-5.21728125, -5.21184375, -5.20640625, -5.20096875, -5.19553125, -5.19009375, -5.18465625, -5.17921875, -5.17378125, -5.16834375, -5.16290625, -5.15746875, -5.15203125, -5.14659375, -5.14115625, -5.13571875,
-5.13028125, -5.12484375, -5.11940625, -5.11396875, -5.10853125, -5.10309375, -5.09765625, -5.09221875, -5.08678125, -5.08134375, -5.07590625, -5.07046875, -5.06503125, -5.05959375, -5.05415625, -5.04871875,
-5.04328125, -5.03784375, -5.03240625, -5.02696875, -5.02153125, -5.01609375, -5.01065625, -5.00521875, -4.99978125, -4.99434375, -4.98890625, -4.98346875, -4.97803125, -4.97259375, -4.96715625, -4.96171875,
-4.95628125, -4.95084375, -4.94540625, -4.93996875, -4.93453125, -4.92909375, -4.92365625, -4.91821875, -4.91278125, -4.90734375, -4.90190625, -4.89646875, -4.89103125, -4.88559375, -4.88015625, -4.87471875,
-4.86928125, -4.86384375, -4.85840625, -4.85296875, -4.84753125, -4.84209375, -4.83665625, -4.83121875, -4.82578125, -4.82034375, -4.81490625, -4.80946875, -4.80403125, -4.79859375, -4.79315625, -4.78771875,
-4.78228125, -4.77684375, -4.77140625, -4.76596875, -4.76053125, -4.75509375, -4.74965625, -4.74421875, -4.73878125, -4.73334375, -4.72790625, -4.72246875, -4.71703125, -4.71159375, -4.70615625, -4.70071875,
-4.69528125, -4.68984375, -4.68440625, -4.67896875, -4.67353125, -4.66809375, -4.66265625, -4.65721875, -4.65178125, -4.64634375, -4.64090625, -4.63546875, -4.63003125, -4.62459375, -4.61915625, -4.61371875,
-4.60828125, -4.60284375, -4.59740625, -4.59196875, -4.58653125, -4.58109375, -4.57565625, -4.57021875, -4.56478125, -4.55934375, -4.55390625, -4.54846875, -4.54303125, -4.53759375, -4.53215625, -4.52671875,
-4.52128125, -4.51584375, -4.51040625, -4.50496875, -4.49953125, -4.49409375, -4.48865625, -4.48321875, -4.47778125, -4.47234375, -4.46690625, -4.46146875, -4.45603125, -4.45059375, -4.44515625, -4.43971875,
-4.43428125, -4.42884375, -4.42340625, -4.41796875, -4.41253125, -4.40709375, -4.40165625, -4.39621875, -4.39078125, -4.38534375, -4.37990625, -4.37446875, -4.36903125, -4.36359375, -4.35815625, -4.35271875,
-4.34728125, -4.34184375, -4.33640625, -4.33096875, -4.32553125, -4.32009375, -4.31465625, -4.30921875, -4.30378125, -4.29834375, -4.29290625, -4.28746875, -4.28203125, -4.27659375, -4.27115625, -4.26571875,
-4.26028125, -4.25484375, -4.24940625, -4.24396875, -4.23853125, -4.23309375, -4.22765625, -4.22221875, -4.21678125, -4.21134375, -4.20590625, -4.20046875, -4.19503125, -4.18959375, -4.18415625, -4.17871875,
-4.17328125, -4.16784375, -4.16240625, -4.15696875, -4.15153125, -4.14609375, -4.14065625, -4.13521875, -4.12978125, -4.12434375, -4.11890625, -4.11346875, -4.10803125, -4.10259375, -4.09715625, -4.09171875,
-4.08628125, -4.08084375, -4.07540625, -4.06996875, -4.06453125, -4.05909375, -4.05365625, -4.04821875, -4.04278125, -4.03734375, -4.03190625, -4.02646875, -4.02103125, -4.01559375, -4.01015625, -4.00471875,
-3.99928125, -3.99384375, -3.98840625, -3.98296875, -3.97753125, -3.97209375, -3.96665625, -3.96121875, -3.95578125, -3.95034375, -3.94490625, -3.93946875, -3.93403125, -3.92859375, -3.92315625, -3.91771875,
-3.91228125, -3.90684375, -3.90140625, -3.89596875, -3.89053125, -3.88509375, -3.87965625, -3.87421875, -3.86878125, -3.86334375, -3.85790625, -3.85246875, -3.84703125, -3.84159375, -3.83615625, -3.83071875,
-3.82528125, -3.81984375, -3.81440625, -3.80896875, -3.80353125, -3.79809375, -3.79265625, -3.78721875, -3.78178125, -3.77634375, -3.77090625, -3.76546875, -3.76003125, -3.75459375, -3.74915625, -3.74371875,
-3.73828125, -3.73284375, -3.72740625, -3.72196875, -3.71653125, -3.71109375, -3.70565625, -3.70021875, -3.69478125, -3.68934375, -3.68390625, -3.67846875, -3.67303125, -3.66759375, -3.66215625, -3.65671875,
-3.65128125, -3.64584375, -3.64040625, -3.63496875, -3.62953125, -3.62409375, -3.61865625, -3.61321875, -3.60778125, -3.60234375, -3.59690625, -3.59146875, -3.58603125, -3.58059375, -3.57515625, -3.56971875,
-3.56428125, -3.55884375, -3.55340625, -3.54796875, -3.54253125, -3.53709375, -3.53165625, -3.52621875, -3.52078125, -3.51534375, -3.50990625, -3.50446875, -3.49903125, -3.49359375, -3.48815625, -3.48271875,
-3.47728125, -3.47184375, -3.46640625, -3.46096875, -3.45553125, -3.45009375, -3.44465625, -3.43921875, -3.43378125, -3.42834375, -3.42290625, -3.41746875, -3.41203125, -3.40659375, -3.40115625, -3.39571875,
-3.39028125, -3.38484375, -3.37940625, -3.37396875, -3.36853125, -3.36309375, -3.35765625, -3.35221875, -3.34678125, -3.34134375, -3.33590625, -3.33046875, -3.32503125, -3.31959375, -3.31415625, -3.30871875,
-3.30328125, -3.29784375, -3.29240625, -3.28696875, -3.28153125, -3.27609375, -3.27065625, -3.26521875, -3.25978125, -3.25434375, -3.24890625, -3.24346875, -3.23803125, -3.23259375, -3.22715625, -3.22171875,
-3.21628125, -3.21084375, -3.20540625, -3.19996875, -3.19453125, -3.18909375, -3.18365625, -3.17821875, -3.17278125, -3.16734375, -3.16190625, -3.15646875, -3.15103125, -3.14559375, -3.14015625, -3.13471875,
-3.12928125, -3.12384375, -3.11840625, -3.11296875, -3.10753125, -3.10209375, -3.09665625, -3.09121875, -3.08578125, -3.08034375, -3.07490625, -3.06946875, -3.06403125, -3.05859375, -3.05315625, -3.04771875,
-3.04228125, -3.03684375, -3.03140625, -3.02596875, -3.02053125, -3.01509375, -3.00965625, -3.00421875, -2.99878125, -2.99334375, -2.98790625, -2.98246875, -2.97703125, -2.97159375, -2.96615625, -2.96071875,
-2.95528125, -2.94984375, -2.94440625, -2.93896875, -2.93353125, -2.92809375, -2.92265625, -2.91721875, -2.91178125, -2.90634375, -2.90090625, -2.89546875, -2.89003125, -2.88459375, -2.87915625, -2.87371875,
-2.86828125, -2.86284375, -2.85740625, -2.85196875, -2.84653125, -2.84109375, -2.83565625, -2.83021875, -2.82478125, -2.81934375, -2.81390625, -2.80846875, -2.80303125, -2.79759375, -2.79215625, -2.78671875,
-2.78128125, -2.77584375, -2.77040625, -2.76496875, -2.75953125, -2.75409375, -2.74865625, -2.74321875, -2.73778125, -2.73234375, -2.72690625, -2.72146875, -2.71603125, -2.71059375, -2.70515625, -2.69971875,
-2.69428125, -2.68884375, -2.68340625, -2.67796875, -2.67253125, -2.66709375, -2.66165625, -2.65621875, -2.65078125, -2.64534375, -2.63990625, -2.63446875, -2.62903125, -2.62359375, -2.61815625, -2.61271875,
-2.60728125, -2.60184375, -2.59640625, -2.59096875, -2.58553125, -2.58009375, -2.57465625, -2.56921875, -2.56378125, -2.55834375, -2.55290625, -2.54746875, -2.54203125, -2.53659375, -2.53115625, -2.52571875,
-2.52028125, -2.51484375, -2.50940625, -2.50396875, -2.49853125, -2.49309375, -2.48765625, -2.48221875, -2.47678125, -2.47134375, -2.46590625, -2.46046875, -2.45503125, -2.44959375, -2.44415625, -2.43871875,
-2.43328125, -2.42784375, -2.42240625, -2.41696875, -2.41153125, -2.40609375, -2.40065625, -2.39521875, -2.38978125, -2.38434375, -2.37890625, -2.37346875, -2.36803125, -2.36259375, -2.35715625, -2.35171875,
-2.34628125, -2.34084375, -2.33540625, -2.32996875, -2.32453125, -2.31909375, -2.31365625, -2.30821875, -2.30278125, -2.29734375, -2.29190625, -2.28646875, -2.28103125, -2.27559375, -2.27015625, -2.26471875,
-2.25928125, -2.25384375, -2.24840625, -2.24296875, -2.23753125, -2.23209375, -2.22665625, -2.22121875, -2.21578125, -2.21034375, -2.20490625, -2.19946875, -2.19403125, -2.18859375, -2.18315625, -2.17771875,
-2.17228125, -2.16684375, -2.16140625, -2.15596875, -2.15053125, -2.14509375, -2.13965625, -2.13421875, -2.12878125, -2.12334375, -2.11790625, -2.11246875, -2.10703125, -2.10159375, -2.09615625, -2.09071875,
-2.08528125, -2.07984375, -2.07440625, -2.06896875, -2.06353125, -2.05809375, -2.05265625, -2.04721875, -2.04178125, -2.03634375, -2.03090625, -2.02546875, -2.02003125, -2.01459375, -2.00915625, -2.00371875,
-1.99828125, -1.99284375, -1.98740625, -1.98196875, -1.97653125, -1.97109375, -1.96565625, -1.96021875, -1.95478125, -1.94934375, -1.94390625, -1.93846875, -1.93303125, -1.92759375, -1.92215625, -1.91671875,
-1.91128125, -1.90584375, -1.90040625, -1.89496875, -1.88953125, -1.88409375, -1.87865625, -1.87321875, -1.86778125, -1.86234375, -1.85690625, -1.85146875, -1.84603125, -1.84059375, -1.83515625, -1.82971875,
-1.82428125, -1.81884375, -1.81340625, -1.80796875, -1.80253125, -1.79709375, -1.79165625, -1.78621875, -1.78078125, -1.77534375, -1.76990625, -1.76446875, -1.75903125, -1.75359375, -1.74815625, -1.74271875,
-1.73728125, -1.73184375, -1.72640625, -1.72096875, -1.71553125, -1.71009375, -1.70465625, -1.69921875, -1.69378125, -1.68834375, -1.68290625, -1.67746875, -1.67203125, -1.66659375, -1.66115625, -1.65571875,
-1.65028125, -1.64484375, -1.63940625, -1.63396875, -1.62853125, -1.62309375, -1.61765625, -1.61221875, -1.60678125, -1.60134375, -1.59590625, -1.59046875, -1.58503125, -1.57959375, -1.57415625, -1.56871875,
-1.56328125, -1.55784375, -1.55240625, -1.54696875, -1.54153125, -1.53609375, -1.53065625, -1.52521875, -1.51978125, -1.51434375, -1.50890625, -1.50346875, -1.49803125, -1.49259375, -1.48715625, -1.48171875,
-1.47628125, -1.47084375, -1.46540625, -1.45996875, -1.45453125, -1.44909375, -1.44365625, -1.43821875, -1.43278125, -1.42734375, -1.42190625, -1.41646875, -1.41103125, -1.40559375, -1.40015625, -1.39471875,
-1.38928125, -1.38384375, -1.37840625, -1.37296875, -1.36753125, -1.36209375, -1.35665625, -1.35121875, -1.34578125, -1.34034375, -1.33490625, -1.32946875, -1.32403125, -1.31859375, -1.31315625, -1.30771875,
-1.30228125, -1.29684375, -1.29140625, -1.28596875, -1.28053125, -1.27509375, -1.26965625, -1.26421875, -1.25878125, -1.25334375, -1.24790625, -1.24246875, -1.23703125, -1.23159375, -1.22615625, -1.22071875,
-1.21528125, -1.20984375, -1.20440625, -1.19896875, -1.19353125, -1.18809375, -1.18265625, -1.17721875, -1.17178125, -1.16634375, -1.16090625, -1.15546875, -1.15003125, -1.14459375, -1.13915625, -1.13371875,
-1.12828125, -1.12284375, -1.11740625, -1.11196875, -1.10653125, -1.10109375, -1.09565625, -1.09021875, -1.08478125, -1.07934375, -1.07390625, -1.06846875, -1.06303125, -1.05759375, -1.05215625, -1.04671875,
-1.04128125, -1.03584375, -1.03040625, -1.02496875, -1.01953125, -1.01409375, -1.00865625, -1.00321875, -0.99778125, -0.99234375, -0.98690625, -0.98146875, -0.97603125, -0.97059375, -0.96515625, -0.95971875,
-0.95428125, -0.94884375, -0.94340625, -0.93796875, -0.93253125, -0.92709375, -0.92165625, -0.91621875, -0.91078125, -0.90534375, -0.89990625, -0.89446875, -0.88903125, -0.88359375, -0.87815625, -0.87271875,
-0.86728125, -0.86184375, -0.85640625, -0.85096875, -0.84553125, -0.84009375, -0.83465625, -0.82921875, -0.82378125, -0.81834375, -0.81290625, -0.80746875, -0.80203125, -0.79659375, -0.79115625, -0.78571875,
-0.78028125, -0.77484375, -0.76940625, -0.76396875, -0.75853125, -0.75309375, -0.74765625, -0.74221875, -0.73678125, -0.73134375, -0.72590625, -0.72046875, -0.71503125, -0.70959375, -0.70415625, -0.69871875,
-0.69328125, -0.68784375, -0.68240625, -0.67696875, -0.67153125, -0.66609375, -0.66065625, -0.65521875, -0.64978125, -0.64434375, -0.63890625, -0.63346875, -0.62803125, -0.62259375, -0.61715625, -0.61171875,
-0.60628125, -0.60084375, -0.59540625, -0.58996875, -0.58453125, -0.57909375, -0.57365625, -0.56821875, -0.56278125, -0.55734375, -0.55190625, -0.54646875, -0.54103125, -0.53559375, -0.53015625, -0.52471875,
-0.51928125, -0.51384375, -0.50840625, -0.50296875, -0.49753125, -0.49209375, -0.48665625, -0.48121875, -0.47578125, -0.47034375, -0.46490625, -0.45946875, -0.45403125, -0.44859375, -0.44315625, -0.43771875,
-0.43228125, -0.42684375, -0.42140625, -0.41596875, -0.41053125, -0.40509375, -0.39965625, -0.39421875, -0.38878125, -0.38334375, -0.37790625, -0.37246875, -0.36703125, -0.36159375, -0.35615625, -0.35071875,
-0.34528125, -0.33984375, -0.33440625, -0.32896875, -0.32353125, -0.31809375, -0.31265625, -0.30721875, -0.30178125, -0.29634375, -0.29090625, -0.28546875, -0.28003125, -0.27459375, -0.26915625, -0.26371875,
-0.25828125, -0.25284375, -0.24740625, -0.24196875, -0.23653125, -0.23109375, -0.22565625, -0.22021875, -0.21478125, -0.20934375, -0.20390625, -0.19846875, -0.19303125, -0.18759375, -0.18215625, -0.17671875,
-0.17128125, -0.16584375, -0.16040625, -0.15496875, -0.14953125, -0.14409375, -0.13865625, -0.13321875, -0.12778125, -0.12234375, -0.11690625, -0.11146875, -0.10603125, -0.10059375, -0.09515625, -0.08971875,
-0.08428125, -0.07884375, -0.07340625, -0.06796875, -0.06253125, -0.05709375, -0.05165625, -0.04621875, -0.04078125, -0.03534375, -0.02990625, -0.02446875, -0.01903125, -0.01359375, -0.00815625, -0.00271875
);

end package;
