----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2019 12:17:34 PM
-- Design Name: 
-- Module Name: quad_cond_matrix - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.gtl_pkg.all;

entity quad_cond_matrix is
     generic(
        nr_templates: positive
    );
    Port ( clk : in STD_LOGIC;
           obj_slice_1_vs_templ_pipe : in object_slice_1_vs_template_array;
           obj_slice_2_vs_templ_pipe : in object_slice_2_vs_template_array;
           obj_slice_3_vs_templ_pipe : in object_slice_3_vs_template_array;
           obj_slice_4_vs_templ_pipe : in object_slice_4_vs_template_array;
           condition_o : out STD_LOGIC);
end quad_cond_matrix;

architecture Behavioral of quad_cond_matrix is
  signal obj_vs_templ_vec_sig1: std_logic_vector(4095 downto 0) := (others => '0');
  signal obj_vs_templ_vec_sig2: std_logic_vector(4095 downto 0) := (others => '0');
  signal obj_vs_templ_vec_sig3: std_logic_vector(4095 downto 0) := (others => '0');

  signal condition_and_or_sig1: std_logic;
  signal condition_and_or_sig2: std_logic;
  signal condition_and_or_sig3: std_logic;

  signal condition_and_or : std_logic;
begin

-- Condition type: "quad".
    matrix_quad_i: if nr_templates = 4 generate
	matrix_quad_p_1: process(obj_slice_1_vs_templ_pipe, obj_slice_2_vs_templ_pipe, obj_slice_3_vs_templ_pipe, obj_slice_4_vs_templ_pipe)
	    variable index : integer := 0;
	    variable index2 : integer := 0;
	    variable test_index : integer := 0;
	    variable obj_vs_templ_vec1  : std_logic_vector(4095 downto 0) := (others => '0');
	    variable obj_vs_templ_vec2  : std_logic_vector(4095 downto 0) := (others => '0');
	    variable obj_vs_templ_vec3  : std_logic_vector(4095 downto 0) := (others => '0');
	begin
	    index := 0;
	    index2 := 0;
	    test_index := 0;
	    obj_vs_templ_vec1  := (others => '0');
	    obj_vs_templ_vec2  := (others => '0');
	    obj_vs_templ_vec3  := (others => '0');
            for i in 0 to 11 loop
                for j in 0 to 11 loop
                    for k in 0 to 11 loop
			for l in 0 to 11 loop
			    if (j/=i and k/=i and k/=j and l/=i and l/=j and l/=k) then
				if((index mod 4096) = 0) then
				    if(index /= 0) then
					index2 := 0;
					test_index := test_index + 1;
				    end if;
				end if;
				if(test_index = 0) then
				    obj_vs_templ_vec1(index2) := obj_slice_1_vs_templ_pipe(i,1) and obj_slice_2_vs_templ_pipe(j,1) and obj_slice_3_vs_templ_pipe(k,1) and obj_slice_4_vs_templ_pipe(l,1);
				elsif(test_index = 1) then
				    obj_vs_templ_vec2(index2) := obj_slice_1_vs_templ_pipe(i,1) and obj_slice_2_vs_templ_pipe(j,1) and obj_slice_3_vs_templ_pipe(k,1) and obj_slice_4_vs_templ_pipe(l,1);
				elsif(test_index = 2) then
				    obj_vs_templ_vec3(index2) := obj_slice_1_vs_templ_pipe(i,1) and obj_slice_2_vs_templ_pipe(j,1) and obj_slice_3_vs_templ_pipe(k,1) and obj_slice_4_vs_templ_pipe(l,1);
				end if;
				index := index + 1;
				index2 := index2 +1;
			    end if;
			end loop;
		    end loop;
		end loop;
	    end loop;
	    obj_vs_templ_vec_sig1 <= obj_vs_templ_vec1;
	    obj_vs_templ_vec_sig2 <= obj_vs_templ_vec2;
	    obj_vs_templ_vec_sig3 <= obj_vs_templ_vec3;
	end process matrix_quad_p_1;

        matrix_quad_p_2: process(obj_vs_templ_vec_sig1, obj_vs_templ_vec_sig2, obj_vs_templ_vec_sig3)
            variable condition_and_or_tmp1, condition_and_or_tmp2, condition_and_or_tmp3 : std_logic := '0';
	begin
	    condition_and_or_tmp1  := '0';
	    condition_and_or_tmp2  := '0';
	    condition_and_or_tmp3  := '0';
	    for i in 0 to 4095 loop
		condition_and_or_tmp1 := condition_and_or_tmp1 or obj_vs_templ_vec_sig1(i);
		condition_and_or_tmp2 := condition_and_or_tmp2 or obj_vs_templ_vec_sig2(i);
		condition_and_or_tmp3 := condition_and_or_tmp3 or obj_vs_templ_vec_sig3(i);
	    end loop;
	    condition_and_or_sig1 <= condition_and_or_tmp1;
	    condition_and_or_sig2 <= condition_and_or_tmp2;
	    condition_and_or_sig3 <= condition_and_or_tmp3;
	end process matrix_quad_p_2;
        condition_and_or <= condition_and_or_sig1 or condition_and_or_sig2 or condition_and_or_sig3;
    end generate matrix_quad_i;

-- Pipeline stage for condition output.
    condition_o_pipeline_p: process(clk, condition_and_or)
	begin
		if (clk'event and clk = '1') then
		    condition_o <= condition_and_or;
	    end if;
    end process;

end Behavioral;
