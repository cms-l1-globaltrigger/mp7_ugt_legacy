-- null_algo
--
-- Do-nothing top level algo for testing
--
-- Dave Newbold, July 2013

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.ipbus.all;
use work.ipbus_reg_types.all;
use work.mp7_data_types.all;
use work.top_decl.all;
-- use work.mp7_brd_decl.all;
use work.user_package.all;
use work.ipbus_decode_mp7_payload.all;
use work.gt_mp7_core_pkg.all;

entity mp7_payload is
	port(
		clk_ipb: in std_logic; -- ipbus signals
		rst_ipb: in std_logic;
		ipb_in: in ipb_wbus;
		ipb_out: out ipb_rbus;
		clk_payload : in  std_logic_vector(2 downto 0);
		rst_payload : in  std_logic_vector(2 downto 0);
		rst40: in std_logic;--reset 40MHz
		clk_p: in std_logic; -- data clock
		bunch_ctr: in std_logic_vector(11 downto 0); --bx counter
		bc0: in std_logic;
		user_sw: in  std_logic_vector(6 downto 0); -- sw1 on amc502
        fmc0_la_n: in  std_logic_vector(33 downto 0); -- inputs from HFMC
        fmc0_la_p: in  std_logic_vector(33 downto 0); -- inputs from HFMC
        board_mac_o: out std_logic_vector(47 downto 0); -- sets the mac address in infra
        board_ip_o: out std_logic_vector(31 downto 0); -- sets the ip address in infra
		d: in ldata(4 * N_REGION - 1 downto 0); -- data in
		q: out ldata(4 * N_REGION - 1 downto 0) -- data out
	);

end mp7_payload;

architecture rtl of mp7_payload is
    signal ipb_to_slaves: ipb_wbus_array(N_SLAVES-1 downto 0);
    signal ipb_from_slaves: ipb_rbus_array(N_SLAVES-1 downto 0);
    signal pulse   :  std_logic_vector(31 downto 0) := X"00000000";

    signal lhc_clk: std_logic; -- lhc_clk 40MHz
    signal lhc_rst: std_logic; -- lhc clk reset

    signal ext_cond_a: std_logic_vector(63 downto 0); -- async input signal from HFMC
    signal ext_cond_s: std_logic_vector(63 downto 0); -- synchronized input signal from HFMC
    signal ext_cond_d: std_logic_vector(63 downto 0); -- ext cond signal after delay block
    signal ext_cond_m: std_logic_vector(63 downto 0); -- output to 240MHz mux, real data or sim data

    signal ext_cond_valid: std_logic_vector(63 downto 0); -- valid signal for ext conds

    signal simmem_o: std_logic_vector(63 downto 0); -- simmem to logic

    signal board_mac  :  std_logic_vector(47 downto 0) := X"1EED19271A16";
    signal board_ip   :  std_logic_vector(31 downto 0) := X"C0A801DE";
    signal board_id   :  std_logic_vector(3 downto 0); -- slot number
    signal loc_id     :  std_logic_vector(2 downto 0); -- crate location

    signal module_info_status_regs  : ipb_reg_v(15 downto 0) := (others => (others => '0'));
    signal module_info_control_regs : ipb_reg_v(15 downto 0) := (others => (others => '0'));
    signal tcm_status_regs          : ipb_reg_v(15 downto 0) := (others => (others => '0'));
    signal tcm_control_regs         : ipb_reg_v(15 downto 0) := (others => (others => '0'));
    signal extconf_delay_control_regs : ipb_reg_v(63 downto 0) := (others => (others => '0'));

    signal sValid                           : std_logic;
    signal sStart                           : std_logic;
    signal sStrobe                          : std_logic;
    signal sDataMux                         : std_logic_vector(7 downto 0);
    signal sThresholdValid_lo               : std_logic_vector(15 DOWNTO 0); -- same as bx_counter
    signal sThresholdValid_hi               : std_logic_vector(15 DOWNTO 0); -- same as bx_counter

    signal bc_cnt                           : std_logic_vector (15 DOWNTO 0); --! Bunch crossing counter (16 bits)
    signal bx_length                        : std_logic_vector (15 DOWNTO 0); --! Length between two orbit signals
    signal bx_nr                            : std_logic_vector (11 DOWNTO 0); --! Bunch crossing counter (16 bits)
    signal event_nr                         : std_logic_vector (31 DOWNTO 0);
    signal trigger_nr                       : std_logic_vector (47 DOWNTO 0);
    signal orbit_nr                         : std_logic_vector (47 DOWNTO 0);
