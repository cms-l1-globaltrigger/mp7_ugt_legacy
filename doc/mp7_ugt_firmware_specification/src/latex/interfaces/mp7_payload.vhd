entity mp7_payload is
    port(
        clk: in std_logic; -- ipbus signals
        rst: in std_logic;
        ipb_in: in ipb_wbus;
        ipb_out: out ipb_rbus;
        clk_payload : in  std_logic_vector(2 downto 0);
        rst_payload : in  std_logic_vector(2 downto 0);
        clk_p: in std_logic; -- data clock
        rst_loc: in std_logic_vector(N_REGION - 1 downto 0);
        clken_loc: in std_logic_vector(N_REGION - 1 downto 0);
        ctrs: in ttc_stuff_array;
        l1a: in std_logic; -- L1A input
        bc0: out std_logic;
        d: in ldata(4 * N_REGION - 1 downto 0); -- data in
        q: out ldata(4 * N_REGION - 1 downto 0); -- data out
        gpio: out std_logic_vector(29 downto 0); -- IO to mezzanine connector
        gpio_en: out std_logic_vector(29 downto 0) -- IO to mezzanine connector (three-state enables)
    );
end mp7_payload;
