entity tcm is
    port
    (
	lhc_clk           : in std_logic;
	lhc_rst           : in std_logic;
	cntr_rst          : in std_logic;
	ec0		  : in std_logic;
	oc0		  : in std_logic;
	start		  : in std_logic;
	l1a_sync          : in std_logic;
	bcres_d           : in std_logic;
	bcres_d_FDL       : in std_logic;
	sw_reg_in         : in sw_reg_tcm_in_t;
	sw_reg_out        : out sw_reg_tcm_out_t;
	bx_nr             : out bx_nr_t;
	bx_nr_d_fdl       : out bx_nr_t;
	event_nr          : out event_nr_t;
	trigger_nr        : out trigger_nr_t;
	orbit_nr          : out orbit_nr_t;
	luminosity_seg_nr : out luminosity_seg_nr_t;
	start_lumisection : out std_logic
    );
end;
