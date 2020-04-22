	type lhc_data_t is record 
		muon : muon_array_t;
		eg : eg_array_t;
		tau : tau_array_t;
		jet : jet_array_t;
		ett : std_logic_vector(ETT_DATA_WIDTH-1 downto 0);
		ht : std_logic_vector(HT_DATA_WIDTH-1 downto 0);
		etm : std_logic_vector(ETM_DATA_WIDTH-1 downto 0);
		htm : std_logic_vector(HTM_DATA_WIDTH-1 downto 0);
		etmhf : std_logic_vector(ETMHF_DATA_WIDTH-1 downto 0);
		htmhf : std_logic_vector(HTMHF_DATA_WIDTH-1 downto 0);		
		link_11_fr_0_data : std_logic_vector(LINK_11_FR_0_WIDTH-1 downto 0);
		link_11_fr_1_data : std_logic_vector(LINK_11_FR_1_WIDTH-1 downto 0);
		link_11_fr_2_data : std_logic_vector(LINK_11_FR_2_WIDTH-1 downto 0);
		link_11_fr_3_data : std_logic_vector(LINK_11_FR_3_WIDTH-1 downto 0);
		link_11_fr_4_data : std_logic_vector(LINK_11_FR_4_WIDTH-1 downto 0);
		link_11_fr_5_data : std_logic_vector(LINK_11_FR_5_WIDTH-1 downto 0);		
		external_conditions : std_logic_vector(EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto 0);
	end record; 
