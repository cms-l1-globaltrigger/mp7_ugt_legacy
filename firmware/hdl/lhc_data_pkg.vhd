
-- HB 2016-09-16: updated for new esums and 12 tau objects
-- HB 2016-05-31: inserted all frames of calo links for extended format structure of test-vector-file and sim-spy-memory

--===============================================================================================--
--                             Proposed structure of lanes:
-- ===============================================================================================
-- Object types/Objects from Calop Layer 2 to uGT:
-- protocol : 192 bits/lane, one object has 32-bits.
-- =======================================================
--
-- Object-type         Objects     used GTHs   link
--                     (32 bits)
-- electron/gamma      6 (5..0)        1        4
-- electron/gamma      6 (11..6)       1        5
-- jet                 6 (5..0)        1        6
-- jet                 6 (11..6)       1        7
-- tau                 6 (5..0)        1        8
-- tau                 6 (11..6)       1        9
-- esums               6               1       10
-- spare               6               1       11
-- ext-cond(63..0)     2               1       12
-- ext-cond(127..64)   2               1       13
-- ext-cond(191..128)  2               1       14
-- ext-cond(255..192)  2               1       15
--                     (64 bits)
-- muon                2 (1..0)        1        0
-- muon                2 (3..2)        1        1
-- muon                2 (5..4)        1        2
-- muon                2 (7..6)        1        3
-- __________________________________________________________
-- Summary             72 (32 bits)    16
--
-- Proposed structure of objects (32 bits) within the 192 bits:
--             192...........................0
-- e/g         5      4     3    2    1      0
-- e/g         11     10    9    8    7      6
-- jet         5      4     3    2    1      0
-- jet         11     10    9    8    7      6
-- tau         5      4     3    2    1      0
-- tau         11     10    9    8    7      6
-- esums       HTmHF  ETmHF HTm* ETm* HT,TC* ET,ETTEM*
-- ext-cond    x      x     x    x    1      0
-- ext-cond    x      x     x    x    3      2
-- ext-cond    x      x     x    x    5      4
-- ext-cond    x      x     x    x    7      6
-- muon        1h     1l    0h   0l   x      x
-- muon        3h     3l    2h   2l   x      x
-- muon        5h     5l    4h   4l   x      x
-- muon        7h     7l    6h   6l   x      x
--
-- *) in addition 4 MSBs for Minimum Bias bits. TC means "TOWERCNT" (ECAL sum)

--===============================================================================================--


library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package lhc_data_pkg is 

-- HB 2016-06-01: constants for lane mapping (used in lmp.vhd)
	constant OFFSET_MUON_LANES : natural := 0;
	constant OFFSET_EG_LANES : natural := 4;
	constant OFFSET_JET_LANES : natural := 6;
	constant OFFSET_TAU_LANES : natural := 8;
	constant OFFSET_ESUMS_LANES : natural := 10;
-- HB 2106-05-31: proposal for memory structure with all frames of calo links for extended test-vector-file structure (see lhc_data_pkg_all_frames.vhd)
	constant OFFSET_LINK_11_LANES : natural := 11;
	constant OFFSET_EXT_COND_LANES : natural := 12;

