
-- Description:
-- Get a new collection of calo data selected by one bit of calo data structure

-- Version history:
-- HB 2017-03-27: first design

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity calo_collection_builder is
    generic(nr_objects : natural; sel_bit_data_in : natural; sel_bit_inv : boolean
    );
    port(
        data_in : in calo_objects_array(0 to nr_objects-1);
        collection_out : out calo_objects_array(0 to nr_objects-1)
    );
end calo_collection_builder;

architecture rtl of calo_collection_builder is
begin
-- HB 2017-03-27: "sel_bit_data_in" is a bit in data_in, which is used for selection to get a new collection (e.g.: isolation bit in tau data structure, which is bit 25)
--                "sel_bit_inv" indicates whether value of "sel_bit_data_in" should be inverted for selection (e.g.: selection on "isolated" or "non-isolated")
    process(data_in)
        variable index : integer := 0;
        variable data_temp : calo_objects_array(0 to nr_objects-1) := (others => (others => '0'));
        begin
        index := 0;
        data_temp := (others => (others => '0'));
        for i in 0 to nr_objects-1 loop
	    if (data_in(i)(sel_bit_data_in) = '1' and not sel_bit_inv) or (data_in(i)(sel_bit_data_in) = '0' and sel_bit_inv) then
		data_temp(index) :=  data_in(i);
		index := index + 1;
	    end if;
        end loop;
        collection_out <= data_temp; 
    end process;
end architecture rtl;
