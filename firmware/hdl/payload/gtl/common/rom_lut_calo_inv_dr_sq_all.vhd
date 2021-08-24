
-- Description:
-- Wrapper for all 9 ROM segments for LUTs with inv_dr_sq values.

-- Version history:
-- HB 2021-08-24: updated for new ROMs structure.
-- HB 2020-05-15: bug fixed for rom_lut_calo_inv_dr_sq_9 address.
-- HB 2020-05-12: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library unisim;
use unisim.VComponents.all;

entity rom_lut_calo_inv_dr_sq_all is
    generic(
        dout_width : dout1_width := 26
    port(
    port(
        clk : in std_logic;
        deta : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        dphi : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        dout : out STD_LOGIC_VECTOR(dout_width-1 DOWNTO 0) := (others => '0')
    );
end rom_lut_calo_inv_dr_sq_all;

architecture rtl of rom_lut_calo_inv_dr_sq_all is

    constant addr_width : positive := 12;

    constant dout1_width : positive := 26;
    constant dout2_width : positive := 14;
    constant dout3_width : positive := 12;
    constant dout4_width : positive := 11;
    constant dout5_width : positive := 14;

    constant zero_vec : STD_LOGIC_VECTOR(dout_width-1 DOWNTO 0) := (others => '0');

    COMPONENT rom_lut_calo_inv_dr_sq_1
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout1_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_calo_inv_dr_sq_2
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout2_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_calo_inv_dr_sq_3
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout3_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_calo_inv_dr_sq_4
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout4_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_calo_inv_dr_sq_5
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout5_width-1 DOWNTO 0)
    );
    END COMPONENT;

    signal addr_lsb, addr_lsb_5 : STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);

    signal dout1, dout2, dout3, dout4, dout5 : STD_LOGIC_VECTOR(dout_width-1 DOWNTO 0);

begin

    addr_lsb <= deta(5 downto 0) & dphi(5 downto 0);
    addr_lsb_5 <= deta(7 downto 0) & dphi(3 downto 0);

    lut1_i : rom_lut_calo_inv_dr_sq_1
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout1(dout1_width-1 DOWNTO 0)
        );

    lut2_i : rom_lut_calo_inv_dr_sq_2
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout2(dout2_width-1 DOWNTO 0)
        );

    lut3_i : rom_lut_calo_inv_dr_sq_3
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout3(dout3_width-1 DOWNTO 0)
        );

    lut4_i : rom_lut_calo_inv_dr_sq_4
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout4(dout4_width-1 DOWNTO 0)
        );

    lut5_i : rom_lut_calo_inv_dr_sq_5
        port map (
            clka => clk,
            addra => addr_lsb_5,
            douta => dout5(dout5_width-1 DOWNTO 0)
        );

    dout <=
        dout1 when deta(7 downto 6) = "00" and dphi(6) = '0' else
        dout2 when deta(7 downto 6) = "01" and dphi(6) = '0' else
        dout3 when deta(7 downto 6) = "10" and dphi(6) = '0' else
        dout4 when deta(7 downto 6) = "11" and dphi(6) = '0' else
        dout5 when dphi(6 downto 4) = "100" else
        zero_vec;

end rtl;
