-- Description:
-- Package for definitions of lhc data.

-- Version history:
-- HB 2023-09-06: inserted calo anomaly algorithm (CICADA) data on link 11 (removed zdc10g on link 11).
-- HB 2023-08-25: ZDC 5G on link 71.
-- HB 2023-02-09: updated comments.
-- HB 2022-10-08: zdc10g on link 11.
-- HB 2022-09-08: cleaned up.
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
-- cicada              6               1       11
-- ext-cond(63..0)     2               1       12
-- ext-cond(127..64)   2               1       13
-- ext-cond(191..128)  2               1       14
-- ext-cond(255..192)  2               1       15
-- CICADA              6               1       16
--                     (64 bits)
-- muon                2 (1..0)        1        0
-- muon                2 (3..2)        1        1
-- muon                2 (5..4)        1        2
-- muon                2 (7..6)        1        3
-- zdc                 6               1       71
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
-- CICADA      5      4     3    2    1      0
-- ext-cond    x      x     x    x    1      0
-- ext-cond    x      x     x    x    3      2
-- ext-cond    x      x     x    x    5      4
-- ext-cond    x      x     x    x    7      6
-- muon        1h     1l    0h   0l   x      x
-- muon        3h     3l    2h   2l   x      x
-- muon        5h     5l    4h   4l   x      x
-- muon        7h     7l    6h   6l   x      x
-- zdc (5G)    5      4     3    2    1      0     
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
    constant OFFSET_CICADA_LANES : natural := 13;
    constant OFFSET_ZDC5G_LANES : natural := 71;

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
    constant CICADA_ARRAY_LENGTH : integer := 6;
    constant CICADA_DATA_WIDTH : integer := SW_DATA_WIDTH;
    constant EXTERNAL_CONDITIONS_DATA_WIDTH : integer := SW_DATA_WIDTH*8;
    constant ZDC5G_0_WIDTH : integer := SW_DATA_WIDTH;
    constant ZDC5G_1_WIDTH : integer := SW_DATA_WIDTH;
    constant ZDC5G_2_WIDTH : integer := SW_DATA_WIDTH;
    constant ZDC5G_3_WIDTH : integer := SW_DATA_WIDTH;
    constant ZDC5G_4_WIDTH : integer := SW_DATA_WIDTH;
    constant ZDC5G_5_WIDTH : integer := SW_DATA_WIDTH;

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
            (CICADA_ARRAY_LENGTH*CICADA_DATA_WIDTH) +
            EXTERNAL_CONDITIONS_DATA_WIDTH
            EXTERNAL_CONDITIONS_DATA_WIDTH +
            ZDC5G_0_WIDTH + ZDC5G_1_WIDTH +
            ZDC5G_2_WIDTH + ZDC5G_3_WIDTH +
            ZDC5G_4_WIDTH + ZDC5G_5_WIDTH
        );

    type muon_array_t is array(0 to MUON_ARRAY_LENGTH-1) of std_logic_vector(MUON_DATA_WIDTH-1 downto 0);
    type eg_array_t is array(0 to EG_ARRAY_LENGTH-1) of std_logic_vector(EG_DATA_WIDTH-1 downto 0);
    type tau_array_t is array(0 to TAU_ARRAY_LENGTH-1) of std_logic_vector(TAU_DATA_WIDTH-1 downto 0);
    type jet_array_t is array(0 to JET_ARRAY_LENGTH-1) of std_logic_vector(JET_DATA_WIDTH-1 downto 0);
    type cicada_array_t is array(0 to CICADA_ARRAY_LENGTH-1) of std_logic_vector(CICADA_DATA_WIDTH-1 downto 0);

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
        cicada : cicada_array_t;
        external_conditions : std_logic_vector(EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto 0);
        ZDC5G_0 : std_logic_vector(ZDC5G_0_WIDTH-1 downto 0);
        ZDC5G_1 : std_logic_vector(ZDC5G_1_WIDTH-1 downto 0);
        ZDC5G_2 : std_logic_vector(ZDC5G_2_WIDTH-1 downto 0);
        ZDC5G_3 : std_logic_vector(ZDC5G_3_WIDTH-1 downto 0);
        ZDC5G_4 : std_logic_vector(ZDC5G_4_WIDTH-1 downto 0);
        ZDC5G_5 : std_logic_vector(ZDC5G_5_WIDTH-1 downto 0);
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
            cicada => (others=>(others=>'0')),
            external_conditions => (others=>'0'),
            ZDC5G_0 => (others=>'0'),
            ZDC5G_1 => (others=>'0'),
            ZDC5G_2 => (others=>'0'),
            ZDC5G_3 => (others=>'0'),
            ZDC5G_4 => (others=>'0'),
            ZDC5G_5 => (others=>'0')
        );

    constant LHC_DATA_OBJECT_COUNT : integer :=18;
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
    constant INDEX_CICADA : integer := 10;
    constant INDEX_EXTERNAL_CONDITIONS : integer := 11;
    constant INDEX_ZDC5G_0 : integer := 12;
    constant INDEX_ZDC5G_1 : integer := 13;
    constant INDEX_ZDC5G_2 : integer := 14;
    constant INDEX_ZDC5G_3 : integer := 15;
    constant INDEX_ZDC5G_4 : integer := 16;
    constant INDEX_ZDC5G_5 : integer := 17;
    
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
            CICADA_ARRAY_LENGTH * CICADA_DATA_WIDTH,         
            EXTERNAL_CONDITIONS_DATA_WIDTH
            ZDC5G_0_WIDTH, ZDC5G_1_WIDTH,
            ZDC5G_2_WIDTH, ZDC5G_3_WIDTH,
            ZDC5G_4_WIDTH, ZDC5G_5_WIDTH
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

        for i in 0 to CICADA_ARRAY_LENGTH-1 loop
            ret_value(index+(i+1)*CICADA_DATA_WIDTH-1 downto index+(i*CICADA_DATA_WIDTH)) := data_in.cicada(i);
        end loop;
        index := index + (CICADA_ARRAY_LENGTH * CICADA_DATA_WIDTH);

        ret_value(index + EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto index) := data_in.external_conditions;
        index := index + EXTERNAL_CONDITIONS_DATA_WIDTH;

        ret_value(index + ZDC5G_0_WIDTH-1 downto index) := data_in.ZDC5G_0;
        index := index + ZDC5G_0_WIDTH;
        ret_value(index + ZDC5G_1_WIDTH-1 downto index) := data_in.ZDC5G_1;
        index := index + ZDC5G_1_WIDTH;
        ret_value(index + ZDC5G_2_WIDTH-1 downto index) := data_in.ZDC5G_2;
        index := index + ZDC5G_2_WIDTH;
        ret_value(index + ZDC5G_3_WIDTH-1 downto index) := data_in.ZDC5G_3;
        index := index + ZDC5G_3_WIDTH;
        ret_value(index + ZDC5G_4_WIDTH-1 downto index) := data_in.ZDC5G_4;
        index := index + ZDC5G_4_WIDTH;
        ret_value(index + ZDC5G_5_WIDTH-1 downto index) := data_in.ZDC5G_5;
        index := index + ZDC5G_5_WIDTH;

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

        for i in 0 to CICADA_ARRAY_LENGTH-1 loop
            ret_value.jet(i) := data_in( index+(i+1)*CICADA_DATA_WIDTH-1 downto index+(i* CICADA_DATA_WIDTH));
        end loop;
        index := index + (CICADA_ARRAY_LENGTH * CICADA_DATA_WIDTH);

        ret_value.external_conditions := data_in(index + EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto index);
        index := index + EXTERNAL_CONDITIONS_DATA_WIDTH;

        ret_value.ZDC5G_0 := data_in(index + ZDC5G_0_WIDTH-1 downto index);
        index := index + ZDC5G_0_WIDTH;
        ret_value.ZDC5G_1 := data_in(index + ZDC5G_1_WIDTH-1 downto index);
        index := index + ZDC5G_1_WIDTH;
        ret_value.ZDC5G_2 := data_in(index + ZDC5G_2_WIDTH-1 downto index);
        index := index + ZDC5G_2_WIDTH;
        ret_value.ZDC5G_3 := data_in(index + ZDC5G_3_WIDTH-1 downto index);
        index := index + ZDC5G_3_WIDTH;
        ret_value.ZDC5G_4 := data_in(index + ZDC5G_4_WIDTH-1 downto index);
        index := index + ZDC5G_4_WIDTH;
        ret_value.ZDC5G_5 := data_in(index + ZDC5G_5_WIDTH-1 downto index);
        index := index + ZDC5G_5_WIDTH;

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
