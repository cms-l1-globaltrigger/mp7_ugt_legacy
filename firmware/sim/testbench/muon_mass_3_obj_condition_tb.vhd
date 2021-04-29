
-- Description:
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity muon_mass_3_obj_condition_tb is
end muon_mass_3_obj_condition_tb;

architecture rtl of muon_mass_3_obj_condition_tb is

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal lhc_clk : std_logic;

    constant muon_object_low: natural := 0;
    constant muon_object_high: natural := 7;
    constant nr_muon_objects: natural := muon_object_high-muon_object_low+1;
    constant pt_threshold_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"003D";
    constant pt_threshold_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0029";
    constant pt_threshold_muon3: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0015";

    constant mass_upper_limit: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := X"002907FE9BCB0C80";
    constant mass_lower_limit: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := X"000000029E8D6080";

-- ************************************************************************************************

    signal muon, mu_bx_0: muon_objects_array(0 to nr_muon_objects-1) := (others => X"0000000000000000");

    signal mu_eta_integer_bx_0: diff_integer_inputs_array(0 to nr_muon_objects-1) := (others => 0);
    signal mu_phi_integer_bx_0: diff_integer_inputs_array(0 to nr_muon_objects-1) := (others => 0);

    signal diff_mu_mu_eta_integer_bx_0_bx_0 : dim2_max_eta_range_array(0 to nr_muon_objects-1, 0 to nr_muon_objects-1) := (others => (others => 0));
    signal diff_mu_mu_phi_integer_bx_0_bx_0 : dim2_max_phi_range_array(0 to nr_muon_objects-1, 0 to nr_muon_objects-1) := (others => (others => 0));
    signal diff_mu_mu_eta_vector_bx_0_bx_0 : deta_dphi_vector_array(0 to nr_muon_objects-1, 0 to nr_muon_objects-1) := (others => (others => (others => '0')));
    signal diff_mu_mu_phi_vector_bx_0_bx_0 : deta_dphi_vector_array(0 to nr_muon_objects-1, 0 to nr_muon_objects-1) := (others => (others => (others => '0')));

    signal mu_pt_vector_bx_0: diff_inputs_array(0 to nr_muon_objects-1) := (others => (others => '0'));
    signal mu_mu_cosh_deta_vector_bx_0_bx_0: muon_cosh_cos_vector_array(0 to nr_muon_objects-1, 0 to nr_muon_objects-1) := (others => (others => (others => '0')));
    signal mu_mu_cos_dphi_vector_bx_0_bx_0: muon_cosh_cos_vector_array(0 to nr_muon_objects-1, 0 to nr_muon_objects-1) := (others => (others => (others => '0')));
    signal mu_cos_phi_bx_0: muon_sin_cos_integer_array(0 to nr_muon_objects-1) := (others => 0);
    signal mu_sin_phi_bx_0: muon_sin_cos_integer_array(0 to nr_muon_objects-1) := (others => 0);

    signal ls_charcorr_double_bx_0_bx_0, os_charcorr_double_bx_0_bx_0 : muon_charcorr_double_array := (others => (others => '1'));

    signal condition_o: std_logic;

