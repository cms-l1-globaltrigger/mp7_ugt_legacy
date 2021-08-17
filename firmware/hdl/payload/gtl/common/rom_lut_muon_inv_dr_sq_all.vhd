
-- Description:
-- Wrapper for all 9 ROM segments for LUTs with muon inv_dr_sq values.

-- Version history:
-- HB 2020-05-18: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library unisim;
use unisim.VComponents.all;

entity rom_lut_muon_inv_dr_sq_all is
    port(
        clk : in std_logic;
        deta : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        dphi : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        dout : out STD_LOGIC_VECTOR(27 DOWNTO 0) := (others => '0')
    );
end rom_lut_muon_inv_dr_sq_all;

architecture rtl of rom_lut_muon_inv_dr_sq_all is

    constant addr_width : positive := 12;
    constant dout1_width : positive := 28;
    constant dout2_width : positive := 16;
    constant dout3_width : positive := 14;
    constant dout4_width : positive := 13;
    constant dout5_width : positive := 14;
    constant dout6_width : positive := 14;
    constant dout7_width : positive := 13;
    constant dout8_width : positive := 12;
    constant dout9_width : positive := 12;

    constant zero : positive := dout1_width;
    constant zero_vec : STD_LOGIC_VECTOR(zero-1 DOWNTO 0) := (others => '0');
    constant lead_zero_2 : STD_LOGIC_VECTOR(zero-dout2_width-1 downto 0) := (others => '0');
    constant lead_zero_3 : STD_LOGIC_VECTOR(zero-dout3_width-1 downto 0) := (others => '0');
    constant lead_zero_4 : STD_LOGIC_VECTOR(zero-dout4_width-1 downto 0) := (others => '0');
    constant lead_zero_5 : STD_LOGIC_VECTOR(zero-dout5_width-1 downto 0) := (others => '0');
    constant lead_zero_6 : STD_LOGIC_VECTOR(zero-dout6_width-1 downto 0) := (others => '0');
    constant lead_zero_7 : STD_LOGIC_VECTOR(zero-dout7_width-1 downto 0) := (others => '0');
    constant lead_zero_8 : STD_LOGIC_VECTOR(zero-dout8_width-1 downto 0) := (others => '0');
    constant lead_zero_9 : STD_LOGIC_VECTOR(zero-dout9_width-1 downto 0) := (others => '0');

    COMPONENT rom_lut_muon_inv_dr_sq_1
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout1_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_muon_inv_dr_sq_2
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout2_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_muon_inv_dr_sq_3
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout3_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_muon_inv_dr_sq_4
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout4_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_muon_inv_dr_sq_5
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout5_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_muon_inv_dr_sq_6
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout6_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_muon_inv_dr_sq_7
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout7_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_muon_inv_dr_sq_8
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout8_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_muon_inv_dr_sq_9
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout9_width-1 DOWNTO 0)
    );
    END COMPONENT;

    signal addr_lsb : STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
    signal addr_lsb_9 : STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
--     signal addr_msb : STD_LOGIC_VECTOR(3 DOWNTO 0);
--     signal addr_msb_9 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal dout1 : STD_LOGIC_VECTOR(dout1_width-1 DOWNTO 0);
    signal dout2 : STD_LOGIC_VECTOR(dout2_width-1 DOWNTO 0);
    signal dout3 : STD_LOGIC_VECTOR(dout3_width-1 DOWNTO 0);
    signal dout4 : STD_LOGIC_VECTOR(dout4_width-1 DOWNTO 0);
    signal dout5 : STD_LOGIC_VECTOR(dout5_width-1 DOWNTO 0);
    signal dout6 : STD_LOGIC_VECTOR(dout6_width-1 DOWNTO 0);
    signal dout7 : STD_LOGIC_VECTOR(dout7_width-1 DOWNTO 0);
    signal dout8 : STD_LOGIC_VECTOR(dout8_width-1 DOWNTO 0);
    signal dout9 : STD_LOGIC_VECTOR(dout9_width-1 DOWNTO 0);

begin

    addr_lsb <= deta(5 downto 0) & dphi(5 downto 0);
    addr_lsb_9 <= deta(7 downto 0) & dphi(3 downto 0);
--     addr_msb <= deta(7 downto 6) & dphi(7 downto 6);
--     addr_msb_9 <= dphi(7 downto 4);

    lut1_i : rom_lut_muon_inv_dr_sq_1
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout1
        );

    lut2_i : rom_lut_muon_inv_dr_sq_2
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout2
        );

    lut3_i : rom_lut_muon_inv_dr_sq_3
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout3
        );

    lut4_i : rom_lut_muon_inv_dr_sq_4
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout4
        );

    lut5_i : rom_lut_muon_inv_dr_sq_5
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout5
        );

    lut6_i : rom_lut_muon_inv_dr_sq_6
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout6
        );

    lut7_i : rom_lut_muon_inv_dr_sq_7
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout7
        );

    lut8_i : rom_lut_muon_inv_dr_sq_8
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout8
        );

    lut9_i : rom_lut_muon_inv_dr_sq_9
        port map (
            clka => clk,
            addra => addr_lsb_9,
            douta => dout9
        );

    dout <=
        dout1 when deta(7 downto 6) = "00" and dphi(7 downto 6) = "00" else
        (lead_zero_5&dout5) when deta(7 downto 6) = "00" and dphi(7 downto 6) = "01" else
        (lead_zero_9&dout9) when deta(7 downto 6) = "00" and dphi(7 downto 6) = "10" else
        (lead_zero_2&dout2) when deta(7 downto 6) = "01" and dphi(7 downto 6) = "00" else
        (lead_zero_6&dout6) when deta(7 downto 6) = "01" and dphi(7 downto 6) = "01" else
        (lead_zero_9&dout9) when deta(7 downto 6) = "01" and dphi(7 downto 6) = "10" else
        (lead_zero_3&dout3) when deta(7 downto 6) = "10" and dphi(7 downto 6) = "00" else
        (lead_zero_7&dout7) when deta(7 downto 6) = "10" and dphi(7 downto 6) = "01" else
        (lead_zero_9&dout9) when deta(7 downto 6) = "10" and dphi(7 downto 6) = "10" else
        (lead_zero_4&dout4) when deta(7 downto 6) = "11" and dphi(7 downto 6) = "00" else
        (lead_zero_8&dout8) when deta(7 downto 6) = "11" and dphi(7 downto 6) = "01" else
        (lead_zero_9&dout9) when dphi(7 downto 4) = "1000" else
        zero_vec;

end rtl;
