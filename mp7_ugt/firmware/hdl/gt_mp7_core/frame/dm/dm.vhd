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
-- $Author: Florian $
-- Modification : HEPHY
-- 		1) lhc_rst for ip-bus and PCI-e is different. RST_ACT is defined in package.
-- $Revision: 0.1  $
--------------------------------------------------------------------------------

-- HB 2016-09-19: updated for "all frames" (new esums).
-- HB 2016-04-11: implemented delays for EC0, OC0, RESYNC and START (same delay as BCRES). Inserted bcres_outputmux_o - delayed version of bcres for output mux.

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.gt_mp7_core_pkg.all;
use work.lhc_data_pkg.all;
use work.rb_pkg.all;
use work.math_pkg.all;

entity dm is
	generic
	(
		USE_REGISTERED_OUTPUT : boolean := false
	);
	port
	(
		lhc_clk : in std_logic;
		lhc_rst : in std_logic;

		lhc_data_i : in lhc_data_t;
		lhc_data_o : out lhc_data_t; -- delayed version of lhc_data

		bcres_i : in std_logic;
		ec0_i : in std_logic;
		oc0_i : in std_logic;
		resync_i : in std_logic;
		start_i : in std_logic;
		bcres_o : out std_logic;     -- delayed version of bcres. This signal has an additional delay on 1BX to compensate the regional delay in the output mux
		ec0_o : out std_logic;     -- delayed ec0
		oc0_o : out std_logic;     -- delayed oc0
		resync_o : out std_logic;     -- delayed resync
		start_o : out std_logic;     -- delayed start
		bcres_fdl_o : out std_logic; -- delayed version of bcres for fdl. This signal has an additional delay on 1BX to compensate the regional delay in the output mux
		bcres_outputmux_o : out std_logic; -- delayed version of bcres for output mux
		valid_i : in std_logic;
		valid_o : out std_logic;     -- 1 if lhc_data is valid

		sw_reg_i : in sw_reg_dm_in_t;
		sw_reg_o : out sw_reg_dm_out_t
	);
end;


architecture arch of dm is

	component delay_element
		generic
		(
			DATA_WIDTH : integer := 32;
			MAX_DELAY : integer := 31
		);
		port
		(
			lhc_clk : in std_logic;
			lhc_rst : in std_logic;

			data_i : in std_logic_vector;
			data_o : out std_logic_vector;

			valid_i : in std_logic;
			valid_o : out std_logic;

			delay : in std_logic_vector(log2c(MAX_DELAY)-1 downto 0)
		);
	end component;

	signal valid_flags : std_logic_vector(LHC_DATA_OBJECT_COUNT-1 downto 0);
	signal bcres_valid : std_logic;
	signal bcres_fdl_valid : std_logic;

	signal lhc_data_slv_i : std_logic_vector(LHC_DATA_WIDTH-1 downto 0);
	signal lhc_data_slv_o : std_logic_vector(LHC_DATA_WIDTH-1 downto 0);

	type delay_array_t is array (0 to LHC_DATA_OBJECT_COUNT-1) of std_logic_vector(log2c(DM_MAX_DELAY_OBJECTS)-1 downto 0);

	signal delay_array : delay_array_t;

	signal bcres_i_slv : std_logic_vector(4 downto 0);
	signal bcres_o_slv : std_logic_vector(4 downto 0);
	signal bcres_fdl_o_slv : std_logic_vector(0 downto 0);

	signal lhc_data_out_internal : lhc_data_t;
	signal valid_out_internal : std_logic;

	signal bcres_out_internal : std_logic;
	signal ec0_out_internal : std_logic;
	signal oc0_out_internal : std_logic;
	signal resync_out_internal : std_logic;
	signal start_out_internal : std_logic;
	signal bcres_fdl_out_internal : std_logic;
	signal bcres_o_delayed : std_logic;
	signal ec0_o_delayed : std_logic;
	signal oc0_o_delayed : std_logic;
	signal resync_o_delayed : std_logic;
	signal start_o_delayed : std_logic;
	signal bcres_fdl_o_delayed : std_logic;

begin

	lhc_data_slv_i <= lhc_data_t_to_std_logic_vector(lhc_data_i);

	-- IMPORTANT:
	-- the delays must have the exact same order as the associated objects in lhc_data_t
	-- if a new object is added to lhc_data_t, the delay for this object must be added to the array

