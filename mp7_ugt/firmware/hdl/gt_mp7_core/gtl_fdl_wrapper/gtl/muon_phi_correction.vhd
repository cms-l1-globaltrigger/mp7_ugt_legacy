-- Desription:
-- Muon phi correction (instead of uGMT): phi values are measured at station 2, not at vertex, therefore correction is needed (for inv. mass conditions with muons). 
-- Correction is done for all muon conditions.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

entity muon_phi_correction is
    port(
        pt : in std_logic_vector(9-1 downto 0);
        phi : in std_logic_vector(10-1 downto 0);
        charge : in std_logic_vector(2-1 downto 0);
        phi_o : out std_logic_vector(10-1 downto 0);
        phi_temp_o : out integer
    );
end muon_phi_correction;

architecture rtl of muon_phi_correction is

-- HB 2016-08-17: LUT was generated center values of pt and the formular: 2.677/pt**1.014 (pt [GeV] center value of bin). LUT values in bins.
type phi_correction_lut_array is array (0 to 2**9-1) of natural range 0 to 425;
constant PHI_CORRECTION_LUT : phi_correction_lut_array := (
0,	425,	329,	196,	139,	108,	88,	74,	64,	57,	51,	46,	42,	38,	35,	33,
31,	29,	27,	26,	24,	23,	22,	21,	20,	19,	19,	18,	17,	17,	16,	15,
15,	15,	14,	14,	13,	13,	13,	12,	12,	12,	11,	11,	11,	11,	10,	10,
10,	10,	9,	9,	9,	9,	9,	9,	8,	8,	8,	8,	8,	8,	8,	7,
7,	7,	7,	7,	7,	7,	7,	7,	7,	6,	6,	6,	6,	6,	6,	6,
6,	6,	6,	6,	6,	6,	5,	5,	5,	5,	5,	5,	5,	5,	5,	5,
5,	5,	5,	5,	5,	5,	5,	5,	4,	4,	4,	4,	4,	4,	4,	4,
4,	4,	4,	4,	4,	4,	4,	4,	4,	4,	4,	4,	4,	4,	4,	4,
4,	4,	4,	4,	4,	3,	3,	3,	3,	3,	3,	3,	3,	3,	3,	3,
3,	3,	3,	3,	3,	3,	3,	3,	3,	3,	3,	3,	3,	3,	3,	3,
3,	3,	3,	3,	3,	3,	3,	3,	3,	3,	3,	3,	3,	3,	3,	3,
3,	3,	3,	3,	3,	3,	3,	3,	3,	2,	2,	2,	2,	2,	2,	2,
2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,
2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,
2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,
2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,
2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,
2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,
2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,
2,	2,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,
1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,
1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,
1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,
1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,
1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,
1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,
1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,
1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,
1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,
1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,
1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,
1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1
);

    signal phi_value : natural;
    signal phi_correction : natural;
    
begin

    phi_correction <= PHI_CORRECTION_LUT(CONV_INTEGER(pt));
    
    phi_value <= (CONV_INTEGER(phi));

    phi_correction_p: process(phi_value, phi_correction, charge)
        variable phi_temp : integer;
        variable phi_internal : natural;
    begin
-- HB 2016-08-17: MJ checks, whether valid pos. muon means adding phi_correction or subtracting
        if charge = "10" then -- valid pos. muon
            phi_temp := phi_value + phi_correction;
	    if phi_temp > 576 then
		phi_internal := phi_temp - 576;
	    else
		phi_internal := phi_temp;
	    end if;
        elsif charge = "11" then -- valid neg. muon
            phi_temp := phi_value - phi_correction;
	    if phi_temp < 0 then
		phi_internal := 576 - abs(phi_temp);
	    else
		phi_internal := phi_temp;
	    end if;
        else -- HB 2016-08-17: charge = not valid
	    phi_internal := phi_value;
        end if;       

        phi_o <= CONV_STD_LOGIC_VECTOR(phi_internal, 10);
	phi_temp_o <= phi_temp;
	
    end process phi_correction_p;
    
end architecture rtl;
