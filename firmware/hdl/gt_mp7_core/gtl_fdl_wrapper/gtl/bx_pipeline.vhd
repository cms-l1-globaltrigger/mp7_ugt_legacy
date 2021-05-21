-- Description:
-- Pipeline for +/-2 bx data.

-- Version-history:
-- HB 2021-05-21: first design.

library ieee;
use ieee.std_logic_1164.all;

use work.lhc_data_pkg.all;
use work.gtl_pkg.all;

entity bx_pipeline is
    port(
        clk : in std_logic;
        muon : in muon_objects_array(0 to NR_MUON_OBJECTS-1);
        eg : in calo_objects_array(0 to NR_EG_OBJECTS-1);
        jet : in calo_objects_array(0 to NR_JET_OBJECTS-1);
        tau : in calo_objects_array(0 to NR_TAU_OBJECTS-1);
        ett : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htt : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etm : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htm : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ettem : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etmhf : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htmhf : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt1hfp : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt1hfm : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt0hfp : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt0hfm : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymet : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymht : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymethf : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymhthf : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        towercount : in std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
        centrality : in std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
        external_conditions : in std_logic_vector(NR_EXTERNAL_CONDITIONS-1 downto 0);

        mu_o : out bx_muon_objects_array;
        eg_o : out bx_eg_objects_array;
        jet_o : out bx_jet_objects_array;
        tau_o : out bx_tau_objects_array;
        ett_o : out bx_esums_array;
        htt_o : out bx_esums_array;
        etm_o : out bx_esums_array;
        htm_o : out bx_esums_array;
        ettem_o : out bx_esums_array;
        etmhf_o : out bx_esums_array;
        htmhf_o : out bx_esums_array;
        mbt1hfp_o : out bx_esums_array;
        mbt1hfm_o : out bx_esums_array;
        mbt0hfp_o : out bx_esums_array;
        mbt0hfm_o : out bx_esums_array;
        asymet_o : out bx_esums_array;
        asymht_o : out bx_esums_array;
        asymethf_o : out bx_esums_array;
        asymhthf_o : out bx_esums_array;
        towercount_o : out bx_towercount_array;
        cent0_o : out bx_cent_array;
        cent1_o : out bx_cent_array;
        cent2_o : out bx_cent_array;
        cent3_o : out bx_cent_array;
        cent4_o : out bx_cent_array;
        cent5_o : out bx_cent_array;
        cent6_o : out bx_cent_array;
        cent7_o : out bx_cent_array;
        ext_cond_o : out bx_ext_cond_array
    );
end bx_pipeline;

architecture rtl of bx_pipeline is

    type gtl_data_record is record
        mu : muon_objects_array(0 to NR_MUON_OBJECTS-1);
        eg : calo_objects_array(0 to NR_EG_OBJECTS-1);
        jet : calo_objects_array(0 to NR_JET_OBJECTS-1);
        tau : calo_objects_array(0 to NR_TAU_OBJECTS-1);
        ett : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htt : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etm : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htm : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ettem : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etmhf : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htmhf : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt1hfp, mbt1hfm, mbt0hfp, mbt0hfm : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymet, asymht, asymethf, asymhthf : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        towercount : std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
        centrality : std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
        external_conditions : std_logic_vector(EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto 0);
    end record gtl_data_record;

    signal data_in : gtl_data_record;

    type array_gtl_data_record is array (0 to BX_PIPELINE_STAGES-1) of gtl_data_record;
    signal data_tmp : array_gtl_data_record;

    type cent_tmp_array is array (0 to BX_PIPELINE_STAGES-1) of std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
    signal centrality_tmp : cent_tmp_array;

begin

   data_in.mu <= muon;
   data_in.eg <= eg;
   data_in.jet <= jet;
   data_in.tau <= tau;
   data_in.ett <= ett;
   data_in.htt <= htt;
   data_in.etm <= etm;
   data_in.htm <= htm;
   data_in.ettem <= ettem;
   data_in.etmhf <= etmhf;
   data_in.htmhf <= htmhf;
   data_in.mbt1hfp <= mbt1hfp;
   data_in.mbt1hfm <= mbt1hfm;
   data_in.mbt0hfp <= mbt0hfp;
   data_in.mbt0hfm <= mbt0hfm;
   data_in.asymet <= asymet;
   data_in.asymht <= asymht;
   data_in.asymethf <= asymethf;
   data_in.asymhthf <= asymhthf;
   data_in.towercount <= towercount;
   data_in.centrality <= centrality;
   data_in.external_conditions <= external_conditions;

-- BX pipeline
    process(clk, data_in)
    begin
        data_tmp(0) <= data_in;
        if (clk'event and clk = '1') then
            for i in 0 to (BX_PIPELINE_STAGES-1)-1 loop
                data_tmp(i+1) <= data_tmp(i);
            end loop;
        end if;
    end process;

-- BX pipeline

    bx_l: for i in 0 to BX_PIPELINE_STAGES-1 generate
        mu_o(i) <= data_tmp(i).mu;
        eg_o(i) <= data_tmp(i).eg;
        jet_o(i) <= data_tmp(i).jet;
        tau_o(i) <= data_tmp(i).tau;
        ett_o(i) <= data_tmp(i).ett;
        ettem_o(i) <= data_tmp(i).ettem;
        etm_o(i) <= data_tmp(i).etm;
        htt_o(i) <= data_tmp(i).htt;
        htm_o(i) <= data_tmp(i).htm;
        etmhf_o(i) <= data_tmp(i).etmhf;
        htmhf_o(i) <= data_tmp(i).htmhf;
        towercount_o(i) <= data_tmp(i).towercount;
        mbt1hfp_o(i) <= data_tmp(i).mbt1hfp;
        mbt1hfm_o(i) <= data_tmp(i).mbt1hfm;
        mbt0hfp_o(i) <= data_tmp(i).mbt0hfp;
        mbt0hfm_o(i) <= data_tmp(i).mbt0hfm;
        asymet_o(i) <= data_tmp(i).asymet;
        asymht_o(i) <= data_tmp(i).asymht;
        asymethf_o(i) <= data_tmp(i).asymethf;
        asymhthf_o(i) <= data_tmp(i).asymhthf;

-- Additional delay for centrality and ext_cond (no comparators and conditions)

        centrality_pipe_i: entity work.delay_pipeline
            generic map(
                DATA_WIDTH => NR_CENTRALITY_BITS,
                STAGES => CENTRALITY_STAGES
            )
            port map(
                clk, data_tmp(i).centrality, centrality_tmp(i)
            );

        cent0_o(i) <= centrality_tmp(i)(0);
        cent1_o(i) <= centrality_tmp(i)(1);
        cent2_o(i) <= centrality_tmp(i)(2);
        cent3_o(i) <= centrality_tmp(i)(3);
        cent4_o(i) <= centrality_tmp(i)(4);
        cent5_o(i) <= centrality_tmp(i)(5);
        cent6_o(i) <= centrality_tmp(i)(6);
        cent7_o(i) <= centrality_tmp(i)(7);

        ext_cond_pipe_i: entity work.delay_pipeline
            generic map(
                DATA_WIDTH => EXTERNAL_CONDITIONS_DATA_WIDTH,
                STAGES => EXT_COND_STAGES
            )
            port map(
                clk, data_tmp(i).external_conditions, ext_cond_o(i)
            );

    end generate bx_l;

end architecture rtl;
