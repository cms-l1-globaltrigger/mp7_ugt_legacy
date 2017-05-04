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
---Description: DSMUX
-- $HeadURL: s $
-- $Date: $
-- $Author: HEPHY $
-- $Revision: 0.1 $
--------------------------------------------------------------------------------
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.gt_mp7_core_pkg.all;
use work.lhc_data_pkg.all;
use work.rb_pkg.all;

entity dsmux is
	generic
	(
		USE_SW_INPUT_REGISTER : boolean := true;
		USE_SIMMEM_IN_USE_OUTPUT_REGISTER : boolean := true
	);
	port
	(
		lhc_clk : std_logic;
		lhc_rst : std_logic;

		sw_reg_i : in sw_reg_dsmux_in_t;

		lhc_data_sim_i : in lhc_data_t;
		lhc_data_ext_i : in lhc_data_t;

		lhc_data_sim_valid_i : in std_logic;
		lhc_data_ext_valid_i : in std_logic;

		lhc_data_o : out lhc_data_t;
		lhc_data_valid_o : out std_logic;

		simmem_in_use_o : out std_logic
	);
end;


architecture arch of dsmux is

	type src_bits_array_t is array(0 to LHC_DATA_OBJECT_COUNT-1) of std_logic;
	signal src_bits_array_in : src_bits_array_t;
	signal src_bits_array_internal : src_bits_array_t;

	signal simmem_in_use_internal : std_logic;
begin

	src_bits_array_in <= (sw_reg_i.muon_src, sw_reg_i.eg_src, sw_reg_i.tau_src, sw_reg_i.jet_src,
	                      sw_reg_i.ett_src, sw_reg_i.ht_src, sw_reg_i.etm_src, sw_reg_i.htm_src,
	                      sw_reg_i.ett_src, sw_reg_i.ett_src, -- dummy for ETMHF and HTMHF
	                      sw_reg_i.ett_src, sw_reg_i.ett_src, sw_reg_i.ett_src, sw_reg_i.ett_src,
	                      sw_reg_i.ett_src, sw_reg_i.ett_src, -- dummy for link 11 (6 frames)
	                      sw_reg_i.ext_con_src);

	process(sw_reg_i, src_bits_array_internal, lhc_data_ext_i, lhc_data_sim_i)
		variable lhc_data_slv_src_A : std_logic_vector(LHC_DATA_WIDTH-1 downto 0);
		variable lhc_data_slv_src_B : std_logic_vector(LHC_DATA_WIDTH-1 downto 0);
		variable lhc_data_slv_result : std_logic_vector(LHC_DATA_WIDTH-1 downto 0);
	begin

		lhc_data_slv_src_A := lhc_data_t_to_std_logic_vector(lhc_data_ext_i);
		lhc_data_slv_src_B := lhc_data_t_to_std_logic_vector(lhc_data_sim_i);

		for i in 0 to LHC_DATA_OBJECT_COUNT-1 loop
			if src_bits_array_internal(i) = '1' then
				lhc_data_slv_result(LHC_DATA_SLV_START_INDICES(i)+LHC_DATA_SLV_OBJECT_WIDTH(i)-1 downto LHC_DATA_SLV_START_INDICES(i)) :=
					lhc_data_slv_src_B(LHC_DATA_SLV_START_INDICES(i)+LHC_DATA_SLV_OBJECT_WIDTH(i)-1 downto LHC_DATA_SLV_START_INDICES(i));
			else
				lhc_data_slv_result(LHC_DATA_SLV_START_INDICES(i)+LHC_DATA_SLV_OBJECT_WIDTH(i)-1 downto LHC_DATA_SLV_START_INDICES(i)) :=
					lhc_data_slv_src_A(LHC_DATA_SLV_START_INDICES(i)+LHC_DATA_SLV_OBJECT_WIDTH(i)-1 downto LHC_DATA_SLV_START_INDICES(i));
			end if;
		end loop;
		lhc_data_o <= std_logic_vector_to_lhc_data_t(lhc_data_slv_result);
	end process;


	gen_valid_signal : process(src_bits_array_internal, lhc_data_sim_valid_i, lhc_data_ext_valid_i)
		variable and_result : std_logic;
		variable or_result : std_logic;
	begin
		and_result := '1';
		or_result := '0';

		for i in 0 to src_bits_array_internal'length-1 loop
			and_result := and_result and src_bits_array_internal(i);
			or_result  := or_result  or  src_bits_array_internal(i);
		end loop;

		if and_result = '1' then -- all src bits are one --> output data comes only from sim memory
			lhc_data_valid_o <= lhc_data_sim_valid_i;
			simmem_in_use_internal <= '1';
		elsif or_result = '1' then -- mixed
			lhc_data_valid_o <= lhc_data_sim_valid_i and lhc_data_ext_valid_i;
			simmem_in_use_internal <= '1';
		else
			lhc_data_valid_o <= lhc_data_ext_valid_i;
			simmem_in_use_internal <= '0'; --real data only
		end if;
	end process;



	GEN_SIMMEM_IN_USE_OUTPUT_REGISTER : if USE_SIMMEM_IN_USE_OUTPUT_REGISTER = true generate
-- HEPHY changed the Rest logic
		process (lhc_clk, lhc_rst)
		begin
			if lhc_rst = RST_ACT_ROP then
				simmem_in_use_o <= '0';
			elsif rising_edge(lhc_clk) then
				simmem_in_use_o <= simmem_in_use_internal;
			end if;
		end process;

	end generate;

	GEN_NO_SIMMEM_IN_USE_OUTPUT_REGISTER : if USE_SIMMEM_IN_USE_OUTPUT_REGISTER = false generate
		simmem_in_use_o <= simmem_in_use_internal;
	end generate;

-- HEPHY changed the Rest logic
	GEN_SW_INPUT_REGISTER : if USE_SW_INPUT_REGISTER = true generate
		process (lhc_clk, lhc_rst)
		begin
			if lhc_rst = RST_ACT_ROP then
				src_bits_array_internal <= (others => '0');
			elsif rising_edge(lhc_clk) then
				src_bits_array_internal <= src_bits_array_in;
			end if;
		end process;
	end generate;

	GEN_NO_SW_INPUT_REGISTER : if USE_SW_INPUT_REGISTER = false generate
		src_bits_array_internal <= src_bits_array_in;
	end generate;

	-- simple version with only one src bit
	-- lhc_data_o <= lhc_data_sim_i when sw_reg_i.src = '1' else lhc_data_ext_i;
	-- lhc_data_valid_o <= lhc_data_sim_valid_i when sw_reg_i.src = '1' else lhc_data_ext_valid_i;

end architecture;
