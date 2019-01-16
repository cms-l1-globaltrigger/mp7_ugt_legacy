--
-- HB 2016-06-17: added BGo "test-enable" not synchronized (!) occures at bx=~3300 (used to suppress counting algos caused by calibration trigger at bx=3490)
-- HB 2016-03-17: added outputs for synchronized BGos (with bc0)
-- HB 2016-03-14: added B-Go signals with TTC_BCMD_xxx
-- JW 2015-11-04: added bc0 to the sync stage
-- JW 2015-10-17: started development of bgo_sync to synchronize the bgos with 40MHz and avoid timing conflicts
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.mp7_ttc_decl.all;

entity bgo_sync is
    port(
        clk_payload: in std_logic;
        rst_payload: in std_logic;
        ttc_in:      in ttc_cmd_t;
        bc0_out:     out std_logic;
        ec0_out:     out std_logic;
        ec0_sync_bc0_out:     out std_logic;
        oc0_out:     out std_logic;
        oc0_sync_bc0_out:     out std_logic;
        resync_out:  out std_logic;
        resync_sync_bc0_out:  out std_logic;
        start_out:  out std_logic;
        start_sync_bc0_out:  out std_logic;
        test_en_out:  out std_logic
    );
end bgo_sync;

architecture rtl of bgo_sync is
    signal bc0_in            : std_logic;
    signal bc0_int           : std_logic;
    signal bc0_int_1         : std_logic;
    signal ec0_in            : std_logic;
    signal oc0_in            : std_logic;
    signal resync_in         : std_logic;
    signal start_in          : std_logic;
    signal test_en_in          : std_logic;
    signal resync_int           : std_logic;
    signal resync_rqst           : std_logic;
    signal oc0_int           : std_logic;
    signal oc0_rqst           : std_logic;
    signal ec0_int           : std_logic;
    signal ec0_rqst           : std_logic;
    signal start_int           : std_logic;
    signal start_rqst           : std_logic;
    signal test_en_int           : std_logic;
    signal test_en_rqst           : std_logic;
begin

    bc0_in     <= '1' when ttc_in = TTC_BCMD_BC0 else '0';
    ec0_in     <= '1' when ttc_in = TTC_BCMD_EC0 else '0';
    oc0_in     <= '1' when ttc_in = TTC_BCMD_OC0 else '0';
    resync_in  <= '1' when ttc_in = TTC_BCMD_RESYNC else '0';
    start_in   <= '1' when ttc_in = TTC_BCMD_START else '0';
-- HB 2016-06-17: BGo test-enable (used to prevent counting algos caused by calibration trigger)
-- definition in tags/mp7/stable/firmware/mp7fw_v2_2_0/../mp7_ttc/../mp7_ttc_decl.vhd !!! (email Greg Iles 2016-06-28)
    test_en_in <= '1' when ttc_in = TTC_BCMD_TEST_ENABLE else '0';

--     sync_bgos_p: process(clk_payload, rst_payload, bc0_in, ec0_in, oc0_in, resync_in, start_in)
    sync_bgos_p: process(clk_payload, rst_payload, bc0_in, ec0_in, oc0_in, resync_in, start_in, test_en_in)
        begin
        if (rst_payload = '1') then
            bc0_out <= '0';
            bc0_int <= '0';
            bc0_int_1 <= '0';
            ec0_out <= '0';
            ec0_int <= '0';
            ec0_sync_bc0_out <= '0';
            oc0_out <= '0';
            oc0_int <= '0';
            oc0_sync_bc0_out <= '0';
            resync_out <= '0';
            resync_int <= '0';
            resync_sync_bc0_out <= '0';
            start_out <= '0';
            start_int <= '0';
            start_sync_bc0_out <= '0';
            test_en_out <= '0';
        elsif (clk_payload'event and clk_payload = '1') then
            bc0_out <= bc0_in;
            bc0_int <= bc0_in;
            bc0_int_1 <= bc0_int; -- used for reset of xxx_rqst
            ec0_out <= ec0_in;
            ec0_int <= ec0_in;
            ec0_sync_bc0_out <= ec0_rqst and bc0_in; -- ec0 synchronized with bc0
            oc0_out <= oc0_in;
            oc0_int <= oc0_in;
            oc0_sync_bc0_out <= oc0_rqst and bc0_in; -- oc0 synchronized with bc0
            resync_out <= resync_in;
            resync_int <= resync_in;
            resync_sync_bc0_out <= resync_rqst and bc0_in; -- resync synchronized with bc0
            start_out <= start_in;
            start_int <= start_in;
            start_sync_bc0_out <= start_rqst and bc0_in; -- start synchronized with bc0
            test_en_out <= test_en_in;
        end if;
    end process;

-- HB 2016-03-29: "store" resync until next bc0
    resync_rqst_p: process(rst_payload, resync_int, bc0_int_1)
        begin
        if (bc0_int_1 = '1' and resync_int = '0') or rst_payload = '1' then
            resync_rqst <= '0';        
        elsif (resync_int'event and resync_int = '1') then
            resync_rqst <= '1';
        end if;
    end process;

-- HB 2016-03-17: "store" oc0 until next bc0
    oc0_rqst_p: process(rst_payload, oc0_int, bc0_int_1)
        begin
        if (bc0_int_1 = '1' and oc0_int = '0') or rst_payload = '1' then
            oc0_rqst <= '0';        
        elsif (oc0_int'event and oc0_int = '1') then
            oc0_rqst <= '1';
        end if;
    end process;

-- HB 2016-03-17: "store" start until next bc0
    start_rqst_p: process(rst_payload, start_int, bc0_int_1)
        begin
        if (bc0_int_1 = '1' and start_int = '0') or rst_payload = '1' then
            start_rqst <= '0';        
        elsif (start_int'event and start_int = '1') then
            start_rqst <= '1';
        end if;
    end process;

-- HB 2016-03-29: "store" ec0 until next bc0
    ec0_rqst_p: process(rst_payload, ec0_int, bc0_int_1)
        begin
        if (bc0_int_1 = '1' and ec0_int = '0') or rst_payload = '1' then
            ec0_rqst <= '0';        
        elsif (ec0_int'event and ec0_int = '1') then
            ec0_rqst <= '1';
        end if;
    end process;

end rtl;
