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
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/l1tm/L1Menu_CaloMuonCorrelation_2015_hb_test/vhdl/module_0/src/gtl_pkg.vhd $
-- $Date: 2015-08-24 11:49:40 +0200 (Mon, 24 Aug 2015) $
-- $Author: bergauer $
-- $Revision: 4173 $
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

-- Algorithms
constant NR_ALGOS : positive := 2; -- number of algorithmns (min. 32 for FDL registers width !!!) - written by TME
-- 
-- ==== FDL definitions - begin ============================================================
-- Definitions for prescalers (for FDL !)
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
-- ==== FDL definitions - end ============================================================

-- ==== Versions - begin ============================================================
-- HB 2015-05-28: see l1tm_pkg.vhd in l1tm/...
-- constant L1TM_UID : std_logic_vector(127 downto 0) := X"00000000000000000000000000000000";
-- constant L1TM_NAME : std_logic_vector(128*8-1 downto 0) := X"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
-- constant L1TM_FW_UID : std_logic_vector(127 downto 0) := X"00000000000000000000000000000000";
-- 
-- -- Trigger Menu Editor software version - written by TME
-- constant L1TM_COMPILER_MAJOR_VERSION      : integer range 0 to 255 := 255;
-- constant L1TM_COMPILER_MINOR_VERSION      : integer range 0 to 255 := 255;
-- constant L1TM_COMPILER_REV_VERSION        : integer range 0 to 255 := 255;
-- constant L1TM_COMPILER_VERSION : std_logic_vector(31 downto 0) := X"00" &
--            std_logic_vector(to_unsigned(L1TM_COMPILER_MAJOR_VERSION, 8)) &
--            std_logic_vector(to_unsigned(L1TM_COMPILER_MINOR_VERSION, 8)) &
--            std_logic_vector(to_unsigned(L1TM_COMPILER_REV_VERSION, 8));
-- 
-- -- HB 2014-09-09: GTL and FDL firmware major, minor and revision versions moved to gt_mp7_core_pkg.vhd (GTL_FW_MAJOR_VERSION, etc.)
-- --                for creating a tag name by a script independent from L1Menu.
-- -- GTL firmware (fix part) version
-- constant GTL_FW_VERSION : std_logic_vector(31 downto 0) := X"00" &
--            std_logic_vector(to_unsigned(GTL_FW_MAJOR_VERSION, 8)) &
--            std_logic_vector(to_unsigned(GTL_FW_MINOR_VERSION, 8)) &
--            std_logic_vector(to_unsigned(GTL_FW_REV_VERSION, 8));
-- 
-- -- FDL firmware version
-- constant FDL_FW_VERSION : std_logic_vector(31 downto 0) := X"00" &
--            std_logic_vector(to_unsigned(FDL_FW_MAJOR_VERSION, 8)) &
--            std_logic_vector(to_unsigned(FDL_FW_MINOR_VERSION, 8)) &
--            std_logic_vector(to_unsigned(FDL_FW_REV_VERSION, 8));
-- 
-- ==== Versions - end ============================================================

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

-- Parameter for sub_eta_obj_vs_obj and sub_phi_obj_vs_obj instances of correlation conditions

constant PI : real :=  3.14159;

constant PHI_HALF_RANGE_REAL : real := PI;
constant ETA_RANGE_REAL : real := 10.0; -- eta range max.: -5.0 to +5.0
subtype dr_squared_range_real is real range 0.0 to ((ETA_RANGE_REAL**2)+(PHI_HALF_RANGE_REAL**2));
subtype diff_eta_range_real is real range -ETA_RANGE_REAL to ETA_RANGE_REAL;
subtype diff_phi_range_real is real range 0.0 to PHI_HALF_RANGE_REAL;

constant POSITION_FINAL_PRECISION : positive := 3; -- 3 => max. number, higher numbers exceed 32 bit integer values !!!

-- HB 2015-08-17: LUT for eta values (values are in the center of bins).
subtype eta_range_integer is integer range -5000 to 5000;