begin

	lhc_clk <= clk_payload(0); --40MHz
	lhc_rst <= rst_ipb or pulse(0); --rst40; -- High Active!! ipbus_reset OR user_reset

    fabric_i: entity work.ipbus_fabric_sel
    generic map(
        NSLV => N_SLAVES,
        SEL_WIDTH => IPBUS_SEL_WIDTH)
    port map(
      ipb_in => ipb_in,
      ipb_out => ipb_out,
      sel => ipbus_sel_mp7_payload(ipb_in.ipb_addr),
      ipb_to_slaves => ipb_to_slaves,
      ipb_from_slaves => ipb_from_slaves
    );

    tcm_i: entity work.tcm
    port map(
        lhc_clk            =>  lhc_clk,
        lhc_rst            =>  lhc_rst,
        bgos               =>  "0000",
        l1a_sync           =>  '0',
        bcres_d            =>  bc0,
        bcres_d_FDL        =>  '0',
        sw_reg_in          =>  tcm_control_regs,
        sw_reg_out         =>  tcm_status_regs,
        bx_nr              =>  bx_nr,
        bx_nr_d_fdl        =>  open,
        event_nr           =>  event_nr,
        trigger_nr         =>  trigger_nr,
        orbit_nr           =>  orbit_nr,
        luminosity_seg_nr  =>  open,
        start_lumisection  =>  open
    );


	user_i: entity work.user_switch
    port map(
        user_in => user_sw,
        id_out => board_id,
        loc_out => loc_id,
        mac_out => board_mac,
        ip_out => board_ip
        );

    module_info_status_regs(0) <= X"DEADBEEF";
    module_info_status_regs(1) <= X"0000000" & board_id;
    module_info_status_regs(2) <= X"0000000" & '0' & loc_id;
    module_info_status_regs(3) <= board_mac(31 downto 0);
    module_info_status_regs(4) <= X"0000" & board_mac(47 downto 32);
    module_info_status_regs(5) <= board_ip;

    --===========================================--
    module_info_i: entity work.ipbus_ctrlreg_v
    --===========================================--
    generic map(
        N_CTRL => 16,
        N_STAT => 16
    )
    port map
    (
        clk              => clk_ipb,
        reset            => rst_ipb,
        ipbus_in         => ipb_to_slaves(N_SLV_MINFO),
        ipbus_out        => ipb_from_slaves(N_SLV_MINFO),
        d                => module_info_status_regs,
        q                => module_info_control_regs,
        stb              => open
    );
    --===========================================--

        --===========================================--
    tcm_regs_i: entity work.ipbus_ctrlreg_v
    --===========================================--
    generic map(
        N_CTRL => 16,
        N_STAT => 16
    )
    port map
    (
        clk              => clk_ipb,
        reset            => rst_ipb,
        ipbus_in         => ipb_to_slaves(N_SLV_TCM),
        ipbus_out        => ipb_from_slaves(N_SLV_TCM),
        d                => tcm_status_regs,
        q                => tcm_control_regs,
        stb              => open
    );
    --===========================================--

    --===========================================--
    pulse_regs_inst: entity work.ipb_pulse_regs
    --===========================================--
    port map  -- IPBus slave which translates a pulse in the ipb clk domain in to the lhc clk domain
    (
        ipb_clk             => clk_ipb,
        ipb_reset           => rst_ipb,
        ipb_mosi_i          => ipb_to_slaves(N_SLV_PULSE_REGS),
        ipb_miso_o          => ipb_from_slaves(N_SLV_PULSE_REGS),
        lhc_clk             => lhc_clk,
        pulse_o             => pulse
    );
    --===========================================--


    delay_regs_i: entity work.ipbus_reg_v
    generic map(
        N_REG => 64
    )
    port map(
        clk => clk_ipb,
        reset => rst_ipb,
        ipbus_in => ipb_to_slaves(N_SLV_DEL),
        ipbus_out => ipb_from_slaves(N_SLV_DEL),
        q => extconf_delay_control_regs
    );

    data_i: entity work.data_sync
    port map
    (
        clk              => lhc_clk,
        rst              => lhc_rst,
        data_in          => ext_cond_a,
        data_out         => ext_cond_s
    );

    bc_cntr: process (lhc_clk, bc0)
    begin
        if (lhc_clk'event and lhc_clk = '1') then
            if ( bc0 = '1') then
                bx_length <= bc_cnt; -- "store" counter value for reading
                bc_cnt <= X"0000";   -- sync BCReset
            else
                bc_cnt <= std_logic_vector(unsigned(bc_cnt) + 1);  --count bx from 0 to 3563
            end if;
        end if;
    end process bc_cntr;

    -- memory
    spymem_i: for i in 0 to 1 generate
        spy_mem_i: entity work.ipb_dpmem_4096_32
        port map
        (
            ipbus_clk => clk_ipb,
            reset     => rst_ipb,
            ipbus_in  => ipb_to_slaves(N_SLV_SPYMEM(i)),
            ipbus_out =>  ipb_from_slaves(N_SLV_SPYMEM(i)),
            wea       => '0',
            ------------------
            clk_b     => lhc_clk,
            enb       => '1',
            web       => '1',
            addrb     => bx_nr,
            dinb      => ext_cond_d(32*i+31 downto 32*i),
            doutb     => open
        );
    end generate spymem_i;

        -- memory
    simmem_i: for i in 0 to 1 generate
        sim_mem_i: entity work.ipb_dpmem_4096_32
        port map
        (
            ipbus_clk => clk_ipb,
            reset     => rst_ipb,
            ipbus_in  => ipb_to_slaves(N_SLV_SIMMEM(i)),
            ipbus_out =>  ipb_from_slaves(N_SLV_SIMMEM(i)),
            wea       => '1',
            ------------------
            clk_b     => lhc_clk,
            enb       => '1',
            web       => '0',
            addrb     => bx_nr,
            dinb      => X"00000000", --& bunch_ctr(11 downto 0), --X"0C0FFEE0",
            doutb     => simmem_o(32*i+31 downto 32*i)
        );
    end generate simmem_i;

    delay_l: for i in 0 to 63 generate
        delay_extcond_i: entity work.delay_element
            generic map
            (
                MAX_DELAY  => 128
            )
            port map
            (
                lhc_clk     => lhc_clk,
                lhc_rst     => lhc_rst,
                data_i      => ext_cond_s(i),
                data_o      => ext_cond_d(i),
                valid_i     => '1',
                valid_o     => ext_cond_valid(i),
                delay       => extconf_delay_control_regs(i)(6 downto 0)
            );
    end generate delay_l;

    ext_cond_m  <= ext_cond_d when sDataMux = X"00" else
                   simmem_o   when sDataMux = X"01" else
                   (others => '0');


    ext_cond_mux_i: entity work.mux
    port map
    (   clk         => clk_p, -- clk 240 MHz
        res         => lhc_rst,
        lhc_clk     => lhc_clk, -- clk 40 MHz
        -- 6 inputs for 40MHz -> 240MHz
        in0         => (ext_cond_m(31 downto  0), sValid, sStart, sStrobe),     -- frame 0   -> E(31:0)
        in1         => (ext_cond_m(63 downto 32), sValid, sStart, sStrobe),     -- frame 1   -> E(63:31)
        in2         => ((others => '0'), sValid, sStart, sStrobe),              -- frame 2   -> free
        in3         => ((others => '0'), sValid, sStart, sStrobe),              -- frame 3   -> free
        in4         => ((others => '0'), sValid, sStart, sStrobe),              -- frame 4   -> free
        in5         => ((others => '0'), sValid, sStart, sStrobe),              -- frame 5   -> free
        mux_out     => q(0)
    );

    sThresholdValid_lo  <= module_info_control_regs(0)(15 downto 0);
    sThresholdValid_hi  <= module_info_control_regs(1)(15 downto 0);
    sStart              <= module_info_control_regs(2)(0);
    sStrobe             <= module_info_control_regs(3)(0);
    sDataMux            <= module_info_control_regs(4)(7 downto 0);

    -- set sValid process
    p_sValid: process (lhc_clk, bx_nr, sThresholdValid_lo, sThresholdValid_hi)
    begin
        if (lhc_clk'event and lhc_clk = '1') then -- shift range for one bx? because of possible 1bx delay
           if ((bx_nr >= sThresholdValid_lo) and (bx_nr <= sThresholdValid_hi)) then --define range
              sValid <= '0';
           else
              sValid <= '1';
           end if;
        end if;
    end process p_sValid;

--  map FMC0 inputs to extcond signals:
--  first VHDCI connector
    ext_cond_a(0)  <=  fmc0_la_p(0);
    ext_cond_a(1)  <=  fmc0_la_n(0);
    ext_cond_a(2)  <=  fmc0_la_p(3);
    ext_cond_a(3)  <=  fmc0_la_n(3);
    ext_cond_a(4)  <=  fmc0_la_p(8);
    ext_cond_a(5)  <=  fmc0_la_n(8);
    ext_cond_a(6)  <=  fmc0_la_p(12);
    ext_cond_a(7)  <=  fmc0_la_n(12);
    ext_cond_a(8)  <=  fmc0_la_p(16);
    ext_cond_a(9)  <=  fmc0_la_n(16);
    ext_cond_a(10) <=  fmc0_la_p(20);
    ext_cond_a(11) <=  fmc0_la_n(20);
    ext_cond_a(12) <=  fmc0_la_p(11);
    ext_cond_a(13) <=  fmc0_la_n(11);
    ext_cond_a(14) <=  fmc0_la_p(15);
    ext_cond_a(15) <=  fmc0_la_n(15);
    ext_cond_a(16) <=  fmc0_la_p(14);
    ext_cond_a(17) <=  fmc0_la_n(14);
    ext_cond_a(18) <=  fmc0_la_p(18);
    ext_cond_a(19) <=  fmc0_la_n(18);
    ext_cond_a(20) <=  fmc0_la_p(27);
    ext_cond_a(21) <=  fmc0_la_n(27);
    ext_cond_a(22) <=  fmc0_la_p(22);
    ext_cond_a(23) <=  fmc0_la_n(22);
    ext_cond_a(24) <=  fmc0_la_p(25);
    ext_cond_a(25) <=  fmc0_la_n(25);
    ext_cond_a(26) <=  fmc0_la_p(29);
    ext_cond_a(27) <=  fmc0_la_n(29);
    ext_cond_a(28) <=  fmc0_la_p(31);
    ext_cond_a(29) <=  fmc0_la_n(31);
    ext_cond_a(30) <=  fmc0_la_p(33);
    ext_cond_a(31) <=  fmc0_la_n(33);

--  second VHDCI connector
    ext_cond_a(32) <=  fmc0_la_n(32);
    ext_cond_a(33) <=  fmc0_la_p(32);
    ext_cond_a(34) <=  fmc0_la_n(30);
    ext_cond_a(35) <=  fmc0_la_p(30);
    ext_cond_a(36) <=  fmc0_la_n(28);
    ext_cond_a(37) <=  fmc0_la_p(28);
    ext_cond_a(38) <=  fmc0_la_n(24);
    ext_cond_a(39) <=  fmc0_la_p(24);
    ext_cond_a(40) <=  fmc0_la_n(21);
    ext_cond_a(41) <=  fmc0_la_p(21);
    ext_cond_a(42) <=  fmc0_la_n(19);
    ext_cond_a(43) <=  fmc0_la_p(19);
    ext_cond_a(44) <=  fmc0_la_n(26);
    ext_cond_a(45) <=  fmc0_la_p(26);
    ext_cond_a(46) <=  fmc0_la_n(23);
    ext_cond_a(47) <=  fmc0_la_p(23);
    ext_cond_a(48) <=  fmc0_la_n(17);
    ext_cond_a(49) <=  fmc0_la_p(17);
    ext_cond_a(50) <=  fmc0_la_n(13);
    ext_cond_a(51) <=  fmc0_la_p(13);
    ext_cond_a(52) <=  fmc0_la_n(9);
    ext_cond_a(53) <=  fmc0_la_p(9);
    ext_cond_a(54) <=  fmc0_la_n(5);
    ext_cond_a(55) <=  fmc0_la_p(5);
    ext_cond_a(56) <=  fmc0_la_n(1);
    ext_cond_a(57) <=  fmc0_la_p(1);
    ext_cond_a(58) <=  fmc0_la_n(7);
    ext_cond_a(59) <=  fmc0_la_p(7);
    ext_cond_a(60) <=  fmc0_la_n(4);
    ext_cond_a(61) <=  fmc0_la_p(4);
    ext_cond_a(62) <=  fmc0_la_n(2);
    ext_cond_a(63) <=  fmc0_la_p(2);

    board_mac_o <= board_mac;
    board_ip_o <= board_ip;

end rtl;

