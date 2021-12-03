// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2700185 Thu Oct 24 18:45:48 MDT 2019
// Date        : Wed Sep 15 10:24:40 2021
// Host        : ugt-synth running 64-bit Ubuntu 16.04.7 LTS
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ rom_lut_muon_inv_dr_sq_1_sim_netlist.v
// Design      : rom_lut_muon_inv_dr_sq_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7vx690tffg1927-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "rom_lut_muon_inv_dr_sq_1,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2019.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clka,
    addra,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [12:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [27:0]douta;

  wire [12:0]addra;
  wire clka;
  wire [27:0]douta;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [27:0]NLW_U0_doutb_UNCONNECTED;
  wire [12:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [12:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [27:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "13" *) 
  (* C_ADDRB_WIDTH = "13" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "6" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     8.209599 mW" *) 
  (* C_FAMILY = "virtex7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "rom_lut_muon_inv_dr_sq_1.mem" *) 
  (* C_INIT_FILE_NAME = "rom_lut_muon_inv_dr_sq_1.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "8192" *) 
  (* C_READ_DEPTH_B = "8192" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "28" *) 
  (* C_READ_WIDTH_B = "28" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "1" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "8192" *) 
  (* C_WRITE_DEPTH_B = "8192" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "28" *) 
  (* C_WRITE_WIDTH_B = "28" *) 
  (* C_XDEVICEFAMILY = "virtex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_4 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[27:0]),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[12:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[12:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[27:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(1'b0),
        .web(1'b0));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_generic_cstr
   (douta,
    clka,
    addra);
  output [27:0]douta;
  input clka;
  input [12:0]addra;

  wire [12:0]addra;
  wire clka;
  wire [27:0]douta;
  wire [0:0]ena_array;
  wire \ramloop[1].ram.r_n_0 ;
  wire \ramloop[1].ram.r_n_1 ;
  wire \ramloop[1].ram.r_n_2 ;
  wire \ramloop[1].ram.r_n_3 ;
  wire \ramloop[1].ram.r_n_4 ;
  wire \ramloop[1].ram.r_n_5 ;
  wire \ramloop[1].ram.r_n_6 ;
  wire \ramloop[1].ram.r_n_7 ;
  wire \ramloop[1].ram.r_n_8 ;
  wire \ramloop[2].ram.r_n_0 ;
  wire \ramloop[2].ram.r_n_1 ;
  wire \ramloop[2].ram.r_n_2 ;
  wire \ramloop[2].ram.r_n_3 ;
  wire \ramloop[2].ram.r_n_4 ;
  wire \ramloop[2].ram.r_n_5 ;
  wire \ramloop[2].ram.r_n_6 ;
  wire \ramloop[2].ram.r_n_7 ;
  wire \ramloop[2].ram.r_n_8 ;
  wire \ramloop[3].ram.r_n_0 ;
  wire \ramloop[3].ram.r_n_1 ;
  wire \ramloop[3].ram.r_n_2 ;
  wire \ramloop[3].ram.r_n_3 ;
  wire \ramloop[3].ram.r_n_4 ;
  wire \ramloop[3].ram.r_n_5 ;
  wire \ramloop[3].ram.r_n_6 ;
  wire \ramloop[3].ram.r_n_7 ;
  wire \ramloop[3].ram.r_n_8 ;
  wire \ramloop[4].ram.r_n_0 ;
  wire \ramloop[4].ram.r_n_1 ;
  wire \ramloop[4].ram.r_n_2 ;
  wire \ramloop[4].ram.r_n_3 ;
  wire \ramloop[4].ram.r_n_4 ;
  wire \ramloop[4].ram.r_n_5 ;
  wire \ramloop[4].ram.r_n_6 ;
  wire \ramloop[4].ram.r_n_7 ;
  wire \ramloop[4].ram.r_n_8 ;
  wire \ramloop[5].ram.r_n_0 ;
  wire \ramloop[5].ram.r_n_1 ;
  wire \ramloop[5].ram.r_n_2 ;
  wire \ramloop[5].ram.r_n_3 ;
  wire \ramloop[5].ram.r_n_4 ;
  wire \ramloop[5].ram.r_n_5 ;
  wire \ramloop[5].ram.r_n_6 ;
  wire \ramloop[5].ram.r_n_7 ;
  wire \ramloop[6].ram.r_n_0 ;
  wire \ramloop[6].ram.r_n_1 ;
  wire \ramloop[6].ram.r_n_2 ;
  wire \ramloop[6].ram.r_n_3 ;
  wire \ramloop[6].ram.r_n_4 ;
  wire \ramloop[6].ram.r_n_5 ;
  wire \ramloop[6].ram.r_n_6 ;
  wire \ramloop[6].ram.r_n_7 ;

  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_mux \has_mux_a.A 
       (.DOADO({\ramloop[2].ram.r_n_0 ,\ramloop[2].ram.r_n_1 ,\ramloop[2].ram.r_n_2 ,\ramloop[2].ram.r_n_3 ,\ramloop[2].ram.r_n_4 ,\ramloop[2].ram.r_n_5 ,\ramloop[2].ram.r_n_6 ,\ramloop[2].ram.r_n_7 }),
        .DOPADOP(\ramloop[2].ram.r_n_8 ),
        .addra(addra[12]),
        .clka(clka),
        .douta(douta[27:2]),
        .\douta[10] (\ramloop[1].ram.r_n_8 ),
        .\douta[18] ({\ramloop[4].ram.r_n_0 ,\ramloop[4].ram.r_n_1 ,\ramloop[4].ram.r_n_2 ,\ramloop[4].ram.r_n_3 ,\ramloop[4].ram.r_n_4 ,\ramloop[4].ram.r_n_5 ,\ramloop[4].ram.r_n_6 ,\ramloop[4].ram.r_n_7 }),
        .\douta[18]_0 ({\ramloop[3].ram.r_n_0 ,\ramloop[3].ram.r_n_1 ,\ramloop[3].ram.r_n_2 ,\ramloop[3].ram.r_n_3 ,\ramloop[3].ram.r_n_4 ,\ramloop[3].ram.r_n_5 ,\ramloop[3].ram.r_n_6 ,\ramloop[3].ram.r_n_7 }),
        .\douta[19] (\ramloop[4].ram.r_n_8 ),
        .\douta[19]_0 (\ramloop[3].ram.r_n_8 ),
        .\douta[27] ({\ramloop[6].ram.r_n_0 ,\ramloop[6].ram.r_n_1 ,\ramloop[6].ram.r_n_2 ,\ramloop[6].ram.r_n_3 ,\ramloop[6].ram.r_n_4 ,\ramloop[6].ram.r_n_5 ,\ramloop[6].ram.r_n_6 ,\ramloop[6].ram.r_n_7 }),
        .\douta[27]_0 ({\ramloop[5].ram.r_n_0 ,\ramloop[5].ram.r_n_1 ,\ramloop[5].ram.r_n_2 ,\ramloop[5].ram.r_n_3 ,\ramloop[5].ram.r_n_4 ,\ramloop[5].ram.r_n_5 ,\ramloop[5].ram.r_n_6 ,\ramloop[5].ram.r_n_7 }),
        .\douta[9] ({\ramloop[1].ram.r_n_0 ,\ramloop[1].ram.r_n_1 ,\ramloop[1].ram.r_n_2 ,\ramloop[1].ram.r_n_3 ,\ramloop[1].ram.r_n_4 ,\ramloop[1].ram.r_n_5 ,\ramloop[1].ram.r_n_6 ,\ramloop[1].ram.r_n_7 }));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_width \ramloop[0].ram.r 
       (.addra(addra),
        .clka(clka),
        .douta(douta[1:0]));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_width__parameterized0 \ramloop[1].ram.r 
       (.\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ({\ramloop[1].ram.r_n_0 ,\ramloop[1].ram.r_n_1 ,\ramloop[1].ram.r_n_2 ,\ramloop[1].ram.r_n_3 ,\ramloop[1].ram.r_n_4 ,\ramloop[1].ram.r_n_5 ,\ramloop[1].ram.r_n_6 ,\ramloop[1].ram.r_n_7 }),
        .\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 (\ramloop[1].ram.r_n_8 ),
        .addra(addra[11:0]),
        .clka(clka),
        .ena_array(ena_array));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_width__parameterized1 \ramloop[2].ram.r 
       (.DOADO({\ramloop[2].ram.r_n_0 ,\ramloop[2].ram.r_n_1 ,\ramloop[2].ram.r_n_2 ,\ramloop[2].ram.r_n_3 ,\ramloop[2].ram.r_n_4 ,\ramloop[2].ram.r_n_5 ,\ramloop[2].ram.r_n_6 ,\ramloop[2].ram.r_n_7 }),
        .DOPADOP(\ramloop[2].ram.r_n_8 ),
        .addra(addra),
        .clka(clka));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_width__parameterized2 \ramloop[3].ram.r 
       (.\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ({\ramloop[3].ram.r_n_0 ,\ramloop[3].ram.r_n_1 ,\ramloop[3].ram.r_n_2 ,\ramloop[3].ram.r_n_3 ,\ramloop[3].ram.r_n_4 ,\ramloop[3].ram.r_n_5 ,\ramloop[3].ram.r_n_6 ,\ramloop[3].ram.r_n_7 }),
        .\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 (\ramloop[3].ram.r_n_8 ),
        .addra(addra[11:0]),
        .clka(clka),
        .ena_array(ena_array));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_width__parameterized3 \ramloop[4].ram.r 
       (.\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ({\ramloop[4].ram.r_n_0 ,\ramloop[4].ram.r_n_1 ,\ramloop[4].ram.r_n_2 ,\ramloop[4].ram.r_n_3 ,\ramloop[4].ram.r_n_4 ,\ramloop[4].ram.r_n_5 ,\ramloop[4].ram.r_n_6 ,\ramloop[4].ram.r_n_7 }),
        .\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 (\ramloop[4].ram.r_n_8 ),
        .addra(addra),
        .clka(clka));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_width__parameterized4 \ramloop[5].ram.r 
       (.\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ({\ramloop[5].ram.r_n_0 ,\ramloop[5].ram.r_n_1 ,\ramloop[5].ram.r_n_2 ,\ramloop[5].ram.r_n_3 ,\ramloop[5].ram.r_n_4 ,\ramloop[5].ram.r_n_5 ,\ramloop[5].ram.r_n_6 ,\ramloop[5].ram.r_n_7 }),
        .addra(addra),
        .clka(clka),
        .ena_array(ena_array));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_width__parameterized5 \ramloop[6].ram.r 
       (.\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ({\ramloop[6].ram.r_n_0 ,\ramloop[6].ram.r_n_1 ,\ramloop[6].ram.r_n_2 ,\ramloop[6].ram.r_n_3 ,\ramloop[6].ram.r_n_4 ,\ramloop[6].ram.r_n_5 ,\ramloop[6].ram.r_n_6 ,\ramloop[6].ram.r_n_7 }),
        .addra(addra),
        .clka(clka));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_mux
   (douta,
    addra,
    clka,
    DOADO,
    \douta[9] ,
    DOPADOP,
    \douta[10] ,
    \douta[18] ,
    \douta[18]_0 ,
    \douta[19] ,
    \douta[19]_0 ,
    \douta[27] ,
    \douta[27]_0 );
  output [25:0]douta;
  input [0:0]addra;
  input clka;
  input [7:0]DOADO;
  input [7:0]\douta[9] ;
  input [0:0]DOPADOP;
  input [0:0]\douta[10] ;
  input [7:0]\douta[18] ;
  input [7:0]\douta[18]_0 ;
  input [0:0]\douta[19] ;
  input [0:0]\douta[19]_0 ;
  input [7:0]\douta[27] ;
  input [7:0]\douta[27]_0 ;

  wire [7:0]DOADO;
  wire [0:0]DOPADOP;
  wire [0:0]addra;
  wire clka;
  wire [25:0]douta;
  wire [0:0]\douta[10] ;
  wire [7:0]\douta[18] ;
  wire [7:0]\douta[18]_0 ;
  wire [0:0]\douta[19] ;
  wire [0:0]\douta[19]_0 ;
  wire [7:0]\douta[27] ;
  wire [7:0]\douta[27]_0 ;
  wire [7:0]\douta[9] ;
  wire sel_pipe;

  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[10]_INST_0 
       (.I0(DOPADOP),
        .I1(sel_pipe),
        .I2(\douta[10] ),
        .O(douta[8]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[11]_INST_0 
       (.I0(\douta[18] [0]),
        .I1(sel_pipe),
        .I2(\douta[18]_0 [0]),
        .O(douta[9]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[12]_INST_0 
       (.I0(\douta[18] [1]),
        .I1(sel_pipe),
        .I2(\douta[18]_0 [1]),
        .O(douta[10]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[13]_INST_0 
       (.I0(\douta[18] [2]),
        .I1(sel_pipe),
        .I2(\douta[18]_0 [2]),
        .O(douta[11]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[14]_INST_0 
       (.I0(\douta[18] [3]),
        .I1(sel_pipe),
        .I2(\douta[18]_0 [3]),
        .O(douta[12]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[15]_INST_0 
       (.I0(\douta[18] [4]),
        .I1(sel_pipe),
        .I2(\douta[18]_0 [4]),
        .O(douta[13]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[16]_INST_0 
       (.I0(\douta[18] [5]),
        .I1(sel_pipe),
        .I2(\douta[18]_0 [5]),
        .O(douta[14]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[17]_INST_0 
       (.I0(\douta[18] [6]),
        .I1(sel_pipe),
        .I2(\douta[18]_0 [6]),
        .O(douta[15]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[18]_INST_0 
       (.I0(\douta[18] [7]),
        .I1(sel_pipe),
        .I2(\douta[18]_0 [7]),
        .O(douta[16]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[19]_INST_0 
       (.I0(\douta[19] ),
        .I1(sel_pipe),
        .I2(\douta[19]_0 ),
        .O(douta[17]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[20]_INST_0 
       (.I0(\douta[27] [0]),
        .I1(sel_pipe),
        .I2(\douta[27]_0 [0]),
        .O(douta[18]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[21]_INST_0 
       (.I0(\douta[27] [1]),
        .I1(sel_pipe),
        .I2(\douta[27]_0 [1]),
        .O(douta[19]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[22]_INST_0 
       (.I0(\douta[27] [2]),
        .I1(sel_pipe),
        .I2(\douta[27]_0 [2]),
        .O(douta[20]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[23]_INST_0 
       (.I0(\douta[27] [3]),
        .I1(sel_pipe),
        .I2(\douta[27]_0 [3]),
        .O(douta[21]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[24]_INST_0 
       (.I0(\douta[27] [4]),
        .I1(sel_pipe),
        .I2(\douta[27]_0 [4]),
        .O(douta[22]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[25]_INST_0 
       (.I0(\douta[27] [5]),
        .I1(sel_pipe),
        .I2(\douta[27]_0 [5]),
        .O(douta[23]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[26]_INST_0 
       (.I0(\douta[27] [6]),
        .I1(sel_pipe),
        .I2(\douta[27]_0 [6]),
        .O(douta[24]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[27]_INST_0 
       (.I0(\douta[27] [7]),
        .I1(sel_pipe),
        .I2(\douta[27]_0 [7]),
        .O(douta[25]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[2]_INST_0 
       (.I0(DOADO[0]),
        .I1(sel_pipe),
        .I2(\douta[9] [0]),
        .O(douta[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[3]_INST_0 
       (.I0(DOADO[1]),
        .I1(sel_pipe),
        .I2(\douta[9] [1]),
        .O(douta[1]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[4]_INST_0 
       (.I0(DOADO[2]),
        .I1(sel_pipe),
        .I2(\douta[9] [2]),
        .O(douta[2]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[5]_INST_0 
       (.I0(DOADO[3]),
        .I1(sel_pipe),
        .I2(\douta[9] [3]),
        .O(douta[3]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[6]_INST_0 
       (.I0(DOADO[4]),
        .I1(sel_pipe),
        .I2(\douta[9] [4]),
        .O(douta[4]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[7]_INST_0 
       (.I0(DOADO[5]),
        .I1(sel_pipe),
        .I2(\douta[9] [5]),
        .O(douta[5]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[8]_INST_0 
       (.I0(DOADO[6]),
        .I1(sel_pipe),
        .I2(\douta[9] [6]),
        .O(douta[6]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \douta[9]_INST_0 
       (.I0(DOADO[7]),
        .I1(sel_pipe),
        .I2(\douta[9] [7]),
        .O(douta[7]));
  FDRE #(
    .INIT(1'b0)) 
    \no_softecc_sel_reg.ce_pri.sel_pipe_reg[0] 
       (.C(clka),
        .CE(1'b1),
        .D(addra),
        .Q(sel_pipe),
        .R(1'b0));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_width
   (douta,
    clka,
    addra);
  output [1:0]douta;
  input clka;
  input [12:0]addra;

  wire [12:0]addra;
  wire clka;
  wire [1:0]douta;

  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_wrapper_init \prim_init.ram 
       (.addra(addra),
        .clka(clka),
        .douta(douta));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_width__parameterized0
   (\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ,
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ,
    clka,
    ena_array,
    addra);
  output [7:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ;
  output [0:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ;
  input clka;
  input [0:0]ena_array;
  input [11:0]addra;

  wire [7:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ;
  wire [0:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ;
  wire [11:0]addra;
  wire clka;
  wire [0:0]ena_array;

  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_wrapper_init__parameterized0 \prim_init.ram 
       (.\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 (\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ),
        .\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_1 (\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ),
        .addra(addra),
        .clka(clka),
        .ena_array(ena_array));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_width__parameterized1
   (DOADO,
    DOPADOP,
    clka,
    addra);
  output [7:0]DOADO;
  output [0:0]DOPADOP;
  input clka;
  input [12:0]addra;

  wire [7:0]DOADO;
  wire [0:0]DOPADOP;
  wire [12:0]addra;
  wire clka;

  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_wrapper_init__parameterized1 \prim_init.ram 
       (.DOADO(DOADO),
        .DOPADOP(DOPADOP),
        .addra(addra),
        .clka(clka));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_width__parameterized2
   (\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ,
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ,
    clka,
    ena_array,
    addra);
  output [7:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ;
  output [0:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ;
  input clka;
  input [0:0]ena_array;
  input [11:0]addra;

  wire [7:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ;
  wire [0:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ;
  wire [11:0]addra;
  wire clka;
  wire [0:0]ena_array;

  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_wrapper_init__parameterized2 \prim_init.ram 
       (.\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 (\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ),
        .\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_1 (\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ),
        .addra(addra),
        .clka(clka),
        .ena_array(ena_array));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_width__parameterized3
   (\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ,
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ,
    clka,
    addra);
  output [7:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ;
  output [0:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ;
  input clka;
  input [12:0]addra;

  wire [7:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ;
  wire [0:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ;
  wire [12:0]addra;
  wire clka;

  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_wrapper_init__parameterized3 \prim_init.ram 
       (.\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 (\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ),
        .\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_1 (\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ),
        .addra(addra),
        .clka(clka));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_width__parameterized4
   (\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ,
    ena_array,
    clka,
    addra);
  output [7:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ;
  output [0:0]ena_array;
  input clka;
  input [12:0]addra;

  wire [7:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ;
  wire [12:0]addra;
  wire clka;
  wire [0:0]ena_array;

  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_wrapper_init__parameterized4 \prim_init.ram 
       (.\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 (\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ),
        .addra(addra),
        .clka(clka),
        .ena_array(ena_array));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_width__parameterized5
   (\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ,
    clka,
    addra);
  output [7:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ;
  input clka;
  input [12:0]addra;

  wire [7:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ;
  wire [12:0]addra;
  wire clka;

  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_wrapper_init__parameterized5 \prim_init.ram 
       (.\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 (\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram ),
        .addra(addra),
        .clka(clka));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_wrapper_init
   (douta,
    clka,
    addra);
  output [1:0]douta;
  input clka;
  input [12:0]addra;

  wire [12:0]addra;
  wire clka;
  wire [1:0]douta;
  wire [15:2]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOADO_UNCONNECTED ;
  wire [15:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOBDO_UNCONNECTED ;
  wire [1:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOPADOP_UNCONNECTED ;
  wire [1:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOPBDOP_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  RAMB18E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'hA1DB27A60B1FAAF429A8D7C440854BC3DD38BC05F74466B784AC2142150AC168),
    .INIT_01(256'h2061AB00D7BE77C7B17214693D6299DE8DEFD560184B36CE58DC50BFE26973C4),
    .INIT_02(256'h951D6C147FA0183700F895C3DF9858AE3C9EC994E208DD12F5B85E9204C00F7D),
    .INIT_03(256'h5ACCB125D049F7084BCC831B0B2AB82087A89923CD0082B0A8F78FE57D0E2DE4),
    .INIT_04(256'hFC0BBDEA8A267960D0037EA09AB788A338400E3F56B33D08694D76BBE1B73B66),
    .INIT_05(256'hAE4AD3FD37A0C05BB8DA4A2A96D9DDD9B97A4DEE0F301BE7850380C8D9FCC2F6),
    .INIT_06(256'h839E6F119B9DD653C064E2EE96756F2472784618D06B600FE7A1E1F18728A888),
    .INIT_07(256'h08697045CD4AF1B3F9D3F3631C909279C9523218D1B4B29AA570EC86B8D77A95),
    .INIT_08(256'hC5E7E2FDC2A7AA7A5CE2304A35899EACB4488DD0D1286245DFBA3EAE1BB8EBC1),
    .INIT_09(256'hE80E81064393D0E6D3A20CC130EA16C0C97D1F6786AC415D4702AFB372ED60DA),
    .INIT_0A(256'hE78C01C6D183EB9857BB17D21F2A6AC32562E8DA2A6E4E97733130E514F23677),
    .INIT_0B(256'hC41C8F966DCE633C2D0061AB03B59BF85E2A4C6EF4838285E06D599FD9B9863D),
    .INIT_0C(256'hD90F982CD4956381B11A7CBF444E61EA8A0AB358CB55F0753DB8A3722754E88A),
    .INIT_0D(256'hC7BA7B41C0AF9D28F486C57A70C8DE7F1EE728A1670E996C2B61E71A4519AF21),
    .INIT_0E(256'hA859BCE17D40E4E96539A9412741F9160C5616234E0EEA621AD218A865D02FBC),
    .INIT_0F(256'hF84BD24932729EB5D71EEB7D698E67A7F24B19A75351F1ACBEE328BAD4B99978),
    .INIT_10(256'h424E2D0FAB5AFE3D50AFCDD774B7492532955CDE060F5DDDB00F3CE1F7E12762),
    .INIT_11(256'h5F2C8C492CB533667DD3D99EF7D8A81239B02EE22D65B4B1026038FA28DEB34E),
    .INIT_12(256'h4598B15743F8740D20F61FA01D4E342B62AE31FD8D6B4DA6F3E803FEB8A8EF48),
    .INIT_13(256'h9E71F972F72B6584C600756DD5137C506E265FA07E59CEEA7E11585BD67A95C7),
    .INIT_14(256'h6DA5E2FF7410969A7DC5DD2CC1E47BB06882CA230E597947178CE9C2981E56AE),
    .INIT_15(256'hA1A29C7C821459CDA6D012FBCBE25F6203D4811C4168DE62AE49AA775F9E4BEB),
    .INIT_16(256'h2D0B88E8CCF55468953ADE7A6F4C3669C5A4F4522794E8EC13D9C9DB662A7020),
    .INIT_17(256'hBC377A9261EAFACA0E26938DCC24660E486282F9DCA87E6F1C46BC0F466EBAA4),
    .INIT_18(256'hE419829A0CADBC7AB237875C0C5294F6078DA3721DA7B66FF095C58F3C2A8851),
    .INIT_19(256'h34C38B053681D9BDCCD78291449D08A4E1AF23CAA22F5B8B47F7AB6ADC480687),
    .INIT_1A(256'h1E63D1ED5702C8271757B79D9F00092EF33EE1173E5BD6F44DCAE0D96C0632CC),
    .INIT_1B(256'hDA486FE7F09547EF9BD97B61CB7C2305E4EAF74F9D4791E772E6FDFD99FAF711),
    .INIT_1C(256'h05E05F07AC52B17E6C0224284D4E9EAFBB202E11605A637A8091F08F72031F57),
    .INIT_1D(256'hAC96DE50DA048AE2A09F6567B8879F4633B9D62AF38C916177A880FD3C22D3B2),
    .INIT_1E(256'h8B5A4C4BB586989F31E675602DA3E10AF6DDDCBF675B3AD9E10D33BE6FBFA21F),
    .INIT_1F(256'h7F6830425AFBC928E642B5E2B0F2A1E80DFECD98796447283D1714164A1AEAE4),
    .INIT_20(256'h9E33CF239D496158E13EE91E26DA07950D282BADE4B8C6F457F09343A1FACAE1),
    .INIT_21(256'h4201E40E28418B806862E86B92ECD202981F10C15D41389E4CAA185FE65549F4),
    .INIT_22(256'hFC7777CD597936B951620F7165545E3CEB795652F6022CCA515C479FABE04188),
    .INIT_23(256'h9DDBF735E2AC0CCE4CDE46FF3A5D38C66D86C3BEED6CBD96C32A9AD2FADDC351),
    .INIT_24(256'hEC0B35CF41DDA11D21256E1FC69A0420A5214BBD601BF619DCC90BDFF8596395),
    .INIT_25(256'h9C23A5096236E0971A662767B90F8514C2170A098EA5C28E92E8E4A190E69AE3),
    .INIT_26(256'h285AF3101DB0C263A70F3FFDAF2ADDDD85CC2BB41CB52DBAA4A58E735EB62C0E),
    .INIT_27(256'hCC11041D0E767D64FE6D7F2C56E94C9767D7D1EB276FBD1D0DFBAD22E1C9B96D),
    .INIT_28(256'h6BA47F27A7B3653249D459623702E0FBCCCF31FF1AE73326B15BA3186E6843D1),
    .INIT_29(256'h47CA8A6B157111190008333B7939C57128C98AB62C514425B1A733CEAFE45736),
    .INIT_2A(256'hD0818FAFF9C305967E5DA67B5743016AC47A8EAABA29FA323E9D5A04C8E4E32B),
    .INIT_2B(256'h8967FC6C54BEF046406A4A7D7CADF1D032064F0153685AEB4FE9C2307CEB27E9),
    .INIT_2C(256'h896DE4392CEFBBA31E50DD4BB8CCAD63963F189CBFB35F58F2DCA9A6BCF42479),
    .INIT_2D(256'h8F1892486E285E32B3955485145A09F331E9AC6AA2F783D095871A4517D4D609),
    .INIT_2E(256'h5724E4E714BEAF07CEB2221A4A84BBD96255AC594BE0C12596D34DD92F669433),
    .INIT_2F(256'h8EAF05548519F61F3C95B72D64C5D5C3406D886CF6E117D107AB21C692A6E0D4),
    .INIT_30(256'h223924B6919C287D658F1D24D21A8C53DE4FE9371352EEF3D19061E2DA92FDFD),
    .INIT_31(256'h1C8876FF70D9C8CCCA80796C72DB1538B777886F9BDF6BD6607AC90003E48692),
    .INIT_32(256'h2C872F3DC4BEF6511F3CEC901C88DE22B61D86A9C5D450CCC991D588E540F927),
    .INIT_33(256'h2222DBF8BE6890D26A59B9B96DE96B218772DAA4BE174FBBBA326D5B4FF18722),
    .INIT_34(256'hE4E787CE6F7F52832DBCF2B419063AB28DE22C536914A16828CAEB41EAC8FF18),
    .INIT_35(256'h5ABE922B8BDFC45FA50AED0975741E5B03E922C0DA70BD99E343CF3C963ADFB2),
    .INIT_36(256'h3777157B02CDA1284499411FE63CECEC61B0538AE2A145CC27D11F28AD04F25B),
    .INIT_37(256'h6BFF92C0DB9A735128728275ED602A3DF949DB3DC0B357E3610CA0426326EB46),
    .INIT_38(256'hE5E72FE754BDCD9F78283D7BB598CAEB88B154DFF7FBF1299F5CA0997BAEBA28),
    .INIT_39(256'h7771A92C0851A145CC298473D7BB497CB054E2C385752E67EF5FA5CAF2D10A92),
    .INIT_3A(256'hCB16521A4BE15BD9CD7305F5F4AED826AA4E1C3DC3B37ECC30A11167BA5F33D2),
    .INIT_3B(256'h1B00E2C09A9C313F6835FB8D682817B8949DB0370214BEF830BBD72EE9942816),
    .INIT_3C(256'h1BFE4855DB9C354514501445A1CBA6664D21BF9C5314A9B8352845F65266BBCC),
    .INIT_3D(256'hC5A93714DB9D483670BD9A679449F61C9376C0DD5314BE1708EE0C2999F50BB6),
    .INIT_3E(256'hDB00E715315DA7080B95CD890D2DAF51934B15370E191915FDA129F5283F0A0C),
    .INIT_3F(256'h7716922FE2F9BE135708EF68451299F6FA376FE71485302CD5C2F67E0BBD99CB),
    .INIT_A(18'h00000),
    .INIT_B(18'h00000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(18'h00000),
    .SRVAL_B(18'h00000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram 
       (.ADDRARDADDR({addra,1'b0}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOADO_UNCONNECTED [15:2],douta}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOBDO_UNCONNECTED [15:0]),
        .DOPADOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOPADOP_UNCONNECTED [1:0]),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM18.ram_DOPBDOP_UNCONNECTED [1:0]),
        .ENARDEN(1'b1),
        .ENBWREN(1'b0),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .WEA({1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_wrapper_init__parameterized0
   (\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ,
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_1 ,
    clka,
    ena_array,
    addra);
  output [7:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ;
  output [0:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_1 ;
  input clka;
  input [0:0]ena_array;
  input [11:0]addra;

  wire [7:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ;
  wire [0:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_1 ;
  wire [11:0]addra;
  wire clka;
  wire [0:0]ena_array;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'hE1961750E690F65DE39633730D350C94E3B3326CFFD6DC36E3B3302CFCE78FFE),
    .INITP_01(256'h806B14498CD38E3C80C9E381C18B742CC0D4C875534AD54BC1D4148F2834B3DC),
    .INITP_02(256'h71CA73E3EE67275E3F990A34CB6907623F34F43F5C6791460E2A0BA8060F097B),
    .INITP_03(256'h1FE576D89A518F2F8FCA82F6D48D7EB3C01378EAB51D54FDE06585ED9BF4E6D3),
    .INITP_04(256'h9C0D90DEB1C9CDDDCFF2A0A2DC86AB6F618D40BA3DA53622301A9C8473FBC206),
    .INITP_05(256'h98FCD40E485EAD4E4E0364142E8866A267FCAC685825E69630E35850B491C8E0),
    .INITP_06(256'h931F9A9FA9CD20FD49C0CA80A053144D663E2AFE8967612AB3839672FA098E66),
    .INITP_07(256'hB4CE0E559E19817452700652032A90BB699FE2EC0D4996C3A4E032A3911C0DE5),
    .INITP_08(256'hAB4CF0712AAD6CEC55B38076AA6CA9CC52CC1865598734E3A931FC6A9C03C50B),
    .INITP_09(256'hAAAD99F07C3E1CA7AA5263FFC631FE50556DCFFE336CC098DA933FFCDA549F93),
    .INITP_0A(256'h955569B18F19954FAB4AD331E0F8CAB14AA52670FFF0769055524CF0003F8CB1),
    .INITP_0B(256'hD29554ADA4B554CFB52AAD6936DA56CF69555A493336969F5AAAB49998CC95B0),
    .INITP_0C(256'hDB4B55AAAAAAD98FB6D6AAAAAB56A66025AD5556A9555B3F4B5AAA95AD6AAD8F),
    .INITP_0D(256'hD9369694A52498F09269294A95A599C026D2D6AD54AD331F4DA5A95556A96C70),
    .INITP_0E(256'h999B26DB64998E1F33364924B64DCE1F666DB6D25B6CCE3F4C9B69296924CC7F),
    .INITP_0F(256'h98CCCD999998E1FE339933264CCE70FF666664D93267383FCCCC9B26D9B39C1F),
    .INIT_00(256'h80F9F7B472834735DBEA40F05A42F377E4D00ED4AAC107DD4051047644D96500),
    .INIT_01(256'hB16023FEF1FD266DD35C0AE1E212740DE1F652FAF7500E3CE516DF507D7C685D),
    .INIT_02(256'h48B8AD5F1011C298200C34AACA52845EE188F510D99053D7023236780E2F6C23),
    .INIT_03(256'hAE5C20FAECF92167CE5604D9DA096B03D7EB45ECE83FFB27CEFDC3315A553C2C),
    .INIT_04(256'h9FF8D162EBBD34C4F67618E4299450350E00278CB94D855E0483F84B635B3B89),
    .INIT_05(256'hA45214EEDFEB1257BC44F0C4C3F050E6B7C81FC3BA0DC4EA8BB270D4F2E1B897),
    .INIT_06(256'h88BA66C0098CA6C2683900B89C3EA268061F067FF04A1EBCDB0553127DA1C120),
    .INIT_07(256'h944002DACAD4FA3DA025CFA09DC723B5818EE07D6EB968851B36E63A4620DFA1),
    .INIT_08(256'h06037080708922A3896E0E535FA1EC97B241A421B23E57D34A1936562B0ECD22),
    .INIT_09(256'h7D27E7BEACB4D71878FBA16F678DE471373D881D0546E9F97F8A26655814B24D),
    .INIT_0A(256'h1FD9F7AA2BC0BA7A74376FF0C027BE8E33096F26C768674C5DF50EF4BF66E65D),
    .INIT_0B(256'h5F08C69A868BABE946C466302343941AD9D617A27EB24746BAAF335629C0349E),
    .INIT_0C(256'hD64102484741815F48BC55D21947BC2FC636ED41AE15EE44145FAD68CDB06048),
    .INIT_0D(256'h3BE29D6E575976B008821FE3D0E933B0665A8F0EDC00836ECBA70E0FBC286A9A),
    .INIT_0E(256'h34459C65D21E8C702829FB43CB82905DA27976BB0AC8E8860757E11FD32E2DF1),
    .INIT_0F(256'h11B56D3B201F376DC034CC896F80C135E0C8F1611E309E72B573B99416505745),
    .INIT_10(256'h3FECCF10DC69F4C839AC9A8F3555E0F4E8520F46660DD2D501CA7E43BAB39C88),
    .INIT_11(256'hE1813601E2DCF0206EDC6C2200083FA848223C9B46439B547B1737E8393B02A6),
    .INIT_12(256'hFF41A7557537D286A0756DFFB73945B9970753E535AA63D64A12AD094EEF4D91),
    .INIT_13(256'hAA47F8BF9C919FC9117801AF8382AE0B9D6972BF563C7A171D958C0E29EE70C3),
    .INIT_14(256'h7D4D2E42AE9C3DC982B2AEDAA79A45537E9777FDF60365BDAC707319EE79C757),
    .INIT_15(256'h6E07B4764E3D466AAB0B8B30FAEE0E5EE29D94CD4E1B3EBC9FF0BA09EB6FA6A3),
    .INIT_16(256'hC11971E697AC4EAE038C8F5E54D5544C42C04E686C81717F2C0572BD4726FF11),
    .INIT_17(256'h2CC16926F9E3E5023B930BA5654D60A216BFA4C730E3E845022AC5DF84C3AB4E),
    .INIT_18(256'hD3B17C4D427B1D50432B41C5FE3BCF115B055B97D2EB769AF173656CC1989F92),
    .INIT_19(256'hE57519D09D807C92C3128010C5A0A5D83AD2A2AFFE957AB44B46B092F8EF85CB),
    .INIT_1A(256'hBC1E5A87BE1BBEC961B3EC3EE00CFDF01DB7E2AD06AA197EA4E9404462174681),
    .INIT_1B(256'h9824C2733A170B194287EB7019E7DE0051D58F84B933F70D7A487E264BF83B21),
    .INIT_1C(256'h8468159E199D462F7742B3F2267A1621BD01F896B0F8EAC78EF4714BB90BDB3C),
    .INIT_1D(256'h46CD6511D1A79499B9F44EC763230A1C5ACA6E4A63BE6151943234A082E4D157),
    .INIT_1E(256'h3299B89F6011C6969CF2B500F3A93EC757F2911B5AFC875695443B39FD5C667C),
    .INIT_1F(256'hF07103A9623015122859A815A3552C2C57B23E01FE3AB9829A08D404A2B74F73),
    .INIT_20(256'hCEBA4C94A1834D11E4D9078361B48CF5F3808BF27EDFA9512A6E3DACD5E73A62),
    .INIT_21(256'h940F9C3BEDB4908490B7F95ADA7D4432498E03AB8BA602A490CD6255AF78B97D),
    .INIT_22(256'h5FD1DA88E501EAAE5E08BE8D83AC0FB08C95B6C896D82E2635C01C9D9A7ED34E),
    .INIT_23(256'h34AA30C8723105EFF10D4497099C522E3160BC490B063EB77783E197AD291579),
    .INIT_24(256'hEAE66A813795A779178DE52A6498CAF51312DA441F2B1682FF133EFCD1532B24),
    .INIT_25(256'hD040BF50F3A974554D5D87CD31B4592110286BDD815B6EC0532E55CEA0D1686E),
    .INIT_26(256'h75FE02899D468E7C1B7288650B7EBABA73D1BD11A033854721B2976DD88940D7),
    .INIT_27(256'h68D14AD46F1DDEB5A2A7C5FD52C5580DE7E81268EEA796BE25CFC0FD8B72B760),
    .INIT_28(256'h061FA8A5201DA6BF70BDAD417A59D8EF91AB24DCA95CBC86753B8D1EA9F1CA15),
    .INIT_29(256'hFD5FD153E68B4410F2EBFC276CCF50F2B7A0B1EC54EBB5B6F16A242673110554),
    .INIT_2A(256'hA04F61DBC420F5471C7556BFB0261A825276D758D62517760993D89EAFDF0A1A),
    .INIT_2B(256'h8DE954CE59F6A4673E2B2F4B81D443D180534B6AB32AD0A8B700864D5AB1564F),
    .INIT_2C(256'h479032308F53801A229B85E0A9DC715F980BA141CB1C0C6F16D272C9AFFFA184),
    .INIT_2D(256'h1B70D346C95C01B985665C6B92D330AB4500DFE30E64E6977B95E7754355AE53),
    .INIT_2E(256'h00E71DA684BA4B3985303AA05F72D172494450553ADF24E3F73A85B5AA497E3C),
    .INIT_2F(256'hA5F450BB35BF5A08C89D86869ECF1A8106AA6F58659BF9843E29499F31FF0F64),
    .INIT_30(256'hCC562741A55656A6453472FACBDD2AA647FCB55CDC19F85B223065A6D8E8C464),
    .INIT_31(256'h2D75C92C9E1FB05308D0AD9EA7C70054C351FDCABBD00C7101BFAECF25B37D84),
    .INIT_32(256'hADE05203F62BA46162A529EBE5126BE67813A723727F317125338400932EC34B),
    .INIT_33(256'hB2F3409B047C039B4501D0B4ADBCE3247EF5893C0F051F5FC75918042273F9B6),
    .INIT_34(256'hA7879EED7638356BDA815D6AA506871FC469007AC6D085D19ED86B455791EC60),
    .INIT_35(256'h366FB40767D654E1802FF1C7B0AFC5F2389814AC643B334F90F888432A3F84FC),
    .INIT_36(256'hB94B0E02277F08C2ACC5087301AC6E3E13E19E3AA6D5B3313CC5BA0EB39EC82C),
    .INIT_37(256'hB6E92771C92EA225B85B10D7B2A1A5BFF03B9F1EB9724A435E9D008B3E1A2257),
    .INIT_38(256'hE72FA24009FE1D65D66C25FEF1FA12325063613DEA5C8453BBAE1F024DF6F84F),
    .INIT_39(256'h366197DA2985EF67EF862EE7B391848BA9DE2A9011AD653C324982DE5F05D3C8),
    .INIT_3A(256'h2F325BA91DB572525373AF046DE566E967D62E636C3CC701DE5355DAD94B2B76),
    .INIT_3B(256'hB3D7064187DA3AA824AF4AF6B28163586281B7056BEB853B0DFE0E3E8E019751),
    .INIT_3C(256'h9355383C60A4078622D6A17F6B615C554525EC910A4E530E757F225716591D5F),
    .INIT_3D(256'h2F4C74A6E42E84E759D86604B27142251C27477CC92DAA40F0BCA5AACD0F70F2),
    .INIT_3E(256'h13993BF9D4C9D8003E91F567E466E968DB3C84ABA874045254025545CEEA96CF),
    .INIT_3F(256'hAAC0E00B4081CD268C008212B26222F4D8CED9F72B74D54CDC8547241C2F5FAB),
    .INIT_40(256'hB0FC62E07623E5BCA69FA6B8CFEA0314180AE39B2C8FBCAB56B5C379D4CE6698),
    .INIT_41(256'h25334C6E9BD31665C0289D21B25303C496796E7692C20660D158F6AD7B63637D),
    .INIT_42(256'h6980ADEF45AF2BB854FDAF6926E49D4DF07FF64E80875DFA5A7648CD00DD6390),
    .INIT_43(256'h9EA6B7D1F6255EA3F450B930B446E696562607F9FE153F7DCF36B244ECA97D68),
    .INIT_44(256'h3E231B25416DA9F247A50B76E14BAF09558DADB08F47D0274526C61F30F56B93),
    .INIT_45(256'h171721345076A7E22879D640B63ACC6B1AD7A482706F80A3D8207CEB6D03AE6C),
    .INIT_46(256'h2EE4AB82675B5B657995B5D8FA19303D3B26FAB148BA011AFFAD205548F76184),
    .INIT_47(256'h8F898B96ABC8EF215CA3F452BB31B343E18C4610E8D0C9D2EC1653A00071F488),
    .INIT_48(256'h39C45E04B7763F11EAC8A98A6A4518E0993FCF459BCFDCBF72F440542ECB2949),
    .INIT_49(256'h07FAF6F9051A386092CD1465C1299D1EAB46EDA367391A0A0A193766A4F250BD),
    .INIT_4A(256'h60C231AB2FBD54F1943AE1882CCA60EA65CE215C7A7851048DE7120ACD59AECA),
    .INIT_4B(256'h7F6C605C606D82A1C8F9357ACA258BFC7A049A3CECA9744D33272A3B5A87C10A),
    .INIT_4C(256'hA0DC2374CE2F970475E85BCD3AA1FF5195C8E6ECD8A552DB3D7683621190DCF5),
    .INIT_4D(256'hF7DDCABFBCC0CDE200275791D5237CDF4DC64BDC7922D79967432A1F202E486E),
    .INIT_4E(256'hF913355F91C906478ACE12538FC4F011232513EBAA4DD2357690834DEB5DA2B9),
    .INIT_4F(256'h6F4F35231814192539567CABE32470C5248E03820DA243EFA76A3913F8E9E4EA),
    .INIT_50(256'h6C64646A77899EB7D0EA0217262F2E2107DDA04FE663C4072A2A06BC4BB2F005),
    .INIT_51(256'hE8C1A188756A66697488A3C7F42968AF015CC02FA82BB850F29E5516E1B6947B),
    .INIT_52(256'hF6CFAF957F6E5F5245382815FCDBB17D3AE9860F82DE20464E36FEA32582BBCE),
    .INIT_53(256'h61340DEDD3C0B4AFB1BBCDE60731639EE22E84E34BBC37BB48DF7F28DA955823),
    .INIT_54(256'h975416DDA8764516E6B581490BC5771DB742BC2478B6DBE7D8AC61F76DC2F506),
    .INIT_55(256'hDBA87B53321804F7F0F1F9081F3D6392C8074E9DF555BE30A92CB649E48630E0),
    .INIT_56(256'h4FF19842EF9F5001B15F0AB050E979FE77E33E88BFE2EFE3BF8025AE1A6796A5),
    .INIT_57(256'h551CE9BB937156403129272D394C678AB3E51E5EA7F74FAF1685FB79FD891AB2),
    .INIT_58(256'h1DA633C254E87C10A233BF47C843B41B77C50534525C5232FBAB43C0226893A1),
    .INIT_59(256'hD0925824F5CCA98C7463595557607086A4C8F42660A1E9388DEA4DB7269C1798),
    .INIT_5A(256'hFF71E65DD64FC942B92E9E0A70CE2470B1E50B22291EFFCD8526B1237DBDE4F1),
    .INIT_5B(256'h4D08C88E5929FED9BAA18D8078777C8899B2D0F621538CCB105BAC035FC02691),
    .INIT_5C(256'hF652B01172D43595F34EA5F84489C5F8213E4D4E4021F0AD56EA69D2245F838F),
    .INIT_5D(256'hCA803AFABE87562902E1C5AE9D928D8E94A1B3CCEA0E38689DD7175CA6F4469C),
    .INIT_5E(256'h004891DC2873BE074E92D20C416F94B1C3CBC5B3926120CE69F166C612486873),
    .INIT_5F(256'h48F8AD6725E7AF7B4D23FFE0C6B2A39995969DA9BAD1ED0E345F8FC3FB3877BA),
    .INIT_60(256'h1C5188BFF62D6397C8F72146657E8E969588704C1AD98929B836A1FA3F718F99),
    .INIT_61(256'hC87322D58D4A0AD09A693D15F3D5BDA99B918C8D929CABBED6F213375F8AB8E9),
    .INIT_62(256'h4B6E93B7DCFF2242607B91A2AEB3B0A692744A16D48528BB3FB31668A7D5F1FA),
    .INIT_63(256'h48EE9846F8AE6827EAB27E4E23FDDBBEA6928278716F71788290A2B8D0EB0929),
    .INIT_64(256'h8B9EB1C4D7E9FA08141C201F190CF8DCB789500DBD61F780FA65C00B46718A92),
    .INIT_65(256'hCA6B10B86414C8803DFDC28A5729FED8B6987F69584A403A38393D444E5B6979),
    .INIT_66(256'hDBDFE2E6E8EAEAE7E2DACDBBA487633703C67F2ED169F473E4479BE1173E565E),
    .INIT_67(256'h4EE9892CD27D2BDC924C09CA905926F7CCA48161452D1806F7ECE3DDD9D7D7D9),
    .INIT_68(256'h3C31251A0D00F0DEC9B195744D21EEB47227D3760E9B1C91FA55A4E4163B5058),
    .INIT_69(256'hD26904A143E78F3BEA9D540ECC8D521AE7B689603A17F7DAC0A9948170615448),
    .INIT_6A(256'hAC937A60462A0CEBC8A1774713D9985102AB4BE270F36BD8398ED6124162767D),
    .INIT_6B(256'h59EB8019B554F79C45F2A2550BC5824307CE98653609DFB792704F3114F8DEC4),
    .INIT_6C(256'h2A04DFB890673C0EDDA97135F3AC5F0CB14FE471F46EDE439DEC306793B2C5CB),
    .INIT_6D(256'hE06EFF9329C36000A349F39F4F02B7702CEBAC713802CE9C6D4015EBC29B754F),
    .INIT_6E(256'hB6855320ECB77F4508C7833AED9A42E37D119C1F9A0B73D2266FAEE10A27383E),
    .INIT_6F(256'h69F37F0EA035CC6704A447ED9642F1A2560DC7834102C58A511AE4AF7C4A18E7),
    .INIT_70(256'h5014D7995918D58F46FAAB57FEA13DD465EE71EB5EC82980CF134D7DA3BECED3),
    .INIT_71(256'hF479018B19A83BD068029F3FE2872FD98635E79B5109C37F3DFCBD7E4104C88C),
    .INIT_72(256'hF7B06820D68A3CEB9841E78926BE51DF66E760D33EA1FB4D96D60C395C758489),
    .INIT_73(256'h8102850B931EAC3CCE63FA9431D07114BA620CB96717C97C31E79F5710C9833D),
    .INIT_74(256'hAA5908B5610BB359FB9B37CF62F17B007FF769D53995EA367AB6E912334A595D),
    .INIT_75(256'h0F8B0B8C10961FAA37C759ED841CB754F39438DC832CD5812DDB8A39E9994AFA),
    .INIT_76(256'h690FB559FB9C3AD670069928B339BB37AE1F8AEF4CA3F23979B1E007263C494D),
    .INIT_77(256'h9E1792108F11951BA32EBA49DA6D029931CC6806A647E98D31D77D24CB731BC2),
    .INIT_78(256'h33D16E09A33BD064F5820D9316940E83F35DC11F77C8125591C5F21633475357),
    .INIT_79(256'h2FA41C95108E0D8F12981FA934C150E174089E35CE68039F3DDA7918B757F695),
    .INIT_7A(256'h099E33C657E77500890E91108B0275E34CAF0D66B8044A88C0F11B3D586B767A),
    .INIT_7B(256'hC234A71C940D88058405870C921AA32EBB49D96AFC9024B94FE67D15AC44DB72),
    .INIT_7C(256'hE976038F19A127AA2CAA259D1181ED54B7156DC00E5596D105335A7A93A5B0B4),
    .INIT_7D(256'h57C534A6198E057EF875F272F376FA80078F19A430BD4BDA69F98919AA3ACA5A),
    .INIT_7E(256'hD259DF63E667E662DC53C839A61076D7348CE02E76B9F72E5F8AAFCDE4F5FF03),
    .INIT_7F(256'hED57C331A11285FA70E761DC58D655D557DA5EE369F0780089139C26B039C24B),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 }),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_1 }),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_wrapper_init__parameterized1
   (DOADO,
    DOPADOP,
    clka,
    addra);
  output [7:0]DOADO;
  output [0:0]DOPADOP;
  input clka;
  input [12:0]addra;

  wire [7:0]DOADO;
  wire [0:0]DOPADOP;
  wire [12:0]addra;
  wire clka;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h39CE63319CE383FF7398CCC66338F07FE733199998C61E00CC666666667387C0),
    .INITP_01(256'h71C639C638F0F800E39C6318E30E0FF0C639CE631CF1E07F9C6319CC631C3E00),
    .INITP_02(256'hC38F1C71E3C1F800871C71C70E1E07FF1C38C71C70E0F80038E38C71C70F07FF),
    .INITP_03(256'h0F1E1C3C3C1F800F3C3878F1E0F03FFF78F1E3C78787F000F1E38F1C3C3C0FFF),
    .INITP_04(256'h787C3C1E0FC0FFFFF0F0F0F87C0FE000C3E1C3C1E0FC03FF8787870F07C1FF00),
    .INITP_05(256'h83E0F83E07F001FF07C3E0F83F00FFFF1F0783E1F81FE0003E1E0F07C1FC00FF),
    .INITP_06(256'h3E07C0FC07FC0000FC1F83F03F801FFFF07E0F81F807FFE0E0F83E07C07FC000),
    .INITP_07(256'h80FC07F01FF8000003F01F80FF000FFF07E07E07F007FFFF1F81F81F807FF000),
    .INITP_08(256'h7F01FE01FF80003FFC07F00FF800FFFFF81FC07F801FFFFFE03F01FC01FFE000),
    .INITP_09(256'h00FF00FFC000FFFF03FC03FE003FFFFF0FF00FF003FFF8003FC07F803FFC0000),
    .INITP_0A(256'hFC00FF8007FFFFE0F007FE007FFF0000E01FF003FFC00000807FC01FFC00007F),
    .INITP_0B(256'h0FFC003FFE0000003FF001FFE000007FFFC00FFF0001FFFFFF003FF0003FFFFF),
    .INITP_0C(256'h800FFF8000FFFFFF003FFC000FFFFFFF00FFE000FFFFF00003FF8007FFF80000),
    .INITP_0D(256'hFF8003FFFE000000FC001FFFE0000000F0007FFE000001FFC003FFF00003FFFF),
    .INITP_0E(256'h1FFFC0000FFFFFFF7FFE0000FFFFFFFFFFF8000FFFFFF800FFE0007FFFF80000),
    .INITP_0F(256'h000FFFFE00000000003FFFE00000000700FFFF000000FFFF07FFF800007FFFFF),
    .INIT_00(256'hC646C542BE38B1279A0B79E34BAF0F6AC21564ADF1306A9ECCF5173349596366),
    .INIT_01(256'h85EC54BF2B980778EA5DD248C039B32FAB29A828A829AB2EB034B73ABD40C345),
    .INIT_02(256'hC23CB52CA21587F764CF379CFE5CB60D60AEF83D7DB9EF204C7292ACC1D0D9DC),
    .INIT_03(256'h1E82E74EB7208CF866D646B82CA0168C047DF671EC68E461DE5BD956D350CC48),
    .INIT_04(256'hC83CAE208FFD69D33BA00262BE176CBE0C569CDD1A5285B3DC001E374A586164),
    .INIT_05(256'hB91A7CE045AB127BE651BE2C9A0B7CEE61D549BF35AC239A12890179F067DD53),
    .INIT_06(256'hD644B11D87EF56BA1C7CD9348BDF307DC70D4F8CC5FA2A567C9EBBD2E5F2FAFC),
    .INIT_07(256'h56B41373D5389C0167CF38A20D79E553C231A11283F567D94BBE30A21486F767),
    .INIT_08(256'hEC55BD2388EB4CAC0964BC1164B400498FD10F497FB1DF082C4C677D8E9BA2A5),
    .INIT_09(256'hF44FAB0867C62789EC50B51B82EA53BC2691FD69D643B01D8BF865D33FAC1782),
    .INIT_0A(256'h0A6ED13292F04DA70056A9FA4994DD2264A2DD144776A1C8EA0821364752595C),
    .INIT_0B(256'h94EC45A0FB57B51373D33597FA5FC3298FF65DC52D95FE67D038A10971D83FA5),
    .INIT_0C(256'h2F8FED49A5FE56AC0052A1EE3880C506447FB7EB1B487095B5D2EAFD0D181F21),
    .INIT_0D(256'h368BE13991EB45A0FC5AB81676D63799FB5EC12589ED51B61A7EE246A90C6ECF),
    .INIT_0E(256'h5CB71069BF1568BA0A58A3EC3276B7F531689DCEFC264C6F8EA8BFD2E0EBF1F3),
    .INIT_0F(256'hD92C7FD42980D72F88E23D98F551AF0D6BCA2A89E949A90A6ACA2989E746A300),
    .INIT_10(256'h8FE63B90E23483D11D67AEF33677B4EF275C8EBDE8103455728BA1B2C0CAD0D2),
    .INIT_11(256'h7ECE1F71C4176CC1176EC51D76CF2984DF3A96F24EAA0662BE1A76D12C86DF38),
    .INIT_12(256'hCA1C6EBE0D5AA6F0387EC2044481BBF3285B8AB6DF052746627A8E9FACB5BBBD),
    .INIT_13(256'h2472C01060B10254A8FB50A5FA51A7FE56AE065EB60F67C01870C81F76CC2176),
    .INIT_14(256'h0A59A7F33E88D0175B9EDF1E5A94CC01336390BAE00425425C738696A2ABB1B2),
    .INIT_15(256'hCC1864B0FE4C9BEA3B8CDD2F82D5287CD02579CE2378CD2276CB1F72C51869BA),
    .INIT_16(256'h519CE62F77BD024587C6043F79B0E51747749FC7EC0E2C4861778998A4ACB1B3),
    .INIT_17(256'h76BF08539EE93682D01E6DBC0C5CACFD4E9FF14294E53788D92A7BCB1A69B704),
    .INIT_18(256'h9DE52C72B6F93B7BB9F63069A0D40736648FB7DD00203E58708495A4AFB7BBBD),
    .INIT_19(256'h2168AFF73F89D21D68B3FF4B98E53381CF1D6BBA0856A5F3418EDB2874BF0A54),
    .INIT_1A(256'hEF3478BAFC3C7AB7F32C649ACE00305E89B2D8FC1E3C5871879BABB9C3CBCFD1),
    .INIT_1B(256'hCE12579DE32A71B9014A94DD2872BD08539EE93580CB1762ACF7418AD31B63A9),
    .INIT_1C(256'h4789C9094784C0FA336A9FD30534628DB6DD022443617B93A8BACAD7E1E8ECEE),
    .INIT_1D(256'h7CBE014488CD12579DE42B72B9014991DA226BB3FC448CD41C63AAF1377CC004),
    .INIT_1E(256'hA3E2205D99D30C447AAEE112426F9AC4EB103353718DA6BDD1E3F1FE070E1213),
    .INIT_1F(256'h2B6CACEE3072B5F83C80C4094E93D81E64AAEF357BC0064B90D4185C9FE12364),
    .INIT_20(256'h05417DB7F0285E93C7F92A5886B1DA02274A6B8AA7C1D9EF0213212C353C4041),
    .INIT_21(256'hDC1B5999D819599ADC1D60A2E4276AADF13477BAFD4083C508498BCB0C4B8AC8),
    .INIT_22(256'h6CA6DE164C82B6E91A4A78A5D0F921466A8BABC8E4FD14283A4A58636B717576),
    .INIT_23(256'h8FCB084583C1003F7EBDFD3D7EBEFF3F80C1024283C3044383C2013F7DB9F631),
    .INIT_24(256'hD70E457AAEE1134373A0CDF720486D91B3D3F10D273F55697A8996A0A9AEB2B3),
    .INIT_25(256'h437DB8F42F6CA8E522609DDB195796D413518FCE0C4A88C5023F7BB7F22C669F),
    .INIT_26(256'h477CB0E3154675A4D1FC274F779CC0E203213E5972889DB0C0CFDBE5EDF2F6F7),
    .INIT_27(256'hF8316AA3DD18528DC8043F7BB7F32F6BA8E4205C98D30F4A85BFF9326BA3DA11),
    .INIT_28(256'hBBED1F5080AFDC09345E86ADD3F7193A587691ABC2D8ECFE0D1B2730383D4041),
    .INIT_29(256'hAEE61D558DC5FE3770AAE31D5791CB053F79B3ED276099D20A427AB1E81D5387),
    .INIT_2A(256'h336393C2F01D48739CC4EB1034567796B4D0EA02192E4151616E7982898E9192),
    .INIT_2B(256'h669CD2083E75ACE31A5289C1F93169A1D9114981B8F0275D94CAFF34689CCF01),
    .INIT_2C(256'hAFDE0B38648FB9E2093055789BBBDBF9152F486075899BABBAC6D1D9E0E5E8E9),
    .INIT_2D(256'h205388BCF1265B90C6FC31679ED40A4076ACE2174D82B7EC205487BAEC1E4F7F),
    .INIT_2E(256'h2F5C88B3DD062E557BA0C3E5062543607B94ACC3D7EAFB0B18242F373D424546),
    .INIT_2F(256'hDA0D3F72A5D80C3F73A7DB104478ACE115497DB1E4174A7DAFE1134474A4D301),
    .INIT_30(256'hB2DD08315981A7CDF11436577694B1CCE6FE152B3E5061707D88929AA0A4A7A8),
    .INIT_31(256'h96C7F8295B8CBEF0235587BAEC1F5184B6E81A4C7EAFE1114272A1D0FF2D5A87),
    .INIT_32(256'h3A638BB3DA0025496B8DADCDEB08233D566D8398AABCCBDAE6F1FA02080C0F0F),
    .INIT_33(256'h5383B2E2124272A3D304356697C7F8295A8ABAEB1A4A79A8D70533608DB9E50F),
    .INIT_34(256'hC4EC13395E83A6C8EA0A294764809AB3CBE1F6091B2C3B49545F686F75797B7C),
    .INIT_35(256'h123F6E9CCAF9285786B5E4144372A1D0FF2E5D8BB9E715426F9CC8F31E49739C),
    .INIT_36(256'h52789EC2E6092B4C6C8BA9C6E1FC152D44596D8091A1AFBCC8D2DAE1E6EAEDED),
    .INIT_37(256'hD1FE2A5785B2DF0D3A6896C3F11F4C7AA7D4012E5B87B3DF0A355F89B3DB042B),
    .INIT_38(256'hE3082C4F7193B4D3F2102C48627C94ABC1D5E8FA0B1A28343F4951585D606363),
    .INIT_39(256'h92BDE914406C98C4F01C4875A1CDF925517DA8D3FE29547EA7D1FA224A7198BE),
    .INIT_3A(256'h779BBDDF0020405E7C98B4CEE800172D425668798998A5B1BBC4CCD2D7DBDDDE),
    .INIT_3B(256'h547EA8D2FD27527DA7D2FD28527DA8D2FD27517BA4CDF61F476F96BDE40A2F53),
    .INIT_3C(256'h0F31527292B1CFEC09243F5870889EB3C7DAECFC0B1926313B444C52565A5C5D),
    .INIT_3D(256'h17406992BBE40D37608AB3DD062F5882AAD3FC244C749CC3EA10365B80A5C9EC),
    .INIT_3E(256'hA9C9E9092745627E99B3CDE5FD13283D50627383919FABB6BFC8CFD5D9DDDFDF),
    .INIT_3F(256'hDB032A527AA2CAF21B436B93BBE30B335A82A9D0F71D43698EB3D8FC20436587),
    .INIT_40(256'h456584A2BFDCF8132D465F768CA2B7CADCEEFE0D1B28343E474F565C60636566),
    .INIT_41(256'hA0C7ED143B6288AFD6FD244B7298BFE50C32587DA3C8ED1135597C9FC1E30525),
    .INIT_42(256'hE503213E5A7690AAC4DCF30A2034485B6C7D8D9BA9B5C0CAD3DBE1E7EBEEF0F0),
    .INIT_43(256'h678CB2D7FD22486E94B9DF052A4F759ABFE4092D517598BCDF0123456686A6C6),
    .INIT_44(256'h87A4C1DDF8122C455D758BA1B6CADDEF00101F2C3945505A626A7075797C7E7E),
    .INIT_45(256'h2E52779BC0E4092D52779BC0E4082C507498BBDE012446688AABCCEC0C2C4B69),
    .INIT_46(256'h2B48637E98B2CBE3FA10263B4F62748696A5B4C1CDD9E3ECF5FC02070B0D0F10),
    .INIT_47(256'hF71A3D6184A8CBEF1235597C9FC2E5082B4D7092B3D5F61737587797B5D4F10F),
    .INIT_48(256'hD2EE08223B546C8399AFC4D8EBFE0F202F3E4C5965707A838A91979CA0A2A4A4),
    .INIT_49(256'hC0E205274A6C8EB1D3F6183A5C7EA0C2E30526476788A8C8E7062543607E9AB7),
    .INIT_4A(256'h7C96AFC8E1F80F263B5064788A9CADBDCCDAE7F4FF0A131C232A2F34383A3C3C),
    .INIT_4B(256'h8BACCDEF1032537496B7D8F91B3B5C7D9DBEDEFE1D3C5B7A98B6D4F10E2A4661),
    .INIT_4C(256'h27405971899FB6CBE0F4071A2C3D4D5C6B7985919CA6B0B8BFC6CBCFD3D5D7D7),
    .INIT_4D(256'h567797B7D8F81939597A9ABADAFA1A3A597897B6D5F3112E4C6985A1BDD8F30D),
    .INIT_4E(256'hD5ED051C33495E73879AADBFD0E0F0FF0D1A26323C464F575E64696D71737575),
    .INIT_4F(256'h23426281A1C0E0FF1E3E5D7C9BBAD9F8163452708EABC8E5011D39546E89A3BC),
    .INIT_50(256'h859CB3CADFF5091D30435566778796A4B1BECAD5DFE9F1F9FF050A0E12141516),
    .INIT_51(256'hF00F2D4C6A89A8C6E50321405E7C9AB7D5F20F2C4965819DB8D3EE08223B546D),
    .INIT_52(256'h374D63798EA2B6CADCEE0010202F3E4C5965707B858E969DA4A9AEB2B5B7B9B9),
    .INIT_53(256'hBEDCFA183553718EACCAE704213F5B7895B1CDE905203B56718BA5BED7F0081F),
    .INIT_54(256'hEA00162A3F5366788A9CACBCCCDAE8F6020E19232D353D444A5054585B5D5F5F),
    .INIT_55(256'h8EABC8E4011E3B587591AECAE6031F3B56728DA8C3DDF8122B445D768EA6BDD4),
    .INIT_56(256'hA0B5CADEF20517293A4B5B6B7A8895A2AEB9C4CED7DFE7EEF4F9FD0104060707),
    .INIT_57(256'h5E7A96B2CEEA06223E5A7691ADC8E3FE19344E68829CB5CEE7001830475E748A),
    .INIT_58(256'h586C8093A6B9CBDCEDFD0C1B2A3744515C67717B848C939A9FA4A9ACAFB1B2B2),
    .INIT_59(256'h2F4A66819CB7D3EE09243F59748FA9C3DDF7112A435C758DA5BDD4EB01182D43),
    .INIT_5A(256'h1125384B5D6F8091A1B1C0CEDCE9F5010C17212A333A41484D52565A5C5E5F60),
    .INIT_5B(256'h011B36506B85A0BAD5EF09233D567089A3BCD5ED051E354D647B92A8BED3E8FD),
    .INIT_5C(256'hCCDFF2041627374857667583909DA9B4BFC9D3DBE4EBF2F8FD0206090C0E0F0F),
    .INIT_5D(256'hD3ED07213B556E88A1BBD4ED071F385169829AB2C9E0F80E253B51667B90A5B8),
    .INIT_5E(256'h899BADBFD0E0F1000F1E2C3946525E69737D868F979EA5ABB0B4B8BBBEBFC0C1),
    .INIT_5F(256'hA7C0D9F20B243D566F88A1B9D1EA021A314960778EA5BBD1E7FC12263B4F6376),
    .INIT_60(256'h47596A7B8C9CABBBC9D7E5F2FE0A15202A333C444C53595F64686C6F72737475),
    .INIT_61(256'h7B94ACC5DDF50E263E566E869DB5CCE3FA11283E546A8095AABFD4E8FC0F2235),
    .INIT_62(256'h0718293A4A59687785929FACB8C3CED8E2EBF4FC030A10161A1F222527292A2A),
    .INIT_63(256'h50688098AFC7DFF60E253C536A8198AEC5DBF1071C31465B6F8497ABBED1E3F5),
    .INIT_64(256'hC8D9E9F909182634424F5C68737F89939CA5AEB5BCC3C9CED3D7DADDDFE1E2E2),
    .INIT_65(256'h263D556C839AB1C8DEF50C22384F657A90A6BBD0E5F90E2236495C6F8294A6B7),
    .INIT_66(256'h8B9CABBBCAD8E6F4010E1A26313B464F58616970777D83888D919497999A9B9C),
    .INIT_67(256'hFD132A40576D849AB0C6DCF2081D32485D72869BAFC3D7EAFD10233547596A7B),
    .INIT_68(256'h505F6F7E8C9AA8B5C2CEDAE5F0FA040D161E262D343A3F44494C505254565757),
    .INIT_69(256'hD4EA00162C42576D8398ADC3D8EC01162A3F53667A8DA1B3C6D8EAFC0D1F2F40),
    .INIT_6A(256'h15253342505D6B7784909BA6B0BAC4CDD5DDE5ECF2F8FD02060A0D1012131414),
    .INIT_6B(256'hACC2D7EC02172C41566B8094A9BDD1E5F90D203346596C7E90A2B3C4D5E6F606),
    .INIT_6C(256'hDDEBFA0815222F3B47535E68737C858E969EA5ACB2B8BDC2C6C9CCCFD1D2D3D3),
    .INIT_6D(256'h859AAFC4D8ED01162A3E53677B8EA2B5C9DCEF011426384A5B6C7D8E9EAEBECE),
    .INIT_6E(256'hA5B3C1CFDCE8F5010C17222C364048515960676E74797E83878A8D8F91929394),
    .INIT_6F(256'h5F73879BB0C4D8ECFF13273A4D61748799ACBED0E2F405172838495969788796),
    .INIT_70(256'h6F7C8A97A4B0BCC8D3DEE8F2FB040D151D242B31373C4145494C4F5153555556),
    .INIT_71(256'h394D6074889BAFC2D5E8FB0E213446596B7D8FA0B2C3D4E5F505152534435261),
    .INIT_72(256'h3A4754616D7985909BA5AFB9C2CBD3DBE2E9F0F6FB0105090D10131517181919),
    .INIT_73(256'h14273A4D60738699ACBFD1E4F6081A2C3D4F60718293A3B4C4D3E3F201101E2C),
    .INIT_74(256'h06131F2C37434E59646E77818A929AA2A9B0B6BCC1C6CBCFD3D6D8DADCDDDEDE),
    .INIT_75(256'hEF0215273A4C5F718396A8BACBDDEE00112233435464748493A2B1C0CFDDEBF8),
    .INIT_76(256'hD3DFECF8030E19242E38414A535B636A71787E84898E9296999C9FA1A3A4A4A5),
    .INIT_77(256'hCBDEF0021426384A5C6D7F90A2B3C4D5E5F6061626364555647381909EABB9C6),
    .INIT_78(256'hA1ADB9C5D0DBE6F0FA030C151D252D343B41474D52565A5E626567696B6C6C6D),
    .INIT_79(256'hA8BACCDDEF0112233546576879899AAABBCBDAEAFA091827364452606E7B8895),
    .INIT_7A(256'h717D88939EA9B3BDC6D0D8E1E9F1F8FF060C11171C2024282B2E303234353636),
    .INIT_7B(256'h8597A8B9CBDCEDFE0E1F30405161718191A0B0BFCEDDEBFA081624313F4C5865),
    .INIT_7C(256'h414D58636D78828B949DA6AEB6BDC4CBD2D8DDE2E7EBEFF3F6F9FBFDFE000000),
    .INIT_7D(256'h63748596A7B7C8D8E9F909192939495868778695A3B2C0CEDCE9F704111D2936),
    .INIT_7E(256'h131E29333E48515B636C747C848B92999FA5AAAFB4B8BCBFC2C5C7C9CACBCCCC),
    .INIT_7F(256'h425263738494A4B4C4D4E4F3031221303F4E5D6B798795A3B0BDCAD7E4F0FC07),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra[11:0],1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],DOADO}),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],DOPADOP}),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(addra[12]),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_wrapper_init__parameterized2
   (\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ,
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_1 ,
    clka,
    ena_array,
    addra);
  output [7:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ;
  output [0:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_1 ;
  input clka;
  input [0:0]ena_array;
  input [11:0]addra;

  wire [7:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ;
  wire [0:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_1 ;
  wire [11:0]addra;
  wire clka;
  wire [0:0]ena_array;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h00000000000FCD2000000000000F8DA000000000000F8C3100000000001F8850),
    .INITP_01(256'h000000000007E32400000000000FE25100000000000FC69E00000000000FC563),
    .INITP_02(256'h000000000001FE0F000000000003F83E000000000003F8E0000000000007F19C),
    .INITP_03(256'h0000000000003FFF0000000000007FF8000000000000FFC0000000000001FF00),
    .INITP_04(256'h000000000000007F00000000000001FF00000000000007FF0000000000001FFF),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000003),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h6A7179828C97A4B2C1D3E8001C3C6290C70B5FC84F01F2422D21070B862EBB00),
    .INIT_01(256'h191A1B1C1D1E1F202123242527292A2C2E303234373A3D4043474A4F53585E64),
    .INIT_02(256'h6A7179828C97A3B1C1D3E8FF1B3B618FC5085BC348F7E32A04D56A94193EFA31),
    .INIT_03(256'h191A1B1C1D1E1F202123242527292A2C2E303234373A3C4043464A4F53585E64),
    .INIT_04(256'h6A7179828B96A3B0C0D2E6FD19385E8AC00151B534DAB7E59006D40FE23E8ACC),
    .INIT_05(256'h191A1B1C1D1E1F202123242527282A2C2E303234373A3C3F43464A4E53585D63),
    .INIT_06(256'h697078818B95A1AFBED0E4FA15345883B6F4409E15AD747EEAEACE1054F44BCC),
    .INIT_07(256'h191A1B1C1D1E1F202123242527282A2C2E30323437393C3F43464A4E53585D63),
    .INIT_08(256'h697077808994A0ADBCCDE0F6102D5079A9E42A81ED7522032CB8CC8F1722B533),
    .INIT_09(256'h191A1B1C1D1E1F202122242527282A2C2E30323437393C3F42464A4E52575C62),
    .INIT_0A(256'h686E767E88929DAAB9C9DCF10926466D9AD0115FBF35C9826D950ACFD6E48020),
    .INIT_0B(256'h191A1B1C1D1E1F202122242527282A2C2D2F323436393C3F4245494D52565C61),
    .INIT_0C(256'h666D757D86909BA7B5C5D7EB021D3B5F89BAF43A8EF36E04BA9597BDF212E533),
    .INIT_0D(256'h191A1B1C1D1E1F202122242526282A2B2D2F313436393B3E4145494D51565B60),
    .INIT_0E(256'h656C737B838D98A4B1C0D1E4FA132F5076A3D7145CB1168E1ABB6F31F19A103A),
    .INIT_0F(256'h191A1B1C1D1E1F20212223252628292B2D2F313336383B3E4144484C50555A5F),
    .INIT_10(256'h646A7179818A94A0ADBBCBDDF1082240638BB9EE2B73C5238F05850884ED334C),
    .INIT_11(256'h191A1B1C1C1D1E20212223252628292B2D2F313335383A3D4044474B4F54595E),
    .INIT_12(256'h62686F767E87919CA8B5C4D5E8FD15304F739BC8FD387BC51870CC277ABDEAFA),
    .INIT_13(256'h191A1A1B1C1D1E1F212223242627292B2C2E303235373A3D4043464A4E52575C),
    .INIT_14(256'h60666D747B848D97A3AFBDCDDEF208203C5B7EA5D1023873B3F53879B2E0FD08),
    .INIT_15(256'h191A1A1B1C1D1E1F202223242527292A2C2E30323437393C3F4245494D51565B),
    .INIT_16(256'h5E646A71788089939EA9B6C5D5E6FA1029446284A9D1FD2C5E90C2F019394D55),
    .INIT_17(256'h19191A1B1C1D1E1F202123242527282A2C2D2F313436383B3E4144484C505459),
    .INIT_18(256'h5C62686E757D858E98A3AFBCCBDBED01162E486584A5C9EF153C6284A2B9C7CC),
    .INIT_19(256'h18191A1B1C1D1E1F20212224252628292B2D2F313335383A3D4043474A4E5357),
    .INIT_1A(256'h5A60656B72798189939DA8B4C1D0E0F105193048637E9CBAD8F6132D43545F62),
    .INIT_1B(256'h18191A1B1C1D1E1F20212223252627292B2C2E303235373A3C3F4246494D5156),
    .INIT_1C(256'h585D63686F757D858D97A1ACB8C5D4E3F406192E445B738CA4BCD2E6F7040B0E),
    .INIT_1D(256'h18191A1B1B1C1D1E1F202223242627292A2C2E30323436393B3E4144484B4F54),
    .INIT_1E(256'h565B60656B72788088909AA4AFBBC8D5E4F40517293C5064788B9CACB8C2C8CA),
    .INIT_1F(256'h18191A1A1B1C1D1E1F202123242527282A2B2D2F313335383A3D4043464A4E52),
    .INIT_20(256'h54585D62686E747B828A939CA6B1BCC8D5E3F2011121314252616F7B858C9193),
    .INIT_21(256'h1819191A1B1C1D1E1F20212223252628292B2D2E30323537393C3F4245484C50),
    .INIT_22(256'h52565A5F646A70767D858C959EA7B2BCC8D4E0EDFB081624313D48525A606365),
    .INIT_23(256'h1818191A1B1C1D1D1E20212223242627292A2C2E30323436383B3D4043474A4E),
    .INIT_24(256'h4F53585C61666C72787F868E969EA7B1BBC6D0DCE7F3FE09141E272F353A3D3E),
    .INIT_25(256'h1718191A1A1B1C1D1E1F202123242527282A2B2D2F313335373A3C3F4245484C),
    .INIT_26(256'h4D5155595E63686D737980878E969EA6AFB8C2CCD5DFE9F2FB030B11161A1D1D),
    .INIT_27(256'h171819191A1B1C1D1E1F20212223252627292B2C2E30323436383B3D4043464A),
    .INIT_28(256'h4B4F52565B5F64696E747A80878E959CA4ACB5BDC5CED6DEE5ECF2F8FCFF0102),
    .INIT_29(256'h171818191A1B1C1D1D1E1F212223242527282A2B2D2F313335373A3C3F424548),
    .INIT_2A(256'h494C5053575C60656A6F747A80868D939AA1A8B0B7BEC5CCD2D8DDE1E5E7E9EA),
    .INIT_2B(256'h171718191A1A1B1C1D1E1F20212224252628292B2C2E30323436383B3D404346),
    .INIT_2C(256'h474A4D5154585C61656A6F74797F858B91979DA4AAB0B6BCC1C6CACED1D3D4D5),
    .INIT_2D(256'h17171819191A1B1C1D1E1F20212223242627282A2C2D2F31333537393C3E4144),
    .INIT_2E(256'h45474B4E5155595D61656A6E73787D83888E93999EA3A9ADB2B6BABDBFC1C2C3),
    .INIT_2F(256'h16171818191A1B1C1C1D1E1F20212324252628292B2C2E30323436383A3C3F42),
    .INIT_30(256'h4245484B4E5255595D6165696D72777B80858A8F93989CA1A5A8ABAEB0B1B2B3),
    .INIT_31(256'h16171718191A1A1B1C1D1E1F20212223242627282A2B2D2F31323436393B3D40),
    .INIT_32(256'h404346494B4F5255595C6064686C7074797D81868A8E9295999C9EA1A2A4A4A5),
    .INIT_33(256'h1616171819191A1B1C1D1D1E1F20212324252628292B2C2E2F31333537393B3E),
    .INIT_34(256'h3E414346494C4F5255585C5F63676A6E72767A7D8184888B8E90939596979898),
    .INIT_35(256'h1616171818191A1A1B1C1D1E1F20212223242627282A2B2D2E30323436383A3C),
    .INIT_36(256'h3C3F414446494C4E5154585B5E6165686C6F7276797C7F828486888A8B8C8D8D),
    .INIT_37(256'h151617171819191A1B1C1D1D1E1F20212224252627292A2C2D2F31323436383A),
    .INIT_38(256'h3A3D3F414446494B4E515456595C606366696C6F717477797B7D7F8182828383),
    .INIT_39(256'h151616171818191A1A1B1C1D1E1F2021222324252728292B2C2E2F3133353638),
    .INIT_3A(256'h393B3D3F414346484B4D505355585B5D606366686B6D6F7273757778797A7A7A),
    .INIT_3B(256'h15151617171819191A1B1C1C1D1E1F20212223252627282A2B2C2E3031333537),
    .INIT_3C(256'h37393B3D3F414345484A4C4F515456595B5E60626567696B6C6E6F7071727272),
    .INIT_3D(256'h15151616171818191A1A1B1C1D1E1F2021222324252627292A2B2D2E30323335),
    .INIT_3E(256'h3537393A3C3E40434547494B4D50525456595B5D5F616364666768696A6A6B6B),
    .INIT_3F(256'h1415151617171819191A1B1C1C1D1E1F2021222324252628292A2C2D2F303233),
    .INIT_40(256'h333537383A3C3E40424446484A4C4E50525456585A5B5D5E6061626363646464),
    .INIT_41(256'h1415151616171818191A1A1B1C1D1E1E1F2021222324262728292A2C2D2F3032),
    .INIT_42(256'h32333536383A3C3D3F41434547484A4C4E505153555658595A5B5C5D5E5E5E5E),
    .INIT_43(256'h141415151617171818191A1B1B1C1D1E1F202121222425262728292B2C2D2F30),
    .INIT_44(256'h303233353638393B3D3E4042434547494A4C4D4F505253545556575858585959),
    .INIT_45(256'h14141515161617171819191A1B1C1C1D1E1F202122232425262728292B2C2D2F),
    .INIT_46(256'h2F303133343637393A3C3D3F404244454748494B4C4D4F505051525353535454),
    .INIT_47(256'h13141415151616171818191A1A1B1C1D1D1E1F2021222324252627282A2B2C2D),
    .INIT_48(256'h2D2E30313234353738393B3C3E3F41424345464748494A4B4C4D4E4E4F4F4F4F),
    .INIT_49(256'h1313141415161617171819191A1B1B1C1D1E1E1F202122232425262728292B2C),
    .INIT_4A(256'h2C2D2E2F313233343637383A3B3C3E3F404143444546474848494A4A4A4B4B4B),
    .INIT_4B(256'h131314141515161617171819191A1B1B1C1D1E1F1F202122232425262728292B),
    .INIT_4C(256'h2A2B2D2E2F30313334353637393A3B3C3D3E3F40414243444545464647474747),
    .INIT_4D(256'h121313141415151617171818191A1A1B1C1C1D1E1F2020212223242526272829),
    .INIT_4E(256'h292A2B2C2D2E3031323334353637383A3B3C3D3D3E3F40414142424343434343),
    .INIT_4F(256'h12131314141515161617171818191A1A1B1C1D1D1E1F20202122232425262728),
    .INIT_50(256'h28292A2B2C2D2E2F303132333435363738393A3B3B3C3D3E3E3F3F3F40404040),
    .INIT_51(256'h1212131314141515161617171819191A1B1B1C1D1D1E1F202021222324252627),
    .INIT_52(256'h262728292A2B2C2D2E2F3031323334353636373839393A3B3B3C3C3C3D3D3D3D),
    .INIT_53(256'h121213131314141515161617181819191A1B1B1C1D1D1E1F2020212223242526),
    .INIT_54(256'h25262728292A2B2C2C2D2E2F303132333334353636373738383939393A3A3A3A),
    .INIT_55(256'h11121213131414141515161717181819191A1B1B1C1D1D1E1F20202122232424),
    .INIT_56(256'h242526272728292A2B2C2D2D2E2F303031323333343435353636373737373737),
    .INIT_57(256'h1112121213131414151516161717181819191A1B1B1C1D1D1E1F1F2021222323),
    .INIT_58(256'h2324252526272829292A2B2C2C2D2E2F2F303131323233333334343435353535),
    .INIT_59(256'h111112121213131414151516161717181819191A1B1B1C1D1D1E1F1F20212222),
    .INIT_5A(256'h22232324252626272829292A2B2B2C2D2D2E2F2F303030313132323232323232),
    .INIT_5B(256'h11111112121313131414151516161717181819191A1B1B1C1D1D1E1F1F202121),
    .INIT_5C(256'h212222232424252626272828292A2A2B2C2C2D2D2E2E2E2F2F2F303030303030),
    .INIT_5D(256'h1011111112121313141414151516161717181819191A1B1B1C1C1D1E1E1F2020),
    .INIT_5E(256'h202121222323242525262627282829292A2A2B2B2C2C2D2D2D2D2E2E2E2E2E2E),
    .INIT_5F(256'h101011111212121313141414151516161717181819191A1B1B1C1C1D1D1E1F1F),
    .INIT_60(256'h1F2020212122232324242526262727282829292A2A2A2B2B2B2C2C2C2C2C2C2C),
    .INIT_61(256'h10101111111212121313141414151516161717181819191A1A1B1C1C1D1D1E1E),
    .INIT_62(256'h1E1F1F2020212222232324242525262627272828282929292A2A2A2A2A2A2A2A),
    .INIT_63(256'h1010101111111212121313141414151516161717181819191A1A1B1B1C1C1D1E),
    .INIT_64(256'h1D1E1E1F1F202021222223232424242525262627272727282828282929292929),
    .INIT_65(256'h0F1010101111111212121313141414151516161717181819191A1A1B1B1C1C1D),
    .INIT_66(256'h1C1D1D1E1E1F1F20202121222223232424242525252626262627272727272727),
    .INIT_67(256'h0F0F101010111111121213131314141415151616171718181819191A1A1B1B1C),
    .INIT_68(256'h1C1C1D1D1E1E1E1F1F2020212122222223232324242425252525252526262626),
    .INIT_69(256'h0F0F10101010111111121213131314141415151616171717181819191A1A1B1B),
    .INIT_6A(256'h1B1B1C1C1D1D1E1E1E1F1F202020212122222222232323232424242424242424),
    .INIT_6B(256'h0F0F0F1010101011111112121313131414141515161616171718181919191A1A),
    .INIT_6C(256'h1A1B1B1B1C1C1D1D1D1E1E1F1F1F202020212121212222222222232323232323),
    .INIT_6D(256'h0E0F0F0F1010101111111112121313131414141515161616171718181819191A),
    .INIT_6E(256'h191A1A1B1B1B1C1C1D1D1D1E1E1E1F1F1F202020202121212121212122222222),
    .INIT_6F(256'h0E0E0F0F0F101010111111111212121313141414151515161617171718181919),
    .INIT_70(256'h1919191A1A1B1B1B1C1C1C1D1D1D1E1E1E1E1F1F1F1F20202020202020202020),
    .INIT_71(256'h0E0E0F0F0F0F1010101111111112121213131314141515151616161717181818),
    .INIT_72(256'h18181919191A1A1A1B1B1B1C1C1C1D1D1D1D1E1E1E1E1E1F1F1F1F1F1F1F1F1F),
    .INIT_73(256'h0E0E0E0F0F0F0F10101010111111121212131313141414151515161617171718),
    .INIT_74(256'h171818181919191A1A1A1B1B1B1B1C1C1C1C1D1D1D1D1D1E1E1E1E1E1E1E1E1E),
    .INIT_75(256'h0E0E0E0E0F0F0F0F101010101111111212121313131414141515151616161717),
    .INIT_76(256'h1717171818181919191A1A1A1A1B1B1B1B1C1C1C1C1C1C1D1D1D1D1D1D1D1D1D),
    .INIT_77(256'h0D0E0E0E0E0F0F0F0F1010101011111112121213131313141414151515161616),
    .INIT_78(256'h1616171717181818181919191A1A1A1A1A1B1B1B1B1B1C1C1C1C1C1C1C1C1C1C),
    .INIT_79(256'h0D0D0E0E0E0E0F0F0F0F10101010111111121212121313131414141515151516),
    .INIT_7A(256'h161616161717171818181819191919191A1A1A1A1A1B1B1B1B1B1B1B1B1B1B1B),
    .INIT_7B(256'h0D0D0D0E0E0E0E0F0F0F0F101010101111111112121213131313141414151515),
    .INIT_7C(256'h15151616161617171717181818181819191919191A1A1A1A1A1A1A1A1A1A1A1A),
    .INIT_7D(256'h0D0D0D0D0E0E0E0E0E0F0F0F0F10101011111111121212121313131414141415),
    .INIT_7E(256'h141515151516161616171717171818181818181919191919191919191919191A),
    .INIT_7F(256'h0C0D0D0D0D0E0E0E0E0E0F0F0F0F101010101111111112121213131313141414),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 }),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_1 }),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_wrapper_init__parameterized3
   (\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ,
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_1 ,
    clka,
    addra);
  output [7:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ;
  output [0:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_1 ;
  input clka;
  input [12:0]addra;

  wire [7:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ;
  wire [0:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_1 ;
  wire [12:0]addra;
  wire clka;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h1414141515151516161616161717171717181818181818181818191919191919),
    .INIT_01(256'h0C0C0D0D0D0D0E0E0E0E0E0F0F0F0F1010101011111111121212121313131314),
    .INIT_02(256'h1314141414151515151516161616161717171717171717181818181818181818),
    .INIT_03(256'h0C0C0C0D0D0D0D0D0E0E0E0E0F0F0F0F10101010101111111112121212131313),
    .INIT_04(256'h1313131414141414151515151516161616161616171717171717171717171717),
    .INIT_05(256'h0C0C0C0C0D0D0D0D0D0E0E0E0E0F0F0F0F0F1010101011111111121212121213),
    .INIT_06(256'h1213131313131414141414151515151515161616161616161616161616161616),
    .INIT_07(256'h0C0C0C0C0C0D0D0D0D0D0E0E0E0E0E0F0F0F0F10101010101111111112121212),
    .INIT_08(256'h1212121313131313141414141414151515151515151515161616161616161616),
    .INIT_09(256'h0B0C0C0C0C0C0D0D0D0D0D0E0E0E0E0E0F0F0F0F0F1010101010111111111212),
    .INIT_0A(256'h1212121212121313131313131414141414141415151515151515151515151515),
    .INIT_0B(256'h0B0B0C0C0C0C0C0D0D0D0D0D0D0E0E0E0E0E0F0F0F0F0F101010101111111111),
    .INIT_0C(256'h1111111212121212131313131313131414141414141414141414141415151515),
    .INIT_0D(256'h0B0B0B0C0C0C0C0C0C0D0D0D0D0D0E0E0E0E0E0F0F0F0F0F1010101010111111),
    .INIT_0E(256'h1111111111121212121212121313131313131313131414141414141414141414),
    .INIT_0F(256'h0B0B0B0B0C0C0C0C0C0C0D0D0D0D0D0E0E0E0E0E0E0F0F0F0F0F101010101011),
    .INIT_10(256'h1010111111111111121212121212121213131313131313131313131313131313),
    .INIT_11(256'h0B0B0B0B0B0C0C0C0C0C0C0D0D0D0D0D0D0E0E0E0E0E0F0F0F0F0F0F10101010),
    .INIT_12(256'h1010101011111111111111121212121212121212121313131313131313131313),
    .INIT_13(256'h0B0B0B0B0B0B0C0C0C0C0C0C0C0D0D0D0D0D0E0E0E0E0E0E0F0F0F0F0F0F1010),
    .INIT_14(256'h1010101010101011111111111111111212121212121212121212121212121212),
    .INIT_15(256'h0A0B0B0B0B0B0B0B0C0C0C0C0C0C0D0D0D0D0D0D0E0E0E0E0E0E0F0F0F0F0F0F),
    .INIT_16(256'h0F0F0F1010101010101011111111111111111111111212121212121212121212),
    .INIT_17(256'h0A0A0B0B0B0B0B0B0B0C0C0C0C0C0C0C0D0D0D0D0D0D0E0E0E0E0E0E0F0F0F0F),
    .INIT_18(256'h0F0F0F0F0F0F1010101010101010111111111111111111111111111111111111),
    .INIT_19(256'h0A0A0A0A0B0B0B0B0B0B0B0C0C0C0C0C0C0D0D0D0D0D0D0D0E0E0E0E0E0E0F0F),
    .INIT_1A(256'h0E0F0F0F0F0F0F0F0F1010101010101010101010111111111111111111111111),
    .INIT_1B(256'h0A0A0A0A0A0B0B0B0B0B0B0B0C0C0C0C0C0C0C0D0D0D0D0D0D0D0E0E0E0E0E0E),
    .INIT_1C(256'h0E0E0E0F0F0F0F0F0F0F0F0F1010101010101010101010101010101010101010),
    .INIT_1D(256'h0A0A0A0A0A0A0B0B0B0B0B0B0B0C0C0C0C0C0C0C0C0D0D0D0D0D0D0D0E0E0E0E),
    .INIT_1E(256'h0E0E0E0E0E0E0F0F0F0F0F0F0F0F0F0F0F101010101010101010101010101010),
    .INIT_1F(256'h0A0A0A0A0A0A0A0A0B0B0B0B0B0B0B0C0C0C0C0C0C0C0D0D0D0D0D0D0D0D0E0E),
    .INIT_20(256'h0E0E0E0E0E0E0E0E0E0E0F0F0F0F0F0F0F0F0F0F0F0F0F0F1010101010101010),
    .INIT_21(256'h090A0A0A0A0A0A0A0A0B0B0B0B0B0B0B0B0C0C0C0C0C0C0C0D0D0D0D0D0D0D0D),
    .INIT_22(256'h0D0D0D0E0E0E0E0E0E0E0E0E0E0E0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F),
    .INIT_23(256'h09090A0A0A0A0A0A0A0A0A0B0B0B0B0B0B0B0C0C0C0C0C0C0C0C0D0D0D0D0D0D),
    .INIT_24(256'h0D0D0D0D0D0D0E0E0E0E0E0E0E0E0E0E0E0E0E0F0F0F0F0F0F0F0F0F0F0F0F0F),
    .INIT_25(256'h090909090A0A0A0A0A0A0A0A0B0B0B0B0B0B0B0B0C0C0C0C0C0C0C0C0C0D0D0D),
    .INIT_26(256'h0D0D0D0D0D0D0D0D0D0D0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E),
    .INIT_27(256'h09090909090A0A0A0A0A0A0A0A0A0B0B0B0B0B0B0B0B0C0C0C0C0C0C0C0C0C0D),
    .INIT_28(256'h0C0C0D0D0D0D0D0D0D0D0D0D0D0D0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E),
    .INIT_29(256'h090909090909090A0A0A0A0A0A0A0A0B0B0B0B0B0B0B0B0B0C0C0C0C0C0C0C0C),
    .INIT_2A(256'h0C0C0C0C0C0D0D0D0D0D0D0D0D0D0D0D0D0D0D0E0E0E0E0E0E0E0E0E0E0E0E0E),
    .INIT_2B(256'h09090909090909090A0A0A0A0A0A0A0A0A0B0B0B0B0B0B0B0B0B0B0C0C0C0C0C),
    .INIT_2C(256'h0C0C0C0C0C0C0C0C0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D),
    .INIT_2D(256'h090909090909090909090A0A0A0A0A0A0A0A0A0B0B0B0B0B0B0B0B0B0B0C0C0C),
    .INIT_2E(256'h0C0C0C0C0C0C0C0C0C0C0C0C0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D),
    .INIT_2F(256'h08090909090909090909090A0A0A0A0A0A0A0A0A0A0B0B0B0B0B0B0B0B0B0B0C),
    .INIT_30(256'h0B0B0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0D0D0D0D0D0D0D0D0D0D0D0D0D0D),
    .INIT_31(256'h080808090909090909090909090A0A0A0A0A0A0A0A0A0A0B0B0B0B0B0B0B0B0B),
    .INIT_32(256'h0B0B0B0B0B0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0D0D0D0D0D),
    .INIT_33(256'h0808080809090909090909090909090A0A0A0A0A0A0A0A0A0A0B0B0B0B0B0B0B),
    .INIT_34(256'h0B0B0B0B0B0B0B0B0B0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C),
    .INIT_35(256'h08080808080809090909090909090909090A0A0A0A0A0A0A0A0A0A0A0B0B0B0B),
    .INIT_36(256'h0B0B0B0B0B0B0B0B0B0B0B0B0B0B0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C),
    .INIT_37(256'h0808080808080809090909090909090909090A0A0A0A0A0A0A0A0A0A0A0A0B0B),
    .INIT_38(256'h0A0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0C0C0C0C0C0C0C0C0C0C0C0C),
    .INIT_39(256'h0808080808080808080909090909090909090909090A0A0A0A0A0A0A0A0A0A0A),
    .INIT_3A(256'h0A0A0A0A0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B),
    .INIT_3B(256'h08080808080808080808080909090909090909090909090A0A0A0A0A0A0A0A0A),
    .INIT_3C(256'h0A0A0A0A0A0A0A0A0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B),
    .INIT_3D(256'h080808080808080808080808090909090909090909090909090A0A0A0A0A0A0A),
    .INIT_3E(256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B),
    .INIT_3F(256'h070808080808080808080808080809090909090909090909090909090A0A0A0A),
    .INIT_40(256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0B0B0B0B0B0B0B0B0B0B0B0B0B),
    .INIT_41(256'h0707070808080808080808080808080809090909090909090909090909090A0A),
    .INIT_42(256'h090A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
    .INIT_43(256'h0707070707080808080808080808080808080909090909090909090909090909),
    .INIT_44(256'h09090909090A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
    .INIT_45(256'h0707070707070808080808080808080808080808090909090909090909090909),
    .INIT_46(256'h0909090909090909090A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
    .INIT_47(256'h0707070707070707080808080808080808080808080808090909090909090909),
    .INIT_48(256'h09090909090909090909090909090A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
    .INIT_49(256'h0707070707070707070708080808080808080808080808080809090909090909),
    .INIT_4A(256'h0909090909090909090909090909090909090909090A0A0A0A0A0A0A0A0A0A0A),
    .INIT_4B(256'h0707070707070707070707070808080808080808080808080808080809090909),
    .INIT_4C(256'h0909090909090909090909090909090909090909090909090909090909090909),
    .INIT_4D(256'h0707070707070707070707070707080808080808080808080808080808080809),
    .INIT_4E(256'h0808090909090909090909090909090909090909090909090909090909090909),
    .INIT_4F(256'h0707070707070707070707070707070708080808080808080808080808080808),
    .INIT_50(256'h0808080808080909090909090909090909090909090909090909090909090909),
    .INIT_51(256'h0607070707070707070707070707070707070808080808080808080808080808),
    .INIT_52(256'h0808080808080808080809090909090909090909090909090909090909090909),
    .INIT_53(256'h0606060707070707070707070707070707070707080808080808080808080808),
    .INIT_54(256'h0808080808080808080808080808080809090909090909090909090909090909),
    .INIT_55(256'h0606060607070707070707070707070707070707070707080808080808080808),
    .INIT_56(256'h0808080808080808080808080808080808080808080808080808080909090909),
    .INIT_57(256'h0606060606060707070707070707070707070707070707070708080808080808),
    .INIT_58(256'h0808080808080808080808080808080808080808080808080808080808080808),
    .INIT_59(256'h0606060606060606070707070707070707070707070707070707070708080808),
    .INIT_5A(256'h0808080808080808080808080808080808080808080808080808080808080808),
    .INIT_5B(256'h0606060606060606060607070707070707070707070707070707070707070707),
    .INIT_5C(256'h0707070808080808080808080808080808080808080808080808080808080808),
    .INIT_5D(256'h0606060606060606060606060707070707070707070707070707070707070707),
    .INIT_5E(256'h0707070707070708080808080808080808080808080808080808080808080808),
    .INIT_5F(256'h0606060606060606060606060606070707070707070707070707070707070707),
    .INIT_60(256'h0707070707070707070707070708080808080808080808080808080808080808),
    .INIT_61(256'h0606060606060606060606060606060606070707070707070707070707070707),
    .INIT_62(256'h0707070707070707070707070707070707070707080808080808080808080808),
    .INIT_63(256'h0606060606060606060606060606060606060607070707070707070707070707),
    .INIT_64(256'h0707070707070707070707070707070707070707070707070707070707070707),
    .INIT_65(256'h0606060606060606060606060606060606060606060607070707070707070707),
    .INIT_66(256'h0707070707070707070707070707070707070707070707070707070707070707),
    .INIT_67(256'h0506060606060606060606060606060606060606060606060607070707070707),
    .INIT_68(256'h0707070707070707070707070707070707070707070707070707070707070707),
    .INIT_69(256'h0505060606060606060606060606060606060606060606060606060607070707),
    .INIT_6A(256'h0707070707070707070707070707070707070707070707070707070707070707),
    .INIT_6B(256'h0505050506060606060606060606060606060606060606060606060606060607),
    .INIT_6C(256'h0606060707070707070707070707070707070707070707070707070707070707),
    .INIT_6D(256'h0505050505050606060606060606060606060606060606060606060606060606),
    .INIT_6E(256'h0606060606060607070707070707070707070707070707070707070707070707),
    .INIT_6F(256'h0505050505050505050606060606060606060606060606060606060606060606),
    .INIT_70(256'h0606060606060606060606060607070707070707070707070707070707070707),
    .INIT_71(256'h0505050505050505050505060606060606060606060606060606060606060606),
    .INIT_72(256'h0606060606060606060606060606060606060606060707070707070707070707),
    .INIT_73(256'h0505050505050505050505050506060606060606060606060606060606060606),
    .INIT_74(256'h0606060606060606060606060606060606060606060606060606060606060606),
    .INIT_75(256'h0505050505050505050505050505050606060606060606060606060606060606),
    .INIT_76(256'h0606060606060606060606060606060606060606060606060606060606060606),
    .INIT_77(256'h0505050505050505050505050505050505050606060606060606060606060606),
    .INIT_78(256'h0606060606060606060606060606060606060606060606060606060606060606),
    .INIT_79(256'h0505050505050505050505050505050505050505050606060606060606060606),
    .INIT_7A(256'h0606060606060606060606060606060606060606060606060606060606060606),
    .INIT_7B(256'h0505050505050505050505050505050505050505050505050606060606060606),
    .INIT_7C(256'h0606060606060606060606060606060606060606060606060606060606060606),
    .INIT_7D(256'h0505050505050505050505050505050505050505050505050505050606060606),
    .INIT_7E(256'h0606060606060606060606060606060606060606060606060606060606060606),
    .INIT_7F(256'h0505050505050505050505050505050505050505050505050505050505050506),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra[11:0],1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 }),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_1 }),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(addra[12]),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_wrapper_init__parameterized4
   (\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ,
    ena_array,
    clka,
    addra);
  output [7:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ;
  output [0:0]ena_array;
  input clka;
  input [12:0]addra;

  wire [7:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_n_71 ;
  wire [12:0]addra;
  wire clka;
  wire [0:0]ena_array;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h0000000000000000000000000000000000010101010202030405080C1632C800),
    .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_02(256'h0000000000000000000000000000000000010101010102030405070B142864C9),
    .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_04(256'h0000000000000000000000000000000000010101010102020305060A0F192832),
    .INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_06(256'h000000000000000000000000000000000000010101010202030405080B0F1416),
    .INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_08(256'h00000000000000000000000000000000000001010101020203030406080A0B0C),
    .INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0A(256'h0000000000000000000000000000000000000101010101020203040405060708),
    .INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0C(256'h0000000000000000000000000000000000000001010101020202030304050505),
    .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0E(256'h0000000000000000000000000000000000000001010101010202020303030404),
    .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_10(256'h0000000000000000000000000000000000000000010101010102020202020303),
    .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_12(256'h0000000000000000000000000000000000000000000101010101010202020202),
    .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_14(256'h0000000000000000000000000000000000000000000101010101010101010102),
    .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_16(256'h0000000000000000000000000000000000000000000000010101010101010101),
    .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_18(256'h0000000000000000000000000000000000000000000000000101010101010101),
    .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1A(256'h0000000000000000000000000000000000000000000000000000010101010101),
    .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000010101),
    .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_40(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_41(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_42(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_43(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_44(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_45(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_46(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_47(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_48(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_49(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_50(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_51(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_52(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_53(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_54(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_55(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_56(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_57(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_58(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_59(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_60(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_61(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_62(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_63(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_64(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_65(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_66(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_67(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_68(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_69(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra[11:0],1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 }),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_n_71 }),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ena_array),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT1 #(
    .INIT(2'h1)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_i_1 
       (.I0(addra[12]),
        .O(ena_array));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_prim_wrapper_init__parameterized5
   (\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ,
    clka,
    addra);
  output [7:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ;
  input clka;
  input [12:0]addra;

  wire [7:0]\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_n_71 ;
  wire [12:0]addra;
  wire clka;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_40(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_41(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_42(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_43(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_44(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_45(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_46(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_47(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_48(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_49(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_50(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_51(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_52(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_53(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_54(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_55(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_56(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_57(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_58(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_59(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_60(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_61(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_62(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_63(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_64(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_65(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_66(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_67(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_68(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_69(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,addra[11:0],1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:8],\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_0 }),
        .DOBDO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:0]),
        .DOPADOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:1],\DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_n_71 }),
        .DOPBDOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:0]),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(addra[12]),
        .ENBWREN(1'b0),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_top
   (douta,
    clka,
    addra);
  output [27:0]douta;
  input clka;
  input [12:0]addra;

  wire [12:0]addra;
  wire clka;
  wire [27:0]douta;

  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_generic_cstr \valid.cstr 
       (.addra(addra),
        .clka(clka),
        .douta(douta));
endmodule

(* C_ADDRA_WIDTH = "13" *) (* C_ADDRB_WIDTH = "13" *) (* C_ALGORITHM = "1" *) 
(* C_AXI_ID_WIDTH = "4" *) (* C_AXI_SLAVE_TYPE = "0" *) (* C_AXI_TYPE = "1" *) 
(* C_BYTE_SIZE = "9" *) (* C_COMMON_CLK = "0" *) (* C_COUNT_18K_BRAM = "1" *) 
(* C_COUNT_36K_BRAM = "6" *) (* C_CTRL_ECC_ALGO = "NONE" *) (* C_DEFAULT_DATA = "0" *) 
(* C_DISABLE_WARN_BHV_COLL = "0" *) (* C_DISABLE_WARN_BHV_RANGE = "0" *) (* C_ELABORATION_DIR = "./" *) 
(* C_ENABLE_32BIT_ADDRESS = "0" *) (* C_EN_DEEPSLEEP_PIN = "0" *) (* C_EN_ECC_PIPE = "0" *) 
(* C_EN_RDADDRA_CHG = "0" *) (* C_EN_RDADDRB_CHG = "0" *) (* C_EN_SAFETY_CKT = "0" *) 
(* C_EN_SHUTDOWN_PIN = "0" *) (* C_EN_SLEEP_PIN = "0" *) (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     8.209599 mW" *) 
(* C_FAMILY = "virtex7" *) (* C_HAS_AXI_ID = "0" *) (* C_HAS_ENA = "0" *) 
(* C_HAS_ENB = "0" *) (* C_HAS_INJECTERR = "0" *) (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
(* C_HAS_MEM_OUTPUT_REGS_B = "0" *) (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
(* C_HAS_REGCEA = "0" *) (* C_HAS_REGCEB = "0" *) (* C_HAS_RSTA = "0" *) 
(* C_HAS_RSTB = "0" *) (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
(* C_INITA_VAL = "0" *) (* C_INITB_VAL = "0" *) (* C_INIT_FILE = "rom_lut_muon_inv_dr_sq_1.mem" *) 
(* C_INIT_FILE_NAME = "rom_lut_muon_inv_dr_sq_1.mif" *) (* C_INTERFACE_TYPE = "0" *) (* C_LOAD_INIT_FILE = "1" *) 
(* C_MEM_TYPE = "3" *) (* C_MUX_PIPELINE_STAGES = "0" *) (* C_PRIM_TYPE = "1" *) 
(* C_READ_DEPTH_A = "8192" *) (* C_READ_DEPTH_B = "8192" *) (* C_READ_LATENCY_A = "1" *) 
(* C_READ_LATENCY_B = "1" *) (* C_READ_WIDTH_A = "28" *) (* C_READ_WIDTH_B = "28" *) 
(* C_RSTRAM_A = "0" *) (* C_RSTRAM_B = "0" *) (* C_RST_PRIORITY_A = "CE" *) 
(* C_RST_PRIORITY_B = "CE" *) (* C_SIM_COLLISION_CHECK = "ALL" *) (* C_USE_BRAM_BLOCK = "0" *) 
(* C_USE_BYTE_WEA = "0" *) (* C_USE_BYTE_WEB = "0" *) (* C_USE_DEFAULT_DATA = "1" *) 
(* C_USE_ECC = "0" *) (* C_USE_SOFTECC = "0" *) (* C_USE_URAM = "0" *) 
(* C_WEA_WIDTH = "1" *) (* C_WEB_WIDTH = "1" *) (* C_WRITE_DEPTH_A = "8192" *) 
(* C_WRITE_DEPTH_B = "8192" *) (* C_WRITE_MODE_A = "WRITE_FIRST" *) (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
(* C_WRITE_WIDTH_A = "28" *) (* C_WRITE_WIDTH_B = "28" *) (* C_XDEVICEFAMILY = "virtex7" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_4
   (clka,
    rsta,
    ena,
    regcea,
    wea,
    addra,
    dina,
    douta,
    clkb,
    rstb,
    enb,
    regceb,
    web,
    addrb,
    dinb,
    doutb,
    injectsbiterr,
    injectdbiterr,
    eccpipece,
    sbiterr,
    dbiterr,
    rdaddrecc,
    sleep,
    deepsleep,
    shutdown,
    rsta_busy,
    rstb_busy,
    s_aclk,
    s_aresetn,
    s_axi_awid,
    s_axi_awaddr,
    s_axi_awlen,
    s_axi_awsize,
    s_axi_awburst,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wlast,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bid,
    s_axi_bresp,
    s_axi_bvalid,
    s_axi_bready,
    s_axi_arid,
    s_axi_araddr,
    s_axi_arlen,
    s_axi_arsize,
    s_axi_arburst,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rid,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rlast,
    s_axi_rvalid,
    s_axi_rready,
    s_axi_injectsbiterr,
    s_axi_injectdbiterr,
    s_axi_sbiterr,
    s_axi_dbiterr,
    s_axi_rdaddrecc);
  input clka;
  input rsta;
  input ena;
  input regcea;
  input [0:0]wea;
  input [12:0]addra;
  input [27:0]dina;
  output [27:0]douta;
  input clkb;
  input rstb;
  input enb;
  input regceb;
  input [0:0]web;
  input [12:0]addrb;
  input [27:0]dinb;
  output [27:0]doutb;
  input injectsbiterr;
  input injectdbiterr;
  input eccpipece;
  output sbiterr;
  output dbiterr;
  output [12:0]rdaddrecc;
  input sleep;
  input deepsleep;
  input shutdown;
  output rsta_busy;
  output rstb_busy;
  input s_aclk;
  input s_aresetn;
  input [3:0]s_axi_awid;
  input [31:0]s_axi_awaddr;
  input [7:0]s_axi_awlen;
  input [2:0]s_axi_awsize;
  input [1:0]s_axi_awburst;
  input s_axi_awvalid;
  output s_axi_awready;
  input [27:0]s_axi_wdata;
  input [0:0]s_axi_wstrb;
  input s_axi_wlast;
  input s_axi_wvalid;
  output s_axi_wready;
  output [3:0]s_axi_bid;
  output [1:0]s_axi_bresp;
  output s_axi_bvalid;
  input s_axi_bready;
  input [3:0]s_axi_arid;
  input [31:0]s_axi_araddr;
  input [7:0]s_axi_arlen;
  input [2:0]s_axi_arsize;
  input [1:0]s_axi_arburst;
  input s_axi_arvalid;
  output s_axi_arready;
  output [3:0]s_axi_rid;
  output [27:0]s_axi_rdata;
  output [1:0]s_axi_rresp;
  output s_axi_rlast;
  output s_axi_rvalid;
  input s_axi_rready;
  input s_axi_injectsbiterr;
  input s_axi_injectdbiterr;
  output s_axi_sbiterr;
  output s_axi_dbiterr;
  output [12:0]s_axi_rdaddrecc;

  wire \<const0> ;
  wire [12:0]addra;
  wire clka;
  wire [27:0]douta;

  assign dbiterr = \<const0> ;
  assign doutb[27] = \<const0> ;
  assign doutb[26] = \<const0> ;
  assign doutb[25] = \<const0> ;
  assign doutb[24] = \<const0> ;
  assign doutb[23] = \<const0> ;
  assign doutb[22] = \<const0> ;
  assign doutb[21] = \<const0> ;
  assign doutb[20] = \<const0> ;
  assign doutb[19] = \<const0> ;
  assign doutb[18] = \<const0> ;
  assign doutb[17] = \<const0> ;
  assign doutb[16] = \<const0> ;
  assign doutb[15] = \<const0> ;
  assign doutb[14] = \<const0> ;
  assign doutb[13] = \<const0> ;
  assign doutb[12] = \<const0> ;
  assign doutb[11] = \<const0> ;
  assign doutb[10] = \<const0> ;
  assign doutb[9] = \<const0> ;
  assign doutb[8] = \<const0> ;
  assign doutb[7] = \<const0> ;
  assign doutb[6] = \<const0> ;
  assign doutb[5] = \<const0> ;
  assign doutb[4] = \<const0> ;
  assign doutb[3] = \<const0> ;
  assign doutb[2] = \<const0> ;
  assign doutb[1] = \<const0> ;
  assign doutb[0] = \<const0> ;
  assign rdaddrecc[12] = \<const0> ;
  assign rdaddrecc[11] = \<const0> ;
  assign rdaddrecc[10] = \<const0> ;
  assign rdaddrecc[9] = \<const0> ;
  assign rdaddrecc[8] = \<const0> ;
  assign rdaddrecc[7] = \<const0> ;
  assign rdaddrecc[6] = \<const0> ;
  assign rdaddrecc[5] = \<const0> ;
  assign rdaddrecc[4] = \<const0> ;
  assign rdaddrecc[3] = \<const0> ;
  assign rdaddrecc[2] = \<const0> ;
  assign rdaddrecc[1] = \<const0> ;
  assign rdaddrecc[0] = \<const0> ;
  assign rsta_busy = \<const0> ;
  assign rstb_busy = \<const0> ;
  assign s_axi_arready = \<const0> ;
  assign s_axi_awready = \<const0> ;
  assign s_axi_bid[3] = \<const0> ;
  assign s_axi_bid[2] = \<const0> ;
  assign s_axi_bid[1] = \<const0> ;
  assign s_axi_bid[0] = \<const0> ;
  assign s_axi_bresp[1] = \<const0> ;
  assign s_axi_bresp[0] = \<const0> ;
  assign s_axi_bvalid = \<const0> ;
  assign s_axi_dbiterr = \<const0> ;
  assign s_axi_rdaddrecc[12] = \<const0> ;
  assign s_axi_rdaddrecc[11] = \<const0> ;
  assign s_axi_rdaddrecc[10] = \<const0> ;
  assign s_axi_rdaddrecc[9] = \<const0> ;
  assign s_axi_rdaddrecc[8] = \<const0> ;
  assign s_axi_rdaddrecc[7] = \<const0> ;
  assign s_axi_rdaddrecc[6] = \<const0> ;
  assign s_axi_rdaddrecc[5] = \<const0> ;
  assign s_axi_rdaddrecc[4] = \<const0> ;
  assign s_axi_rdaddrecc[3] = \<const0> ;
  assign s_axi_rdaddrecc[2] = \<const0> ;
  assign s_axi_rdaddrecc[1] = \<const0> ;
  assign s_axi_rdaddrecc[0] = \<const0> ;
  assign s_axi_rdata[27] = \<const0> ;
  assign s_axi_rdata[26] = \<const0> ;
  assign s_axi_rdata[25] = \<const0> ;
  assign s_axi_rdata[24] = \<const0> ;
  assign s_axi_rdata[23] = \<const0> ;
  assign s_axi_rdata[22] = \<const0> ;
  assign s_axi_rdata[21] = \<const0> ;
  assign s_axi_rdata[20] = \<const0> ;
  assign s_axi_rdata[19] = \<const0> ;
  assign s_axi_rdata[18] = \<const0> ;
  assign s_axi_rdata[17] = \<const0> ;
  assign s_axi_rdata[16] = \<const0> ;
  assign s_axi_rdata[15] = \<const0> ;
  assign s_axi_rdata[14] = \<const0> ;
  assign s_axi_rdata[13] = \<const0> ;
  assign s_axi_rdata[12] = \<const0> ;
  assign s_axi_rdata[11] = \<const0> ;
  assign s_axi_rdata[10] = \<const0> ;
  assign s_axi_rdata[9] = \<const0> ;
  assign s_axi_rdata[8] = \<const0> ;
  assign s_axi_rdata[7] = \<const0> ;
  assign s_axi_rdata[6] = \<const0> ;
  assign s_axi_rdata[5] = \<const0> ;
  assign s_axi_rdata[4] = \<const0> ;
  assign s_axi_rdata[3] = \<const0> ;
  assign s_axi_rdata[2] = \<const0> ;
  assign s_axi_rdata[1] = \<const0> ;
  assign s_axi_rdata[0] = \<const0> ;
  assign s_axi_rid[3] = \<const0> ;
  assign s_axi_rid[2] = \<const0> ;
  assign s_axi_rid[1] = \<const0> ;
  assign s_axi_rid[0] = \<const0> ;
  assign s_axi_rlast = \<const0> ;
  assign s_axi_rresp[1] = \<const0> ;
  assign s_axi_rresp[0] = \<const0> ;
  assign s_axi_rvalid = \<const0> ;
  assign s_axi_sbiterr = \<const0> ;
  assign s_axi_wready = \<const0> ;
  assign sbiterr = \<const0> ;
  GND GND
       (.G(\<const0> ));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_4_synth inst_blk_mem_gen
       (.addra(addra),
        .clka(clka),
        .douta(douta));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_4_synth
   (douta,
    clka,
    addra);
  output [27:0]douta;
  input clka;
  input [12:0]addra;

  wire [12:0]addra;
  wire clka;
  wire [27:0]douta;

  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_top \gnbram.gnativebmg.native_blk_mem_gen 
       (.addra(addra),
        .clka(clka),
        .douta(douta));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
