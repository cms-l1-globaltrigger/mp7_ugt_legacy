
-- Description:
-- Module for "anomaly detection trigger (ADT)" test.

-- Version history:
-- HB 2022-08-26: first design.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity adt is
    generic(thres: natural := 0);
    port(
        lhc_clk: in std_logic;
        mu: in muon_objects_array;
        eg: in eg_objects_array;
        jet: in jet_objects_array;
        tau: in tau_objects_array;
        adt_out: out std_logic
    );
end adt;

architecture rtl of adt is

    constant nr_obj = 4
    type mu_pt_array is array (0 to nr_obj-1) of std_logic_vector(MUON_PT_BITS-1 downto 0);
    type mu_eta_array is array (0 to nr_obj-1) of std_logic_vector(MUON_ETA_BITS-1 downto 0);
    type mu_phi_array is array (0 to nr_obj-1) of std_logic_vector(MUON_PHI_BITS-1 downto 0);
    type eg_pt_array is array (0 to nr_obj-1) of std_logic_vector(EG_PT_BITS-1 downto 0);
    type eg_eta_array is array (0 to nr_obj-1) of std_logic_vector(EG_ETA_BITS-1 downto 0);
    type eg_phi_array is array (0 to nr_obj-1) of std_logic_vector(EG_PHI_BITS-1 downto 0);
    type jet_pt_array is array (0 to nr_obj-1) of std_logic_vector(EG_PT_BITS-1 downto 0);
    type jet_eta_array is array (0 to nr_obj-1) of std_logic_vector(EG_ETA_BITS-1 downto 0);
    type jet_phi_array is array (0 to nr_obj-1) of std_logic_vector(EG_PHI_BITS-1 downto 0);
    type tau_pt_array is array (0 to nr_obj-1) of std_logic_vector(EG_PT_BITS-1 downto 0);
    type tau_eta_array is array (0 to nr_obj-1) of std_logic_vector(EG_ETA_BITS-1 downto 0);
    type tau_phi_array is array (0 to nr_obj-1) of std_logic_vector(EG_PHI_BITS-1 downto 0);
    signal mu_pt : mu_pt_array;
    signal mu_eta : mu_eta_array;
    signal mu_phi : mu_phi_array;
    signal eg_pt : eg_pt_array;
    signal eg_eta : eg_eta_array;
    signal eg_phi : eg_phi_array;
    signal jet_pt : jet_pt_array;
    signal jet_eta : jet_eta_array;
    signal jet_phi : jet_phi_array;
    signal tau_pt : tau_pt_array;
    signal tau_eta : tau_eta_array;
    signal tau_phi : tau_phi_array;
    signal adt_o : std_logic;

begin

    obj_l: for i in 0 to nr_obj-1 generate
        mu_pt(i) <= mu(i)(MUON_PT_HIGH downto MUON_PT_LOW)
        mu_eta(i) <= mu(i)(MUON_ETA_HIGH downto MUON_ETA_LOW)
        mu_phi(i) <= mu(i)(MUON_PHI_HIGH downto MUON_PHI_LOW)
        eg_pt(i) <= eg(i)(EG_PT_HIGH downto EG_PT_LOW)
        eg_eta(i) <= eg(i)(EG_ETA_HIGH downto EG_ETA_LOW)
        eg_phi(i) <= eg(i)(EG_PHI_HIGH downto EG_PHI_LOW)
        jet_pt(i) <= jet(i)(JET_PT_HIGH downto JET_PT_LOW)
        jet_eta(i) <= jet(i)(JET_ETA_HIGH downto JET_ETA_LOW)
        jet_phi(i) <= jet(i)(JET_PHI_HIGH downto JET_PHI_LOW)
        tau_pt(i) <= tau(i)(TAU_PT_HIGH downto TAU_PT_LOW)
        tau_eta(i) <= tau(i)(TAU_ETA_HIGH downto TAU_ETA_LOW)
        tau_phi(i) <= tau(i)(TAU_PHI_HIGH downto TAU_PHI_LOW)
    end generate obj_l;

-- Instantiation of top of hierarchy of ADT
-- Module adt_top created by HLS
-- HLS creates std_logic_vector types for inputs, not arrays, probably
-- Port map and generic map must be changed to the entity declaration of the HLS created file
    adt_top_i: entity work.adt_top
        generic map(thres)
        port map(
            lhc_clk,
            mu_pt(0),mu_pt(1),mu_pt(2),mu_pt(3),
            mu_eta(0),mu_eta(1),mu_eta(2),mu_eta(3),
            mu_phi(0),mu_phi(1),mu_phi(2),mu_phi(3),
            eg_pt(0),eg_pt(1),eg_pt(2),eg_pt(3),
            eg_eta(0),eg_eta(1),eg_eta(2),eg_eta(3),
            eg_phi(0),eg_phi(1),eg_phi(2),eg_phi(3),
            jet_pt(0),jet_pt(1),jet_pt(2),jet_pt(3),
            jet_eta(0),jet_eta(1),jet_eta(2),jet_eta(3),
            jet_phi(0),jet_phi(1),jet_phi(2),jet_phi(3),
            tau_pt(0),tau_pt(1),tau_pt(2),tau_pt(3),
            tau_eta(0),tau_eta(1),tau_eta(2),tau_eta(3),
            tau_phi(0),tau_phi(1),tau_phi(2),tau_phi(3),
            adt_o
        );

    algo_p: process(lhc_clk, adt_o)
        begin
        if (lhc_clk'event and lhc_clk = '1') then
            adt_out <= adt_o;
        end if;
    end process;

end architecture rtl;