--  for simspy memory (test with ipb_dpmem_4096_32)
	constant SW_DATA_WIDTH : integer := 32;

	constant MUON_ARRAY_LENGTH : integer := 8;
	constant MUON_DATA_WIDTH : integer := SW_DATA_WIDTH*2;
	constant EG_ARRAY_LENGTH : integer := 12;
	constant EG_DATA_WIDTH : integer := SW_DATA_WIDTH;
	constant TAU_ARRAY_LENGTH : integer := 12;
	constant TAU_DATA_WIDTH : integer := SW_DATA_WIDTH;
	constant JET_ARRAY_LENGTH : integer := 12;
	constant JET_DATA_WIDTH : integer := SW_DATA_WIDTH;
	constant ETT_DATA_WIDTH : integer := SW_DATA_WIDTH;
	constant HT_DATA_WIDTH : integer := SW_DATA_WIDTH;
	constant ETM_DATA_WIDTH : integer := SW_DATA_WIDTH;
	constant HTM_DATA_WIDTH : integer := SW_DATA_WIDTH;
	constant ETMHF_DATA_WIDTH : integer := SW_DATA_WIDTH;
	constant HTMHF_DATA_WIDTH : integer := SW_DATA_WIDTH;
	constant LINK_11_FR_0_WIDTH : integer := SW_DATA_WIDTH;
	constant LINK_11_FR_1_WIDTH : integer := SW_DATA_WIDTH;
	constant LINK_11_FR_2_WIDTH : integer := SW_DATA_WIDTH;
	constant LINK_11_FR_3_WIDTH : integer := SW_DATA_WIDTH;
	constant LINK_11_FR_4_WIDTH : integer := SW_DATA_WIDTH;
	constant LINK_11_FR_5_WIDTH : integer := SW_DATA_WIDTH;
	constant EXTERNAL_CONDITIONS_DATA_WIDTH : integer := SW_DATA_WIDTH*8;

	constant LHC_DATA_WIDTH : integer := 
		(
			(MUON_ARRAY_LENGTH*MUON_DATA_WIDTH) +
			(EG_ARRAY_LENGTH*EG_DATA_WIDTH) +
			(TAU_ARRAY_LENGTH*TAU_DATA_WIDTH) +
			(JET_ARRAY_LENGTH*JET_DATA_WIDTH) +
			ETT_DATA_WIDTH +
			HT_DATA_WIDTH +
			ETM_DATA_WIDTH +
			HTM_DATA_WIDTH +
			ETMHF_DATA_WIDTH + 
			HTMHF_DATA_WIDTH +
			LINK_11_FR_0_WIDTH + LINK_11_FR_1_WIDTH +
			LINK_11_FR_2_WIDTH + LINK_11_FR_3_WIDTH +
			LINK_11_FR_4_WIDTH + LINK_11_FR_5_WIDTH +
			EXTERNAL_CONDITIONS_DATA_WIDTH
		);

	type muon_array_t is array(0 to MUON_ARRAY_LENGTH-1) of std_logic_vector(MUON_DATA_WIDTH-1 downto 0);
	type eg_array_t is array(0 to EG_ARRAY_LENGTH-1) of std_logic_vector(EG_DATA_WIDTH-1 downto 0);
	type tau_array_t is array(0 to TAU_ARRAY_LENGTH-1) of std_logic_vector(TAU_DATA_WIDTH-1 downto 0);
	type jet_array_t is array(0 to JET_ARRAY_LENGTH-1) of std_logic_vector(JET_DATA_WIDTH-1 downto 0);

	type lhc_data_t is record 
		muon : muon_array_t;
		eg : eg_array_t;
		tau : tau_array_t;
		jet : jet_array_t;
		ett : std_logic_vector(ETT_DATA_WIDTH-1 downto 0);
		ht : std_logic_vector(HT_DATA_WIDTH-1 downto 0);
		etm : std_logic_vector(ETM_DATA_WIDTH-1 downto 0);
		htm : std_logic_vector(HTM_DATA_WIDTH-1 downto 0);
		etmhf : std_logic_vector(ETMHF_DATA_WIDTH-1 downto 0);
		htmhf : std_logic_vector(HTMHF_DATA_WIDTH-1 downto 0);		
		link_11_fr_0_data : std_logic_vector(LINK_11_FR_0_WIDTH-1 downto 0);
		link_11_fr_1_data : std_logic_vector(LINK_11_FR_1_WIDTH-1 downto 0);
		link_11_fr_2_data : std_logic_vector(LINK_11_FR_2_WIDTH-1 downto 0);
		link_11_fr_3_data : std_logic_vector(LINK_11_FR_3_WIDTH-1 downto 0);
		link_11_fr_4_data : std_logic_vector(LINK_11_FR_4_WIDTH-1 downto 0);
		link_11_fr_5_data : std_logic_vector(LINK_11_FR_5_WIDTH-1 downto 0);		
		external_conditions : std_logic_vector(EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto 0);
	end record; 

	constant LHC_DATA_NULL : lhc_data_t := 
		(
			muon => (others=>(others=>'0')),
			eg => (others=>(others=>'0')),
			tau => (others=>(others=>'0')),
			jet => (others=>(others=>'0')),
			ett => (others=>'0'),
			ht => (others=>'0'),
			etm => (others=>'0'),
			htm => (others=>'0'),
			etmhf => (others=>'0'),
			htmhf => (others=>'0'),
			link_11_fr_0_data => (others=>'0'),
			link_11_fr_1_data => (others=>'0'),
			link_11_fr_2_data => (others=>'0'),
			link_11_fr_3_data => (others=>'0'),
			link_11_fr_4_data => (others=>'0'),
			link_11_fr_5_data => (others=>'0'),
			external_conditions => (others=>'0')
		);

	constant LHC_DATA_OBJECT_COUNT : integer :=17;
	constant INDEX_MUON : integer := 0;
	constant INDEX_EG : integer := 1;
	constant INDEX_TAU : integer := 2;
	constant INDEX_JET : integer := 3;
	constant INDEX_ETT : integer := 4;
	constant INDEX_HT : integer := 5;
	constant INDEX_ETM : integer := 6;
	constant INDEX_HTM : integer := 7;
	constant INDEX_ETMHF : integer := 8;
	constant INDEX_HTMHF : integer := 9;
	constant INDEX_LINK_11_FR_0 : integer := 10;
	constant INDEX_LINK_11_FR_1 : integer := 11;
	constant INDEX_LINK_11_FR_2 : integer := 12;
	constant INDEX_LINK_11_FR_3 : integer := 13;
	constant INDEX_LINK_11_FR_4 : integer := 14;
	constant INDEX_LINK_11_FR_5 : integer := 15;
	constant INDEX_EXTERNAL_CONDITIONS : integer := 16;
	type lhc_data_slv_property_t is array (0 to LHC_DATA_OBJECT_COUNT-1) of natural;

	constant LHC_DATA_SLV_OBJECT_WIDTH : lhc_data_slv_property_t := 
		(
			MUON_ARRAY_LENGTH * MUON_DATA_WIDTH,
			EG_ARRAY_LENGTH * EG_DATA_WIDTH,
			TAU_ARRAY_LENGTH * TAU_DATA_WIDTH,
			JET_ARRAY_LENGTH * JET_DATA_WIDTH,
			ETT_DATA_WIDTH,
			HT_DATA_WIDTH,
			ETM_DATA_WIDTH,
			HTM_DATA_WIDTH,
			ETMHF_DATA_WIDTH, 
			HTMHF_DATA_WIDTH,
			LINK_11_FR_0_WIDTH, LINK_11_FR_1_WIDTH,
			LINK_11_FR_2_WIDTH, LINK_11_FR_3_WIDTH,
			LINK_11_FR_4_WIDTH, LINK_11_FR_5_WIDTH,
			EXTERNAL_CONDITIONS_DATA_WIDTH
		);

	constant LHC_DATA_SLV_START_INDICES : lhc_data_slv_property_t; -- see body

	-- converter function prototypes
	function lhc_data_t_to_std_logic_vector (data_in : lhc_data_t)
	return std_logic_vector;

	function std_logic_vector_to_lhc_data_t (data_in : std_logic_vector(LHC_DATA_WIDTH-1 downto 0))
	return lhc_data_t;