--*********************************Main Body of Code**********************************
begin

    -- Clock
    process
    begin
        lhc_clk  <=  '1';
        wait for LHC_CLK_PERIOD/2;
        lhc_clk  <=  '0';
        wait for LHC_CLK_PERIOD/2;
    end process;

    process
    begin
        wait for 5 * LHC_CLK_PERIOD;
        wait for 7 ns;
        muon <= (X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000");
        wait for LHC_CLK_PERIOD;
        muon <= (X"888938092cfa2127", X"46c4d00c3d49b09a", X"4511d0095379423a", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000");
        wait for LHC_CLK_PERIOD;
        muon <= (X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000");
        wait for LHC_CLK_PERIOD;
        muon <= (X"88e24808d6123849", X"882dd00c00720dba", X"038bb00cdb70e176", X"43469009d738d0d2", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000");
        wait for LHC_CLK_PERIOD;
        muon <= (X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000");
        wait for LHC_CLK_PERIOD;
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------
pipeline_p: process(lhc_clk, muon)
    begin
        if (lhc_clk'event and lhc_clk = '1') then
           mu_bx_0 <= muon;
        end if;
end process;

mu_l: for i in 0 to nr_muon_objects-1 generate
  mu_pt_vector_bx_0(i)(MU_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(MU_PT_LUT(CONV_INTEGER(mu_bx_0(i)(D_S_I_MU_V2.pt_high downto D_S_I_MU_V2.pt_low))), MU_PT_VECTOR_WIDTH);
  mu_eta_integer_bx_0(i) <= CONV_INTEGER(signed(mu_bx_0(i)(D_S_I_MU_V2.eta_high downto D_S_I_MU_V2.eta_low)));
  mu_phi_integer_bx_0(i) <= CONV_INTEGER(mu_bx_0(i)(D_S_I_MU_V2.phi_high downto D_S_I_MU_V2.phi_low));
  mu_cos_phi_bx_0(i) <= MUON_COS_PHI_LUT(CONV_INTEGER(mu_bx_0(i)(D_S_I_MU_V2.phi_high downto D_S_I_MU_V2.phi_low)));
  mu_sin_phi_bx_0(i) <= MUON_SIN_PHI_LUT(CONV_INTEGER(mu_bx_0(i)(D_S_I_MU_V2.phi_high downto D_S_I_MU_V2.phi_low)));
end generate;

diff_mu_mu_eta_bx_0_i: entity work.sub_eta_integer_obj_vs_obj
  generic map(nr_muon_objects, nr_muon_objects)
  port map(mu_eta_integer_bx_0, mu_eta_integer_bx_0, diff_mu_mu_eta_integer_bx_0_bx_0);
diff_mu_mu_phi_bx_0_i: entity work.sub_phi_integer_obj_vs_obj
  generic map(nr_muon_objects, nr_muon_objects, MUON_PHI_HALF_RANGE_BINS)
  port map(mu_phi_integer_bx_0, mu_phi_integer_bx_0, diff_mu_mu_phi_integer_bx_0_bx_0);

mu_mu_l1: for i in 0 to nr_muon_objects-1 generate
  mu_mu_l2: for j in 0 to nr_muon_objects-1 generate
    diff_mu_mu_eta_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(MU_MU_DIFF_ETA_LUT(diff_mu_mu_eta_integer_bx_0_bx_0(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
    diff_mu_mu_phi_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(MU_MU_DIFF_PHI_LUT(diff_mu_mu_phi_integer_bx_0_bx_0(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
  end generate mu_mu_l2;
end generate mu_mu_l1;

mu_mu_cosh_cos_l1: for i in 0 to nr_muon_objects-1 generate
  mu_mu_cosh_cos_l2: for j in 0 to nr_muon_objects-1 generate
    mu_mu_cosh_deta_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(MU_MU_COSH_DETA_LUT(diff_mu_mu_eta_integer_bx_0_bx_0(i,j)), MU_MU_COSH_COS_VECTOR_WIDTH);
    mu_mu_cos_dphi_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(MU_MU_COS_DPHI_LUT(diff_mu_mu_phi_integer_bx_0_bx_0(i,j)), MU_MU_COSH_COS_VECTOR_WIDTH);
  end generate mu_mu_cosh_cos_l2;
end generate mu_mu_cosh_cos_l1;

dut: entity work.muon_mass_3_obj_condition
     generic map(

        muon1_object_low => muon_object_low,
        muon1_object_high => muon_object_high,
        pt_threshold_muon1 => pt_threshold_muon1,
--
        muon2_object_low => muon_object_low,
        muon2_object_high => muon_object_high,
        pt_threshold_muon2 => pt_threshold_muon2,
--
        muon3_object_low => muon_object_low,
        muon3_object_high => muon_object_high,
        pt_threshold_muon3 => pt_threshold_muon3,
--
        mass_upper_limit_vector => mass_upper_limit,
        mass_lower_limit_vector => mass_lower_limit

    )
    port map(
        lhc_clk,
        mu_bx_0,
        mu_pt_vector_bx_0,
        mu_mu_cosh_deta_vector_bx_0_bx_0,
        mu_mu_cos_dphi_vector_bx_0_bx_0,
        condition_o => condition_o
    );

end rtl;

