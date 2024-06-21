-- top_decl

--

-- Defines constants for the whole device

--

-- Dave Newbold, June 2014

library IEEE;

use IEEE.STD_LOGIC_1164.all;

use work.mp7_brd_decl.all;

package mp7_top_decl is

	constant FW_REV: std_logic_vector(23 downto 0) := X"030202";

	

	type clock_ratio_array_t is array(2 downto 0) of integer;

	type mgt_kind_t is (no_mgt, gth_10g, gth_5g, gth_3g, gth_calo, gth_calotest, gth_10g_std_lat, gtx_10g_std_lat);

	type buf_kind_t is (no_buf, buf);

	type chk_kind_t is (no_chk, ologic_crc32, gct, f64, u_crc32);

	type fmt_kind_t is (no_fmt, tdr, s1, demux, m_pkt);

	type region_conf_t is

		record

			mgt_i_kind: mgt_kind_t;

			chk_i_kind: chk_kind_t;

			buf_i_kind: buf_kind_t;

			fmt_kind: fmt_kind_t;

			buf_o_kind: buf_kind_t;			

			chk_o_kind: chk_kind_t;

			mgt_o_kind: mgt_kind_t; -- Currently unused

			refclk: integer range 0 to N_REFCLK - 1;

			refclk_alt: integer range 0 to N_REFCLK - 1;

		end record;

	

	type region_conf_array_t is array(0 to N_REGION - 1) of region_conf_t;

end mp7_top_decl;

