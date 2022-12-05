-- Description:
-- Pipeline for +/-2 bx data.

-- Version-history:
-- HB 2021-06-10: updated for hadronic shower trigger (mus).
-- HB 2021-05-21: first design.

library ieee;
use ieee.std_logic_1164.all;

use work.lhc_data_pkg.all;
use work.gtl_pkg.all;

entity bx_pipeline is
    port(
        clk : in std_logic;
        gtl_data : in gtl_data_record;
        bx_data : out bx_data_record
    );
end bx_pipeline;

architecture rtl of bx_pipeline is

    type gtl_data_record_array is array (0 to BX_PIPELINE_STAGES-1) of gtl_data_record;
    signal data_tmp : gtl_data_record_array;

    type cent_tmp_array is array (0 to BX_PIPELINE_STAGES-1) of std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
    signal centrality_tmp : cent_tmp_array;

    type mus_tmp_array is array (0 to BX_PIPELINE_STAGES-1) of std_logic_vector(NR_MUS_BITS-1 downto 0);
    signal mus_tmp, mus_tmp_del : mus_tmp_array;

--     signal mus0, mus1, musoot0, musoot1, mus2 : mus_bit_array;

begin

-- BX pipeline
    process(clk, gtl_data)
    begin
        data_tmp(0) <= gtl_data;
        if (clk'event and clk = '1') then
            for i in 0 to (BX_PIPELINE_STAGES-1)-1 loop
                data_tmp(i+1) <= data_tmp(i);
            end loop;
        end if;
    end process;

    bx_l: for i in 0 to BX_PIPELINE_STAGES-1 generate
        bx_data.mu(i) <= data_tmp(i).mu;
        bx_data.eg(i) <= data_tmp(i).eg;
        bx_data.jet(i) <= data_tmp(i).jet;
        bx_data.tau(i) <= data_tmp(i).tau;
        bx_data.ett(i) <= data_tmp(i).ett;
        bx_data.ettem(i) <= data_tmp(i).ettem;
        bx_data.etm(i) <= data_tmp(i).etm;
        bx_data.htt(i) <= data_tmp(i).htt;
        bx_data.htm(i) <= data_tmp(i).htm;
        bx_data.etmhf(i) <= data_tmp(i).etmhf;
        bx_data.htmhf(i) <= data_tmp(i).htmhf;
        bx_data.towercount(i) <= data_tmp(i).towercount;
        bx_data.mbt1hfp(i) <= data_tmp(i).mbt1hfp;
        bx_data.mbt1hfm(i) <= data_tmp(i).mbt1hfm;
        bx_data.mbt0hfp(i) <= data_tmp(i).mbt0hfp;
        bx_data.mbt0hfm(i) <= data_tmp(i).mbt0hfm;
        bx_data.asymet(i) <= data_tmp(i).asymet;
        bx_data.asymht(i) <= data_tmp(i).asymht;
        bx_data.asymethf(i) <= data_tmp(i).asymethf;
        bx_data.asymhthf(i) <= data_tmp(i).asymhthf;

-- Additional delay for centrality and ext_cond (no comparators and conditions)

        centrality_pipe_i: entity work.delay_pipeline
            generic map(
                DATA_WIDTH => NR_CENTRALITY_BITS,
                STAGES => CENTRALITY_STAGES
            )
            port map(
                clk, data_tmp(i).centrality, centrality_tmp(i)
            );

        bx_data.cent0(i) <= centrality_tmp(i)(0);
        bx_data.cent1(i) <= centrality_tmp(i)(1);
        bx_data.cent2(i) <= centrality_tmp(i)(2);
        bx_data.cent3(i) <= centrality_tmp(i)(3);
        bx_data.cent4(i) <= centrality_tmp(i)(4);
        bx_data.cent5(i) <= centrality_tmp(i)(5);
        bx_data.cent6(i) <= centrality_tmp(i)(6);
        bx_data.cent7(i) <= centrality_tmp(i)(7);

        ext_cond_pipe_i: entity work.delay_pipeline
            generic map(
                DATA_WIDTH => EXTERNAL_CONDITIONS_DATA_WIDTH,
                STAGES => EXT_COND_STAGES
            )
            port map(
                clk, data_tmp(i).ext_cond, bx_data.ext_cond(i)
            );

        mus_tmp(i)(0) <= data_tmp(i).mu(MUON_OBJ_MUS0)(MUS_BIT);
        mus_tmp(i)(1) <= data_tmp(i).mu(MUON_OBJ_MUS1)(MUS_BIT);
        mus_tmp(i)(2) <= data_tmp(i).mu(MUON_OBJ_MUSOOT0)(MUS_BIT);
        mus_tmp(i)(3) <= data_tmp(i).mu(MUON_OBJ_MUSOOT1)(MUS_BIT);
        mus_tmp(i)(4) <= data_tmp(i).mu(MUON_OBJ_MUS2)(MUS_BIT);

        mus_pipe_i: entity work.delay_pipeline
            generic map(
                DATA_WIDTH => NR_MUS_BITS,
                STAGES => MUS_STAGES
            )
            port map(
                clk, mus_tmp(i), mus_tmp_del(i)
            );

        bx_data.mus0(i) <= mus_tmp_del(i)(0);
        bx_data.mus1(i) <= mus_tmp_del(i)(1);
        bx_data.musoot0(i) <= mus_tmp_del(i)(2);
        bx_data.musoot1(i) <= mus_tmp_del(i)(3);
        bx_data.mus2(i) <= mus_tmp_del(i)(4);

    end generate bx_l;

end architecture rtl;