type eg_eta_lut_array is array (0 to 255) of eta_range_integer;
constant eg_eta_lut : eg_eta_lut_array := (
22, 66, 109, 153, 196, 240, 283, 327, 370, 414, 457, 501, 544, 588, 631, 675,
718, 762, 805, 849, 892, 936, 979, 1023, 1066, 1110, 1153, 1197, 1240, 1284, 1327, 1371,
1414, 1458, 1501, 1545, 1588, 1632, 1675, 1719, 1762, 1806, 1849, 1893, 1936, 1980, 2023, 2067,
2110, 2154, 2197, 2241, 2284, 2328, 2371, 2415, 2458, 2502, 2545, 2589, 2632, 2676, 2719, 2763,
2806, 2850, 2893, 2937, 2980, 3024, 3067, 3111, 3154, 3198, 3241, 3285, 3328, 3372, 3415, 3459,
3502, 3546, 3589, 3633, 3676, 3720, 3763, 3807, 3850, 3894, 3937, 3981, 4024, 4068, 4111, 4155,
4198, 4242, 4285, 4329, 4372, 4416, 4459, 4503, 4546, 4590, 4633, 4677, 4720, 4764, 4807, 4851,
4894, 4938, 4981, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -- eta range -5.0 to 5.0
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -4981, -4938, -4894,
-4851, -4807, -4764, -4720, -4677, -4633, -4590, -4546, -4503, -4459, -4416, -4372, -4329, -4285, -4242, -4198,
-4155, -4111, -4068, -4024, -3981, -3937, -3894, -3850, -3807, -3763, -3720, -3676, -3633, -3589, -3546, -3502,
-3459, -3415, -3372, -3328, -3285, -3241, -3198, -3154, -3111, -3067, -3024, -2980, -2937, -2893, -2850, -2806,
-2763, -2719, -2676, -2632, -2589, -2545, -2502, -2458, -2415, -2371, -2328, -2284, -2241, -2197, -2154, -2110,
-2067, -2023, -1980, -1936, -1893, -1849, -1806, -1762, -1719, -1675, -1632, -1588, -1545, -1501, -1458, -1414,
-1371, -1327, -1284, -1240, -1197, -1153, -1110, -1066, -1023, -979, -936, -892, -849, -805, -762, -718,
-675, -631, -588, -544, -501, -457, -414, -370, -327, -283, -240, -196, -153, -109, -66, -22
);

type tau_eta_lut_array is array (0 to 255) of eta_range_integer;
constant tau_eta_lut : tau_eta_lut_array := (
22, 66, 109, 153, 196, 240, 283, 327, 370, 414, 457, 501, 544, 588, 631, 675,
718, 762, 805, 849, 892, 936, 979, 1023, 1066, 1110, 1153, 1197, 1240, 1284, 1327, 1371,
1414, 1458, 1501, 1545, 1588, 1632, 1675, 1719, 1762, 1806, 1849, 1893, 1936, 1980, 2023, 2067,
2110, 2154, 2197, 2241, 2284, 2328, 2371, 2415, 2458, 2502, 2545, 2589, 2632, 2676, 2719, 2763,
2806, 2850, 2893, 2937, 2980, 3024, 3067, 3111, 3154, 3198, 3241, 3285, 3328, 3372, 3415, 3459,
3502, 3546, 3589, 3633, 3676, 3720, 3763, 3807, 3850, 3894, 3937, 3981, 4024, 4068, 4111, 4155,
4198, 4242, 4285, 4329, 4372, 4416, 4459, 4503, 4546, 4590, 4633, 4677, 4720, 4764, 4807, 4851,
4894, 4938, 4981, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -- eta range -5.0 to 5.0
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -4981, -4938, -4894,
-4851, -4807, -4764, -4720, -4677, -4633, -4590, -4546, -4503, -4459, -4416, -4372, -4329, -4285, -4242, -4198,
-4155, -4111, -4068, -4024, -3981, -3937, -3894, -3850, -3807, -3763, -3720, -3676, -3633, -3589, -3546, -3502,
-3459, -3415, -3372, -3328, -3285, -3241, -3198, -3154, -3111, -3067, -3024, -2980, -2937, -2893, -2850, -2806,
-2763, -2719, -2676, -2632, -2589, -2545, -2502, -2458, -2415, -2371, -2328, -2284, -2241, -2197, -2154, -2110,
-2067, -2023, -1980, -1936, -1893, -1849, -1806, -1762, -1719, -1675, -1632, -1588, -1545, -1501, -1458, -1414,
-1371, -1327, -1284, -1240, -1197, -1153, -1110, -1066, -1023, -979, -936, -892, -849, -805, -762, -718,
-675, -631, -588, -544, -501, -457, -414, -370, -327, -283, -240, -196, -153, -109, -66, -22
);

