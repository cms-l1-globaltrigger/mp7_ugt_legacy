entity gtl_module is
    port(
        lhc_clk : in std_logic;
        gtl_data : in gtl_data_record;
        algo_o : out std_logic_vector(NR_ALGOS-1 downto 0));
end gtl_module;
