--------------------------------------------------------------------------------
-- Simulator   : Modelsim 10.1
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Simulation
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/firmware/gt_mp7/branches/hb_algo_2_buffer/sim/testbench/lhc_data_debug_util_pkg.vhd $
-- $Date: 2015-05-27 15:51:13 +0200 (Mit, 27 Mai 2015) $
-- $Author: bergauer $
-- $Revision: 3998 $
--------------------------------------------------------------------------------

-- HB 2016-05-31: inserted all frames of calo links for extended format structure of test-vector-file

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use work.lhc_data_pkg.all;

package lhc_data_debug_util_pkg is 

	function lhc_data_t_to_string (data_in : lhc_data_t; spacer_char : character )
		return string;

	function string_to_lhc_data_t (data_in : string )
		return lhc_data_t;

end package;

package body lhc_data_debug_util_pkg is


	function slv_to_hex(slv : in std_logic_vector) return string is
		constant hex_digits : string(1 to 16) := "0123456789abcdef";
		constant num_hex_digits : integer := integer((slv'length+3)/4);
		variable ret_value : string(1 to num_hex_digits);
		variable zero_padded_slv : std_logic_vector((4*num_hex_digits)-1 downto 0) := (others=>'0');
		variable r : integer := 0;
	begin
		zero_padded_slv(slv'range) := slv;
		loop
			ret_value(num_hex_digits-r) :=  hex_digits(to_integer(unsigned( zero_padded_slv( (r+1)*4-1 downto 4*r) ))+1);
			r := r + 1;
			if num_hex_digits-r = 0 then
				exit;
			end if;
		end loop;
		return ret_value;
	end function;
	
	
	function max(a,b : integer) return integer is
	begin
		if a > b then
			return a;
		else
			return b;
		end if;
	end function;
	
	
	function hex_to_slv(hex : string; min_width : integer) return std_logic_vector is
		variable ret_value : std_logic_vector(max(hex'length*4-1,min_width-1) downto 0) := (others=>'0');
		variable temp : std_logic_vector(3 downto 0);
		variable r : integer := 0;
	begin
		ret_value := (others=>'0');
		for i in 0 to hex'length-1 loop
			case hex(hex'length-i) is
				when '0' => temp := x"0";
				when '1' => temp := x"1";	
				when '2' => temp := x"2";
				when '3' => temp := x"3";
				when '4' => temp := x"4";
				when '5' => temp := x"5";
				when '6' => temp := x"6";
				when '7' => temp := x"7";
				when '8' => temp := x"8";
				when '9' => temp := x"9";
				when 'a' | 'A' => temp := x"a";
				when 'b' | 'B' => temp := x"b";
				when 'c' | 'C' => temp := x"c";
				when 'd' | 'D' => temp := x"d";
				when 'e' | 'E' => temp := x"e";
				when 'f' | 'F' => temp := x"f";
				when others => report "Conversion Error: char: " & hex(hex'length-i) severity error;
			end case;
			ret_value((i+1)*4-1 downto i*4) := temp;
		end loop;
		return ret_value;
	end function;
	
	
	function is_hex_digit(c : character) return boolean is
	begin
		if c = '0' or c = '1' or c = '2' or c = '3' or
		   c = '4' or c = '5' or c = '6' or c = '7' or 
		   c = '8' or c = '9' or c = 'a' or c = 'b' or 
		   c = 'c' or c = 'd' or c = 'e' or c = 'f' or
		   c = 'A' or c = 'B' or c = 'C' or c = 'D' or
		   c = 'E' or c = 'F' then
			return true;
		else
			return false;
		end if;
	end function;
	
	procedure next_range (start_index : inout integer; end_index : inout integer; str : string) 
	is
	begin
		start_index := end_index+1;
		while not is_hex_digit(str(start_index)) loop
			start_index := start_index + 1;
		end loop;
		end_index := start_index;
		while is_hex_digit(str(end_index)) loop
			end_index := end_index + 1;
		end loop;
		end_index := end_index - 1;
	end procedure;
	function lhc_data_t_to_string (data_in : lhc_data_t; spacer_char : character)
		return string
	is
	begin
	return 		slv_to_hex(data_in.muon(0)) & spacer_char &
			slv_to_hex(data_in.muon(1)) & spacer_char &
			slv_to_hex(data_in.muon(2)) & spacer_char &
			slv_to_hex(data_in.muon(3)) & spacer_char &
			slv_to_hex(data_in.muon(4)) & spacer_char &
			slv_to_hex(data_in.muon(5)) & spacer_char &
			slv_to_hex(data_in.muon(6)) & spacer_char &
			slv_to_hex(data_in.muon(7)) & spacer_char &
			slv_to_hex(data_in.eg(0)) & spacer_char &
			slv_to_hex(data_in.eg(1)) & spacer_char &
			slv_to_hex(data_in.eg(2)) & spacer_char &
			slv_to_hex(data_in.eg(3)) & spacer_char &
			slv_to_hex(data_in.eg(4)) & spacer_char &
			slv_to_hex(data_in.eg(5)) & spacer_char &
			slv_to_hex(data_in.eg(6)) & spacer_char &
			slv_to_hex(data_in.eg(7)) & spacer_char &
			slv_to_hex(data_in.eg(8)) & spacer_char &
			slv_to_hex(data_in.eg(9)) & spacer_char &
			slv_to_hex(data_in.eg(10)) & spacer_char &
			slv_to_hex(data_in.eg(11)) & spacer_char &
			slv_to_hex(data_in.tau(0)) & spacer_char &
			slv_to_hex(data_in.tau(1)) & spacer_char &
			slv_to_hex(data_in.tau(2)) & spacer_char &
			slv_to_hex(data_in.tau(3)) & spacer_char &
			slv_to_hex(data_in.tau(4)) & spacer_char &
			slv_to_hex(data_in.tau(5)) & spacer_char &
			slv_to_hex(data_in.tau(6)) & spacer_char &
			slv_to_hex(data_in.tau(7)) & spacer_char &
			slv_to_hex(data_in.tau(8)) & spacer_char &
			slv_to_hex(data_in.tau(9)) & spacer_char &
			slv_to_hex(data_in.tau(10)) & spacer_char &
			slv_to_hex(data_in.tau(11)) & spacer_char &
			slv_to_hex(data_in.jet(0)) & spacer_char &
			slv_to_hex(data_in.jet(1)) & spacer_char &
			slv_to_hex(data_in.jet(2)) & spacer_char &
			slv_to_hex(data_in.jet(3)) & spacer_char &
			slv_to_hex(data_in.jet(4)) & spacer_char &
			slv_to_hex(data_in.jet(5)) & spacer_char &
			slv_to_hex(data_in.jet(6)) & spacer_char &
			slv_to_hex(data_in.jet(7)) & spacer_char &
			slv_to_hex(data_in.jet(8)) & spacer_char &
			slv_to_hex(data_in.jet(9)) & spacer_char &
			slv_to_hex(data_in.jet(10)) & spacer_char &
			slv_to_hex(data_in.jet(11)) & spacer_char &
			slv_to_hex(data_in.ett) & spacer_char &
			slv_to_hex(data_in.ht) & spacer_char &
			slv_to_hex(data_in.etm) & spacer_char &
			slv_to_hex(data_in.htm) & spacer_char &
			slv_to_hex(data_in.etmhf) & spacer_char &
			slv_to_hex(data_in.htmhf) & spacer_char &
			slv_to_hex(data_in.link_11_fr_0_data) & spacer_char &
			slv_to_hex(data_in.link_11_fr_1_data) & spacer_char &			
			slv_to_hex(data_in.link_11_fr_2_data) & spacer_char &
			slv_to_hex(data_in.link_11_fr_3_data) & spacer_char &
			slv_to_hex(data_in.link_11_fr_4_data) & spacer_char &
			slv_to_hex(data_in.link_11_fr_5_data) & spacer_char &						
			slv_to_hex(data_in.external_conditions) & spacer_char ;
	end function;


	function string_to_lhc_data_t (data_in : string)
		return lhc_data_t
	is
		variable hexstring : string(1 to data_in'length+1);
		variable ret_value : lhc_data_t := LHC_DATA_NULL;
		variable start_index : integer := 1;
		variable end_index : integer := 0;
	begin
		hexstring := data_in & ' '; -- make sure string ends on a space character
		for i in 0 to MUON_ARRAY_LENGTH-1 loop
			next_range(start_index, end_index, hexstring);
			ret_value.muon(i) := hex_to_slv("" & hexstring(start_index to end_index), MUON_DATA_WIDTH);
		end loop;
		for i in 0 to EG_ARRAY_LENGTH-1 loop
			next_range(start_index, end_index, hexstring);
			ret_value.eg(i) := hex_to_slv("" & hexstring(start_index to end_index), EG_DATA_WIDTH);
		end loop;
		for i in 0 to TAU_ARRAY_LENGTH-1 loop
			next_range(start_index, end_index, hexstring);
			ret_value.tau(i) := hex_to_slv("" & hexstring(start_index to end_index), TAU_DATA_WIDTH);
		end loop;
		for i in 0 to JET_ARRAY_LENGTH-1 loop
			next_range(start_index, end_index, hexstring);
			ret_value.jet(i) := hex_to_slv("" & hexstring(start_index to end_index), JET_DATA_WIDTH);
		end loop;
		next_range(start_index, end_index, hexstring);
		ret_value.ett := hex_to_slv("" & hexstring(start_index to end_index), ETT_DATA_WIDTH );
		next_range(start_index, end_index, hexstring);
		ret_value.ht := hex_to_slv("" & hexstring(start_index to end_index), HT_DATA_WIDTH );
		next_range(start_index, end_index, hexstring);
		ret_value.etm := hex_to_slv("" & hexstring(start_index to end_index), ETM_DATA_WIDTH );
		next_range(start_index, end_index, hexstring);
		ret_value.htm := hex_to_slv("" & hexstring(start_index to end_index), HTM_DATA_WIDTH );
		next_range(start_index, end_index, hexstring);
		ret_value.etmhf := hex_to_slv("" & hexstring(start_index to end_index), ETMHF_DATA_WIDTH);
		next_range(start_index, end_index, hexstring);
		ret_value.htmhf := hex_to_slv("" & hexstring(start_index to end_index), HTMHF_DATA_WIDTH);
		next_range(start_index, end_index, hexstring);
		ret_value.link_11_fr_0_data := hex_to_slv("" & hexstring(start_index to end_index), LINK_11_FR_0_WIDTH);
		next_range(start_index, end_index, hexstring);
		ret_value.link_11_fr_1_data := hex_to_slv("" & hexstring(start_index to end_index), LINK_11_FR_1_WIDTH);
		next_range(start_index, end_index, hexstring);
		ret_value.link_11_fr_2_data := hex_to_slv("" & hexstring(start_index to end_index), LINK_11_FR_2_WIDTH);
		next_range(start_index, end_index, hexstring);
		ret_value.link_11_fr_3_data := hex_to_slv("" & hexstring(start_index to end_index), LINK_11_FR_3_WIDTH);
		next_range(start_index, end_index, hexstring);
		ret_value.link_11_fr_4_data := hex_to_slv("" & hexstring(start_index to end_index), LINK_11_FR_4_WIDTH);
		next_range(start_index, end_index, hexstring);
		ret_value.link_11_fr_5_data := hex_to_slv("" & hexstring(start_index to end_index), LINK_11_FR_5_WIDTH);

		next_range(start_index, end_index, hexstring);
		ret_value.external_conditions := hex_to_slv("" & hexstring(start_index to end_index), EXTERNAL_CONDITIONS_DATA_WIDTH );
		return ret_value;
	end function;

end;