type muon_eta_lut_array is array (0 to 511) of eta_range_integer;
constant muon_eta_lut : muon_eta_lut_array := (
6, 17, 28, 39, 49, 60, 71, 82, 93, 104, 115, 126, 136, 147, 158, 169,
180, 191, 202, 213, 223, 234, 245, 256, 267, 278, 289, 300, 310, 321, 332, 343,
354, 365, 376, 387, 397, 408, 419, 430, 441, 452, 463, 474, 484, 495, 506, 517,
528, 539, 550, 561, 571, 582, 593, 604, 615, 626, 637, 648, 658, 669, 680, 691,
702, 713, 724, 735, 745, 756, 767, 778, 789, 800, 811, 822, 832, 843, 854, 865,
876, 887, 898, 909, 919, 930, 941, 952, 963, 974, 985, 996, 1006, 1017, 1028, 1039,
1050, 1061, 1072, 1083, 1093, 1104, 1115, 1126, 1137, 1148, 1159, 1170, 1180, 1191, 1202, 1213,
1224, 1235, 1246, 1257, 1267, 1278, 1289, 1300, 1311, 1322, 1333, 1344, 1354, 1365, 1376, 1387,
1398, 1409, 1420, 1431, 1441, 1452, 1463, 1474, 1485, 1496, 1507, 1518, 1528, 1539, 1550, 1561,
1572, 1583, 1594, 1605, 1615, 1626, 1637, 1648, 1659, 1670, 1681, 1692, 1702, 1713, 1724, 1735,
1746, 1757, 1768, 1779, 1789, 1800, 1811, 1822, 1833, 1844, 1855, 1866, 1876, 1887, 1898, 1909,
1920, 1931, 1942, 1953, 1963, 1974, 1985, 1996, 2007, 2018, 2029, 2040, 2050, 2061, 2072, 2083,
2094, 2105, 2116, 2127, 2137, 2148, 2159, 2170, 2181, 2192, 2203, 2214, 2224, 2235, 2246, 2257,
2268, 2279, 2290, 2301, 2311, 2322, 2333, 2344, 2355, 2366, 2377, 2388, 2398, 2409, 2420, 2431,
2442, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -- eta range -2.45 to 2.45
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -0, -2442,
-2431, -2420, -2409, -2398, -2388, -2377, -2366, -2355, -2344, -2333, -2322, -2311, -2301, -2290, -2279, -2268,
-2257, -2246, -2235, -2224, -2214, -2203, -2192, -2181, -2170, -2159, -2148, -2137, -2127, -2116, -2105, -2094,
-2083, -2072, -2061, -2050, -2040, -2029, -2018, -2007, -1996, -1985, -1974, -1963, -1953, -1942, -1931, -1920,
-1909, -1898, -1887, -1876, -1866, -1855, -1844, -1833, -1822, -1811, -1800, -1789, -1779, -1768, -1757, -1746,
-1735, -1724, -1713, -1702, -1692, -1681, -1670, -1659, -1648, -1637, -1626, -1615, -1605, -1594, -1583, -1572,
-1561, -1550, -1539, -1528, -1518, -1507, -1496, -1485, -1474, -1463, -1452, -1441, -1431, -1420, -1409, -1398,
-1387, -1376, -1365, -1354, -1344, -1333, -1322, -1311, -1300, -1289, -1278, -1267, -1257, -1246, -1235, -1224,
-1213, -1202, -1191, -1180, -1170, -1159, -1148, -1137, -1126, -1115, -1104, -1093, -1083, -1072, -1061, -1050,
-1039, -1028, -1017, -1006, -996, -985, -974, -963, -952, -941, -930, -919, -909, -898, -887, -876,
-865, -854, -843, -832, -822, -811, -800, -789, -778, -767, -756, -745, -735, -724, -713, -702,
-691, -680, -669, -658, -648, -637, -626, -615, -604, -593, -582, -571, -561, -550, -539, -528,
-517, -506, -495, -484, -474, -463, -452, -441, -430, -419, -408, -397, -387, -376, -365, -354,
-343, -332, -321, -310, -300, -289, -278, -267, -256, -245, -234, -223, -213, -202, -191, -180,
-169, -158, -147, -136, -126, -115, -104, -93, -82, -71, -60, -49, -39, -28, -17, -6
);

constant PHI_HALF_RANGE_INTEGER : positive := 3142; -- or 31415, depends on how many digits after comma used;
subtype phi_range_integer is natural range 0 to 6283;