-- HB 2016-09-19: inserted all frames of calo links for extended format structure of test-vector-file
-- used delay_ett for etmhf_data, htmhf_data and link_11_fr_x_data (for own delays for link frames, rb must be extended).

	delay_array <= (sw_reg_i.delay_muons(log2c(DM_MAX_DELAY_OBJECTS)-1 downto 0),
	                sw_reg_i.delay_eg(log2c(DM_MAX_DELAY_OBJECTS)-1 downto 0),
	                sw_reg_i.delay_tau(log2c(DM_MAX_DELAY_OBJECTS)-1 downto 0),
	                sw_reg_i.delay_jet(log2c(DM_MAX_DELAY_OBJECTS)-1 downto 0),
	                sw_reg_i.delay_ett(log2c(DM_MAX_DELAY_OBJECTS)-1 downto 0),
	                sw_reg_i.delay_ht(log2c(DM_MAX_DELAY_OBJECTS)-1 downto 0),
	                sw_reg_i.delay_etm(log2c(DM_MAX_DELAY_OBJECTS)-1 downto 0),
	                sw_reg_i.delay_htm(log2c(DM_MAX_DELAY_OBJECTS)-1 downto 0),
	                sw_reg_i.delay_ett(log2c(DM_MAX_DELAY_OBJECTS)-1 downto 0), -- ETM_HF
	                sw_reg_i.delay_ett(log2c(DM_MAX_DELAY_OBJECTS)-1 downto 0), -- HTM_HF
	                sw_reg_i.delay_ett(log2c(DM_MAX_DELAY_OBJECTS)-1 downto 0), -- link_11_fr_0_data
	                sw_reg_i.delay_ett(log2c(DM_MAX_DELAY_OBJECTS)-1 downto 0), -- link_11_fr_1_data
	                sw_reg_i.delay_ett(log2c(DM_MAX_DELAY_OBJECTS)-1 downto 0), -- link_11_fr_2_data
	                sw_reg_i.delay_ett(log2c(DM_MAX_DELAY_OBJECTS)-1 downto 0), -- link_11_fr_3_data
	                sw_reg_i.delay_ett(log2c(DM_MAX_DELAY_OBJECTS)-1 downto 0), -- link_11_fr_4_data
	                sw_reg_i.delay_ett(log2c(DM_MAX_DELAY_OBJECTS)-1 downto 0), -- link_11_fr_5_data
	                sw_reg_i.delay_ext_con(log2c(DM_MAX_DELAY_OBJECTS)-1 downto 0));

	dealy_elements : for i in 0 to LHC_DATA_OBJECT_COUNT-1 generate
		d : delay_element
			generic map(
				DATA_WIDTH => LHC_DATA_SLV_OBJECT_WIDTH(i),
				MAX_DELAY => DM_MAX_DELAY_OBJECTS
			)
			port map(
				lhc_clk     => lhc_clk,
				lhc_rst     => lhc_rst,
				data_i      => lhc_data_slv_i(LHC_DATA_SLV_START_INDICES(i)+LHC_DATA_SLV_OBJECT_WIDTH(i)-1 downto LHC_DATA_SLV_START_INDICES(i)),
				data_o      => lhc_data_slv_o(LHC_DATA_SLV_START_INDICES(i)+LHC_DATA_SLV_OBJECT_WIDTH(i)-1 downto LHC_DATA_SLV_START_INDICES(i)),
				valid_i     => valid_i,
				valid_o     => valid_flags(i),
				delay       => delay_array(i) -- the delay array constructed above
			);
	end generate;

	-- wide and for valid out signal
	wide_and : process (valid_flags, bcres_valid)
		variable temp : std_logic;
	begin
		temp := valid_flags(0);
		for i in 1 to valid_flags'length-1 loop
			temp := temp and valid_flags(i);
		end loop;
		temp := temp and bcres_valid;
		valid_out_internal <= temp;
		sw_reg_o.valid <= temp;
	end process;

-- 	bcres_i_slv(0) <= bcres_i;
-- 	bcres_out_internal <= bcres_o_slv(0);
-- 	dm_bcres : delay_element
-- 		generic map
-- 		(
-- 			DATA_WIDTH => 1,
-- 			MAX_DELAY  => DM_MAX_DELAY_BCRES
-- 		)
-- 		port map
-- 		(
-- 			lhc_clk     => lhc_clk,
-- 			lhc_rst     => lhc_rst,
-- 			data_i      => bcres_i_slv,
-- 			data_o      => bcres_o_slv,
-- 			valid_i     => '1',
-- 			valid_o     => bcres_valid,
-- 			delay       => sw_reg_i.delay_bcres
-- 		);

