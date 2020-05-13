library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library unisim;
use unisim.VComponents.all;

entity rom_lut_calo_inv_dr_sq_all is
    port(
        clk : in std_logic;
        deta : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        dphi : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        dout : out STD_LOGIC_VECTOR(25 DOWNTO 0) := (others => '0')
    );
end rom_lut_calo_inv_dr_sq_all;

architecture rtl of rom_lut_calo_inv_dr_sq_all is

    COMPONENT rom_lut_calo_inv_dr_sq_1
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(25 DOWNTO 0)
    );
    END COMPONENT;
    
    COMPONENT rom_lut_calo_inv_dr_sq_2
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
    );
    END COMPONENT;
    
    COMPONENT rom_lut_calo_inv_dr_sq_3
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
    );
    END COMPONENT;
    
    COMPONENT rom_lut_calo_inv_dr_sq_4
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(10 DOWNTO 0)
    );
    END COMPONENT;
    
    COMPONENT rom_lut_calo_inv_dr_sq_5
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
    );
    END COMPONENT;
    
    COMPONENT rom_lut_calo_inv_dr_sq_6
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(12 DOWNTO 0)
    );
    END COMPONENT;
    
    COMPONENT rom_lut_calo_inv_dr_sq_7
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
    );
    END COMPONENT;
    
    COMPONENT rom_lut_calo_inv_dr_sq_8
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(10 DOWNTO 0)
    );
    END COMPONENT;
    
    COMPONENT rom_lut_calo_inv_dr_sq_9
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
    );
    END COMPONENT;
    
    signal addr_lsb : STD_LOGIC_VECTOR(11 DOWNTO 0);
    signal addr_msb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal dout1 : STD_LOGIC_VECTOR(25 DOWNTO 0);
    signal dout2 : STD_LOGIC_VECTOR(13 DOWNTO 0);
    signal dout3 : STD_LOGIC_VECTOR(11 DOWNTO 0);
    signal dout4 : STD_LOGIC_VECTOR(10 DOWNTO 0);
    signal dout5 : STD_LOGIC_VECTOR(13 DOWNTO 0);
    signal dout6 : STD_LOGIC_VECTOR(12 DOWNTO 0);
    signal dout7 : STD_LOGIC_VECTOR(11 DOWNTO 0);
    signal dout8 : STD_LOGIC_VECTOR(10 DOWNTO 0);
    signal dout9 : STD_LOGIC_VECTOR(11 DOWNTO 0);
    
begin
   
    addr_lsb <= deta(5 downto 0) & dphi(5 downto 0);
    addr_msb <= deta(7 downto 6) & dphi(7 downto 6);

    lut1_i : rom_lut_calo_inv_dr_sq_1
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout1
        );

    lut2_i : rom_lut_calo_inv_dr_sq_2
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout2
        );
        
    lut3_i : rom_lut_calo_inv_dr_sq_3
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout3
        );

    lut4_i : rom_lut_calo_inv_dr_sq_4
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout4
        );

    lut5_i : rom_lut_calo_inv_dr_sq_5
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout5
        );

    lut6_i : rom_lut_calo_inv_dr_sq_6
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout6
        );

    lut7_i : rom_lut_calo_inv_dr_sq_7
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout7
        );

    lut8_i : rom_lut_calo_inv_dr_sq_8
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout8
        );

     lut9_i : rom_lut_calo_inv_dr_sq_9
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout9
        );

--     out_mux_p: process
--     begin
--         case addr_msb is
--             when "0000" => dout <= dout1;
--             when "0001" => dout <= X"000"&dout5;
--             when "0010" => dout(11 DOWNTO 0) <= dout9;
--             when "0011" => dout(11 DOWNTO 0) <= X"000";
--             when "0100" => dout(13 DOWNTO 0) <= dout2;
--             when "0101" => dout(12 DOWNTO 0) <= dout6;
--             when "0110" => dout(11 DOWNTO 0) <= dout9;
--             when "0111" => dout(11 DOWNTO 0) <= X"000";
--             when "1000" => dout(11 DOWNTO 0) <= dout3;
--             when "1001" => dout(11 DOWNTO 0) <= dout7;
--             when "1010" => dout(11 DOWNTO 0) <= dout9;
--             when "1011" => dout(11 DOWNTO 0) <= X"000";            
--             when "1100" => dout(10 DOWNTO 0) <= dout4;
--             when "1101" => dout(10 DOWNTO 0) <= dout8;
--             when "1110" => dout(11 DOWNTO 0) <= dout9;
--             when "1111" => dout(11 DOWNTO 0) <= X"000";
--             when others => dout <= "00"&X"000000";           
--         end case;
--     end process;
    
    dout <= 
        dout1 when addr_msb = "0000" else 
        (X"000"&dout5) when addr_msb = "0001" else  
        ("00"&X"000"&dout9) when addr_msb = "0010" else 
        (X"000"&dout2) when addr_msb = "0100" else 
        ('0'&X"000"&dout6) when addr_msb = "0101" else 
        ("00"&X"000"&dout9) when addr_msb = "0110" else 
        ("00"&X"000"&dout3) when addr_msb = "1000" else 
        ("00"&X"000"&dout7) when addr_msb = "1001" else 
        ("00"&X"000"&dout9) when addr_msb = "1010" else 
        ("000"&X"000"&dout4) when addr_msb = "1100" else 
        ("000"&X"000"&dout8) when addr_msb = "1101" else 
        ("00"&X"000"&dout9) when addr_msb = "1110" else 
        "00"&X"000000";

end rtl;