end package;

package body lhc_data_pkg is

	function lhc_data_t_to_std_logic_vector (data_in : lhc_data_t )
		return std_logic_vector
	is
		variable ret_value : std_logic_vector(LHC_DATA_WIDTH-1 downto 0);
		variable index : natural := 0;
	begin
		for i in 0 to MUON_ARRAY_LENGTH-1 loop
			ret_value(index+(i+1)*MUON_DATA_WIDTH-1 downto index+(i*MUON_DATA_WIDTH)) := data_in.muon(i);
		end loop;
		index := index + (MUON_ARRAY_LENGTH * MUON_DATA_WIDTH);

		for i in 0 to EG_ARRAY_LENGTH-1 loop
			ret_value(index+(i+1)*EG_DATA_WIDTH-1 downto index+(i*EG_DATA_WIDTH)) := data_in.eg(i);
		end loop;
		index := index + (EG_ARRAY_LENGTH * EG_DATA_WIDTH);

		for i in 0 to TAU_ARRAY_LENGTH-1 loop
			ret_value(index+(i+1)*TAU_DATA_WIDTH-1 downto index+(i*TAU_DATA_WIDTH)) := data_in.tau(i);
		end loop;
		index := index + (TAU_ARRAY_LENGTH * TAU_DATA_WIDTH);

		for i in 0 to JET_ARRAY_LENGTH-1 loop
			ret_value(index+(i+1)*JET_DATA_WIDTH-1 downto index+(i*JET_DATA_WIDTH)) := data_in.jet(i);
		end loop;
		index := index + (JET_ARRAY_LENGTH * JET_DATA_WIDTH);

		ret_value(index + ETT_DATA_WIDTH-1 downto index) := data_in.ett;
		index := index + ETT_DATA_WIDTH;
		ret_value(index + HT_DATA_WIDTH-1 downto index) := data_in.ht;
		index := index + HT_DATA_WIDTH;
		ret_value(index + ETM_DATA_WIDTH-1 downto index) := data_in.etm;
		index := index + ETM_DATA_WIDTH;
		ret_value(index + HTM_DATA_WIDTH-1 downto index) := data_in.htm;
		index := index + HTM_DATA_WIDTH;
		ret_value(index + ETMHF_DATA_WIDTH-1 downto index) := data_in.etmhf;
		index := index + ETMHF_DATA_WIDTH;
		ret_value(index + HTMHF_DATA_WIDTH-1 downto index) := data_in.htmhf;
		index := index + HTMHF_DATA_WIDTH;
		
		ret_value(index + LINK_11_FR_0_WIDTH-1 downto index) := data_in.link_11_fr_0_data;
		index := index + LINK_11_FR_0_WIDTH;
		ret_value(index + LINK_11_FR_1_WIDTH-1 downto index) := data_in.link_11_fr_1_data;
		index := index + LINK_11_FR_1_WIDTH;
		ret_value(index + LINK_11_FR_2_WIDTH-1 downto index) := data_in.link_11_fr_2_data;
		index := index + LINK_11_FR_2_WIDTH;
		ret_value(index + LINK_11_FR_3_WIDTH-1 downto index) := data_in.link_11_fr_3_data;
		index := index + LINK_11_FR_3_WIDTH;
		ret_value(index + LINK_11_FR_4_WIDTH-1 downto index) := data_in.link_11_fr_4_data;
		index := index + LINK_11_FR_4_WIDTH;
		ret_value(index + LINK_11_FR_5_WIDTH-1 downto index) := data_in.link_11_fr_5_data;
		index := index + LINK_11_FR_5_WIDTH;
		
		ret_value(index + EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto index) := data_in.external_conditions;
		index := index + EXTERNAL_CONDITIONS_DATA_WIDTH;
		return ret_value;
	end function;

	function std_logic_vector_to_lhc_data_t (data_in : std_logic_vector(LHC_DATA_WIDTH-1 downto 0)) 
		return lhc_data_t
	is
		variable ret_value : lhc_data_t;
		variable index : natural := 0;
	begin
		for i in 0 to MUON_ARRAY_LENGTH-1 loop
			ret_value.muon(i) := data_in( index+(i+1)*MUON_DATA_WIDTH-1 downto index+(i* MUON_DATA_WIDTH));
		end loop;
		index := index + (MUON_ARRAY_LENGTH * MUON_DATA_WIDTH);

		for i in 0 to EG_ARRAY_LENGTH-1 loop
			ret_value.eg(i) := data_in( index+(i+1)*EG_DATA_WIDTH-1 downto index+(i* EG_DATA_WIDTH));
		end loop;
		index := index + (EG_ARRAY_LENGTH * EG_DATA_WIDTH);

		for i in 0 to TAU_ARRAY_LENGTH-1 loop
			ret_value.tau(i) := data_in( index+(i+1)*TAU_DATA_WIDTH-1 downto index+(i* TAU_DATA_WIDTH));
		end loop;
		index := index + (TAU_ARRAY_LENGTH * TAU_DATA_WIDTH);
		
		for i in 0 to JET_ARRAY_LENGTH-1 loop
			ret_value.jet(i) := data_in( index+(i+1)*JET_DATA_WIDTH-1 downto index+(i* JET_DATA_WIDTH));
		end loop;
		index := index + (JET_ARRAY_LENGTH * JET_DATA_WIDTH);

		ret_value.ett := data_in(index + ETT_DATA_WIDTH-1 downto index);
		index := index + ETT_DATA_WIDTH;
		ret_value.ht := data_in(index + HT_DATA_WIDTH-1 downto index);
		index := index + HT_DATA_WIDTH;
		ret_value.etm := data_in(index + ETM_DATA_WIDTH-1 downto index);
		index := index + ETM_DATA_WIDTH;
		ret_value.htm := data_in(index + HTM_DATA_WIDTH-1 downto index);
		index := index + HTM_DATA_WIDTH;		
		ret_value.etmhf := data_in(index + ETMHF_DATA_WIDTH-1 downto index);
		index := index + ETMHF_DATA_WIDTH;
		ret_value.htmhf := data_in(index + HTMHF_DATA_WIDTH-1 downto index);
		index := index + HTMHF_DATA_WIDTH;
		
		ret_value.link_11_fr_0_data := data_in(index + LINK_11_FR_0_WIDTH-1 downto index);
		index := index + LINK_11_FR_0_WIDTH;
		ret_value.link_11_fr_1_data := data_in(index + LINK_11_FR_1_WIDTH-1 downto index);
		index := index + LINK_11_FR_1_WIDTH;
		ret_value.link_11_fr_2_data := data_in(index + LINK_11_FR_2_WIDTH-1 downto index);
		index := index + LINK_11_FR_2_WIDTH;
		ret_value.link_11_fr_3_data := data_in(index + LINK_11_FR_3_WIDTH-1 downto index);
		index := index + LINK_11_FR_3_WIDTH;
		ret_value.link_11_fr_4_data := data_in(index + LINK_11_FR_4_WIDTH-1 downto index);
		index := index + LINK_11_FR_4_WIDTH;
		ret_value.link_11_fr_5_data := data_in(index + LINK_11_FR_5_WIDTH-1 downto index);
		index := index + LINK_11_FR_5_WIDTH;
		
		ret_value.external_conditions := data_in(index + EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto index);
		index := index + EXTERNAL_CONDITIONS_DATA_WIDTH;
		return ret_value;
	end function;

	function init_indices return lhc_data_slv_property_t is
		variable ret_value : lhc_data_slv_property_t;
	begin
		ret_value(0) := 0;
		for i in 1 to LHC_DATA_OBJECT_COUNT-1 loop
			ret_value(i) := ret_value(i-1) + LHC_DATA_SLV_OBJECT_WIDTH(i-1);
		end loop;
		return ret_value;
	end;
	constant LHC_DATA_SLV_START_INDICES : lhc_data_slv_property_t := init_indices ;

end;
