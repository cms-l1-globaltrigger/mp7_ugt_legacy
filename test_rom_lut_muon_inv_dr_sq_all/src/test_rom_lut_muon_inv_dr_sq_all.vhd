library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library unisim;
use unisim.VComponents.all;

entity test_rom_lut_muon_inv_dr_sq_all is
    port(
        clk40_in_p : in std_logic;
        clk40_in_n : in std_logic;
        deta : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        dphi : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        inv_dr_sq : out STD_LOGIC_VECTOR(27 DOWNTO 0)
    );
end test_rom_lut_muon_inv_dr_sq_all;

architecture rtl of test_rom_lut_muon_inv_dr_sq_all is

    COMPONENT rom_lut_muon_inv_dr_sq_all
        PORT (
            clk : in std_logic;
            deta : in STD_LOGIC_VECTOR(7 DOWNTO 0);
            dphi : in STD_LOGIC_VECTOR(7 DOWNTO 0);
            dout : out STD_LOGIC_VECTOR(27 DOWNTO 0)
        );
    END COMPONENT;

    signal clk40 : STD_LOGIC;

begin
    
    ibuf_clk40: IBUFGDS
        port map(
            i => clk40_in_p,
            ib => clk40_in_n,
            o => clk40
        );

    lut_all_i : rom_lut_muon_inv_dr_sq_all
        port map (
            clk => clk40,
            deta => deta,
            dphi => dphi,
            dout => inv_dr_sq
        );

end rtl;