-- HB 2015-08-17: LUT for eta values (values are in the center of bins).
type eg_phi_lut_array is array (0 to 255) of phi_range_integer;
constant eg_phi_lut : eg_phi_lut_array := (
22, 66, 110, 153, 197, 240, 284, 328, 371, 415, 459, 502, 546, 590, 633, 677,
720, 764, 808, 851, 895, 939, 982, 1026, 1070, 1113, 1157, 1200, 1244, 1288, 1331, 1375,
1419, 1462, 1506, 1549, 1593, 1637, 1680, 1724, 1768, 1811, 1855, 1899, 1942, 1986, 2029, 2073,
2117, 2160, 2204, 2248, 2291, 2335, 2379, 2422, 2466, 2509, 2553, 2597, 2640, 2684, 2728, 2771,
2815, 2858, 2902, 2946, 2989, 3033, 3077, 3120, 3164, 3208, 3251, 3295, 3338, 3382, 3426, 3469,
3513, 3557, 3600, 3644, 3688, 3731, 3775, 3818, 3862, 3906, 3949, 3993, 4037, 4080, 4124, 4167,
4211, 4255, 4298, 4342, 4386, 4429, 4473, 4517, 4560, 4604, 4647, 4691, 4735, 4778, 4822, 4866,
4909, 4953, 4997, 5040, 5084, 5127, 5171, 5215, 5258, 5302, 5346, 5389, 5433, 5476, 5520, 5564,
5607, 5651, 5695, 5738, 5782, 5826, 5869, 5913, 5956, 6000, 6044, 6087, 6131, 6175, 6218, 6262, -- phi range 0 to 2*PI=6.283
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

type tau_phi_lut_array is array (0 to 255) of phi_range_integer;
constant tau_phi_lut : tau_phi_lut_array := (
22, 66, 110, 153, 197, 240, 284, 328, 371, 415, 459, 502, 546, 590, 633, 677,
720, 764, 808, 851, 895, 939, 982, 1026, 1070, 1113, 1157, 1200, 1244, 1288, 1331, 1375,
1419, 1462, 1506, 1549, 1593, 1637, 1680, 1724, 1768, 1811, 1855, 1899, 1942, 1986, 2029, 2073,
2117, 2160, 2204, 2248, 2291, 2335, 2379, 2422, 2466, 2509, 2553, 2597, 2640, 2684, 2728, 2771,
2815, 2858, 2902, 2946, 2989, 3033, 3077, 3120, 3164, 3208, 3251, 3295, 3338, 3382, 3426, 3469,
3513, 3557, 3600, 3644, 3688, 3731, 3775, 3818, 3862, 3906, 3949, 3993, 4037, 4080, 4124, 4167,
4211, 4255, 4298, 4342, 4386, 4429, 4473, 4517, 4560, 4604, 4647, 4691, 4735, 4778, 4822, 4866,
4909, 4953, 4997, 5040, 5084, 5127, 5171, 5215, 5258, 5302, 5346, 5389, 5433, 5476, 5520, 5564,
5607, 5651, 5695, 5738, 5782, 5826, 5869, 5913, 5956, 6000, 6044, 6087, 6131, 6175, 6218, 6262,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -- phi range 0 to 2*PI=6.283
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

type muon_phi_lut_array is array (0 to 1023) of phi_range_integer;
constant muon_phi_lut : muon_phi_lut_array := (
6, 17, 28, 39, 50, 60, 71, 82, 93, 104, 115, 126, 137, 148, 159, 170,
180, 191, 202, 213, 224, 235, 246, 257, 268, 279, 290, 300, 311, 322, 333, 344,
355, 366, 377, 388, 399, 410, 420, 431, 442, 453, 464, 475, 486, 497, 508, 519,
530, 540, 551, 562, 573, 584, 595, 606, 617, 628, 639, 650, 660, 671, 682, 693,
704, 715, 726, 737, 748, 759, 770, 780, 791, 802, 813, 824, 835, 846, 857, 868,
879, 890, 900, 911, 922, 933, 944, 955, 966, 977, 988, 999, 1010, 1020, 1031, 1042,
1053, 1064, 1075, 1086, 1097, 1108, 1119, 1130, 1140, 1151, 1162, 1173, 1184, 1195, 1206, 1217,
1228, 1239, 1250, 1260, 1271, 1282, 1293, 1304, 1315, 1326, 1337, 1348, 1359, 1369, 1380, 1391,
1402, 1413, 1424, 1435, 1446, 1457, 1468, 1479, 1489, 1500, 1511, 1522, 1533, 1544, 1555, 1566,
1577, 1588, 1599, 1609, 1620, 1631, 1642, 1653, 1664, 1675, 1686, 1697, 1708, 1719, 1729, 1740,
1751, 1762, 1773, 1784, 1795, 1806, 1817, 1828, 1839, 1849, 1860, 1871, 1882, 1893, 1904, 1915,
1926, 1937, 1948, 1959, 1969, 1980, 1991, 2002, 2013, 2024, 2035, 2046, 2057, 2068, 2079, 2089,
2100, 2111, 2122, 2133, 2144, 2155, 2166, 2177, 2188, 2199, 2209, 2220, 2231, 2242, 2253, 2264,
2275, 2286, 2297, 2308, 2319, 2329, 2340, 2351, 2362, 2373, 2384, 2395, 2406, 2417, 2428, 2439,
2449, 2460, 2471, 2482, 2493, 2504, 2515, 2526, 2537, 2548, 2558, 2569, 2580, 2591, 2602, 2613,
2624, 2635, 2646, 2657, 2668, 2678, 2689, 2700, 2711, 2722, 2733, 2744, 2755, 2766, 2777, 2788,
2798, 2809, 2820, 2831, 2842, 2853, 2864, 2875, 2886, 2897, 2908, 2918, 2929, 2940, 2951, 2962,
2973, 2984, 2995, 3006, 3017, 3028, 3038, 3049, 3060, 3071, 3082, 3093, 3104, 3115, 3126, 3137,
3148, 3158, 3169, 3180, 3191, 3202, 3213, 3224, 3235, 3246, 3257, 3268, 3278, 3289, 3300, 3311,
3322, 3333, 3344, 3355, 3366, 3377, 3388, 3398, 3409, 3420, 3431, 3442, 3453, 3464, 3475, 3486,
3497, 3508, 3518, 3529, 3540, 3551, 3562, 3573, 3584, 3595, 3606, 3617, 3628, 3638, 3649, 3660,
3671, 3682, 3693, 3704, 3715, 3726, 3737, 3748, 3758, 3769, 3780, 3791, 3802, 3813, 3824, 3835,
3846, 3857, 3867, 3878, 3889, 3900, 3911, 3922, 3933, 3944, 3955, 3966, 3977, 3987, 3998, 4009,
4020, 4031, 4042, 4053, 4064, 4075, 4086, 4097, 4107, 4118, 4129, 4140, 4151, 4162, 4173, 4184,
4195, 4206, 4217, 4227, 4238, 4249, 4260, 4271, 4282, 4293, 4304, 4315, 4326, 4337, 4347, 4358,
4369, 4380, 4391, 4402, 4413, 4424, 4435, 4446, 4457, 4467, 4478, 4489, 4500, 4511, 4522, 4533,
4544, 4555, 4566, 4577, 4587, 4598, 4609, 4620, 4631, 4642, 4653, 4664, 4675, 4686, 4697, 4707,
4718, 4729, 4740, 4751, 4762, 4773, 4784, 4795, 4806, 4817, 4827, 4838, 4849, 4860, 4871, 4882,
4893, 4904, 4915, 4926, 4937, 4947, 4958, 4969, 4980, 4991, 5002, 5013, 5024, 5035, 5046, 5056,
5067, 5078, 5089, 5100, 5111, 5122, 5133, 5144, 5155, 5166, 5176, 5187, 5198, 5209, 5220, 5231,
5242, 5253, 5264, 5275, 5286, 5296, 5307, 5318, 5329, 5340, 5351, 5362, 5373, 5384, 5395, 5406,
5416, 5427, 5438, 5449, 5460, 5471, 5482, 5493, 5504, 5515, 5526, 5536, 5547, 5558, 5569, 5580,
5591, 5602, 5613, 5624, 5635, 5646, 5656, 5667, 5678, 5689, 5700, 5711, 5722, 5733, 5744, 5755,
5766, 5776, 5787, 5798, 5809, 5820, 5831, 5842, 5853, 5864, 5875, 5886, 5896, 5907, 5918, 5929,
5940, 5951, 5962, 5973, 5984, 5995, 6006, 6016, 6027, 6038, 6049, 6060, 6071, 6082, 6093, 6104,
6115, 6126, 6136, 6147, 6158, 6169, 6180, 6191, 6202, 6213, 6224, 6235, 6246, 6256, 6267, 6278, -- phi range 0 to 2*PI=6.283
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

end package;
