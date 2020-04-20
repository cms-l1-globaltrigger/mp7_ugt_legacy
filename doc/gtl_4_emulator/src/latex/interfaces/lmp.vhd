entity lmp is
	generic
	(
        	NR_LANES: positive
	);
	port
	(
		demux_data_i		: in demux_lanes_data_objects_array_t(NR_LANES-1 downto 0);
		demux_data_valid_i	: in demux_lanes_data_objects_array_valid_t(NR_LANES-1 downto 0);
		lhc_data_o		: out lhc_data_t;
		lhc_data_valid_o	: out std_logic
	);
end;