-- HB 2016-03-10: implemented delays for EC0, OC0, RESYNC, START and STOP (same delay as BCRES)
	bcres_i_slv(0) <= bcres_i;
	bcres_i_slv(1) <= ec0_i;
	bcres_i_slv(2) <= oc0_i;
	bcres_i_slv(3) <= resync_i;
	bcres_i_slv(4) <= start_i;
	bcres_out_internal <= bcres_o_slv(0);
	ec0_out_internal <= bcres_o_slv(1);
	oc0_out_internal <= bcres_o_slv(2);
	resync_out_internal <= bcres_o_slv(3);
	start_out_internal <= bcres_o_slv(4);

	dm_bcres : delay_element
		generic map(
			DATA_WIDTH => 5,
			MAX_DELAY  => DM_MAX_DELAY_BCRES
		)
		port map(
			lhc_clk     => lhc_clk,
			lhc_rst     => lhc_rst,
			data_i      => bcres_i_slv(4 downto 0),
			data_o      => bcres_o_slv(4 downto 0),
			valid_i     => '1',
			valid_o     => bcres_valid,
			delay       => sw_reg_i.delay_bcres
		);

 	bcres_fdl_out_internal <= bcres_fdl_o_slv(0);

	dm_bcres_fdl : delay_element
		generic map(
			DATA_WIDTH => 1,
			MAX_DELAY  => DM_MAX_DELAY_BCRES
		)
		port map(
			lhc_clk     => lhc_clk,
			lhc_rst     => lhc_rst,
			data_i      => bcres_i_slv(0 downto 0),
			data_o      => bcres_fdl_o_slv(0 downto 0),
			valid_i     => '1',
			valid_o     => bcres_fdl_valid,
			delay       => sw_reg_i.delay_bcres_fdl
		);

	lhc_data_out_internal <= std_logic_vector_to_lhc_data_t(lhc_data_slv_o);

	sync_lhc_clk : process (lhc_clk, lhc_rst)
	begin
	    if lhc_rst = RST_ACT then
		bcres_o_delayed    <= '0';
		ec0_o_delayed    <= '0';
		oc0_o_delayed    <= '0';
		resync_o_delayed    <= '0';
		start_o_delayed    <= '0';
		bcres_fdl_o_delayed    <= '0';
	    elsif rising_edge(lhc_clk) then
		bcres_o_delayed         <= bcres_out_internal;
		ec0_o_delayed    <= ec0_out_internal;
		oc0_o_delayed    <= oc0_out_internal;
		resync_o_delayed    <= resync_out_internal;
		start_o_delayed    <= start_out_internal;
		bcres_fdl_o_delayed     <= bcres_fdl_out_internal;
	    end if;
	end process;

	GEN_ADDITIONAL_OUTPUT_REGISTER : if USE_REGISTERED_OUTPUT = true generate
		sync_lhc_clk : process (lhc_clk, lhc_rst)
		begin
		-- HEPHY: 04.02.2015 Delay Manager out put was zero, becaue lhc_rst for ip-bus and PCI-e is different. RST_ACT is defined in package.
			if lhc_rst = RST_ACT then
				valid_o    <= '0';
				lhc_data_o <= LHC_DATA_NULL;
				bcres_o    <= '0';
				ec0_o    <= '0';
				oc0_o    <= '0';
				resync_o    <= '0';
				start_o    <= '0';
				bcres_fdl_o    <= '0';
			elsif rising_edge(lhc_clk) then
				valid_o    <= valid_out_internal;
				lhc_data_o <= lhc_data_out_internal;
				bcres_o    <= bcres_o_delayed;
				ec0_o    <= ec0_o_delayed;
				oc0_o    <= oc0_o_delayed;
				resync_o    <= resync_o_delayed;
				start_o    <= start_o_delayed;
				bcres_outputmux_o    <= bcres_out_internal;
				bcres_fdl_o    <= bcres_fdl_o_delayed;
			end if;
		end process;
	end generate;

	DONT_GEN_ADDITIONAL_OUTPUT_REGISTER : if USE_REGISTERED_OUTPUT = false generate
		valid_o    <= valid_out_internal;
		lhc_data_o <= lhc_data_out_internal;
		bcres_o    <= bcres_o_delayed;
		ec0_o    <= ec0_o_delayed;
		oc0_o    <= oc0_o_delayed;
		resync_o    <= resync_o_delayed;
		start_o    <= start_o_delayed;
		bcres_outputmux_o    <= bcres_out_internal;
		bcres_fdl_o    <= bcres_fdl_o_delayed;
	end generate;

end architecture;



