// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Wed Dec  1 14:31:08 2021
// Host        : srv-b1b07-10-01.cern.ch running 64-bit unknown
// Command     : write_verilog -force -mode funcsim
//               /home/ugt-build/bergauer/github/cms-l1-globaltrigger/mp7_ugt_legacy/firmware/ngc/rom_lut_calo_inv_dr_sq_5/rom_lut_calo_inv_dr_sq_5_sim_netlist.v
// Design      : rom_lut_calo_inv_dr_sq_5
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7vx690tffg1927-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "rom_lut_calo_inv_dr_sq_5,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2021.2" *) 
(* NotValidForBitStream *)
module rom_lut_calo_inv_dr_sq_5
   (clka,
    addra,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [11:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [13:0]douta;

  wire [11:0]addra;
  wire clka;
  wire [13:0]douta;
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
  wire [13:0]NLW_U0_doutb_UNCONNECTED;
  wire [11:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [11:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [13:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "12" *) 
  (* C_ADDRB_WIDTH = "12" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "2" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     4.598399 mW" *) 
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
  (* C_INIT_FILE = "rom_lut_calo_inv_dr_sq_5.mem" *) 
  (* C_INIT_FILE_NAME = "rom_lut_calo_inv_dr_sq_5.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "4096" *) 
  (* C_READ_DEPTH_B = "4096" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "14" *) 
  (* C_READ_WIDTH_B = "14" *) 
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
  (* C_WRITE_DEPTH_A = "4096" *) 
  (* C_WRITE_DEPTH_B = "4096" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "14" *) 
  (* C_WRITE_WIDTH_B = "14" *) 
  (* C_XDEVICEFAMILY = "virtex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  rom_lut_calo_inv_dr_sq_5_blk_mem_gen_v8_4_5 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[13:0]),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[11:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[11:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[13:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
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
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2021.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
oESHD2Q5NORrmTVTCApB+YFZJwjA1ezq7U6VZh96by+ofPCvSFp06AIoCLvB4BhPvxfob6kIkBpR
xVCOLM7HsDk7nO1JVWiYIJ6okoWTA8hAlPj3sdGuMwRlZNSBKn/c6F+CW5Jl37TEGotkhycSB3Bg
B/uu1THUZwIG87RPahE=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
RovEhaqHrFqzjckk+DIWG8LQeqg2Y/nACQDyXKKtSav7YHlgpKmgHZnsxwwNpqrqVRGyjTecSQ+e
6Mr/Pi9au3AgJVPL6VOgwNVE0yj2LpA4LPyWzxLN3+DiSDmsaCBNCBlVQi2MRKUabou8nLaXldbL
+7pv4pYhQdcyjDzuC2dx3HmzADqstdEiyXeU3ktJ29CDLDmGwDWdmsrl90s4YQSfBV2nj4/Vut3L
p/8dzphf1htPaNMujMxxgp3z4JzUEDJJokDL+gNutEEHiaWpI3URIA5v22vJu+NPD+eEraSioHfL
DPKAajZTwK5FHnonu4O2D0co8GWqWW5cUqZz9A==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
jBQ6Th9yy7jtKQD1h235YLT6qO6XiBaBKGJrV1Z8H9M9ePJ9R/fA8E1okt4LyBvoWjR7tmCbIg7A
0/vuKOogkLtDE/BtTlp4z1iurO8rQrAcdZy/e+7GATawyJxFY7kZhnXASu9zB8TiOBELSlapkpxe
WuAzXLde9FBMBkq4RSc=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
eucSNV2Zbm4zYc2tIGRlGmlVM8+WHY1NHe9drZdgDhGPOHz8PTqHapfnZ1kWuTLtPBLSMvcXNScn
UTvpULofBV6qD7WHLPg7UJcjpZVDL69lk88chgqrlc/RqaJXKNVv+Ubku53ZLU20uZK71bNymjSM
855RVWw5lvTHTCNC2MYIS94Fmrzuq8i0+tFh5qBKkHK2BC+fD7xVyyfuh4mZR2yr/hRs/emoI79E
IKoJnLiglVp6RXTsXFzZW4pIthbjWSuZlOQvoYkS2RMj8a0r9lyariphRQunoudc0bLO4Phk578c
40gusaaS/MI7idMT7k1Di96kvu5mHi23loRcZQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
E/syLaRG2Ss/xTTkuAkOKXzm53+rCptYO2DkVukWhvlLmEB2daHCPrXt4gKeuG+0hIGWedSwCiLJ
7KNtEAiTumJ/j+3p7s3oXN9ftCSRolXoACsCclEAmwYjVM0ubCXUx6JNFOGt0yDl2Jsd5+W10mSJ
bYEKvRKi7koXM/eYJqbhTrtsrHDwRJEY0JVUPh8EOkLLqaIKbnjb6ENEY6qZOamp5PaWsSS30gJM
N6fB8D1AmGKnFbfY+d5TexS55Z92aYcAHNX2XwHsKnm45az1vHeZ0rTEU/oONIaSZfikRni1iDBg
x2GOue6sLiwxTEHaVkTJsOVR4mx0VsfFxavwRg==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_01", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
dSHHpkQiOEzzKs4D71WVyDXLpkKuR9h9h3pBLtnCq2bXiwE/eQHmk5HeQb+qREg0Yv193OukqaQz
RZyuF5GQcqOpqFHMxO62HQ2pdjdpMT5CC7gHvmgiw9qBkJJrXpihIHER4X7OF2iNUfeqxJ8eiSz3
C0V20NlIwKG7Mxg8MVj++xmb32KMUqL7ptikkym20vVdhecVMNvpPoXp8uvaGT7991enWP9HGKUC
9kLY2DEYwRGE71UJJLGWo4n49R50ExFRj91xWnYfvp7uJsMNwnBp5l3GTZiMELX2RkRVSPOHr7l1
n2p5Vq7Uee2drny1IxZ/4c0hYY6y3QWSEqpESw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
HUtfqZ9dh5oZTOAt9a0ebo+wQbzg3izFQ0kVqZN81S4cBjQEF53WUiVlTKBDVjvLNUby4Se9WZjj
j86TQzuGJxLPDTohmbytErsg5JrlXHbHGwR4zGNGTbBs12X7PkxtS8wVCp+7b1rX6pOGOPqm6FoG
g6rZY/bTzVfGYF2CAOhjJUqUOXEAKnZRehspRyiBI28/ZZPSAUD/abKprW8PWCxMx2zPWztZz4No
R96jgvHezNzB1Ta8W7uRBFTMp+XVSToxTp2jzSXJZ0V5xJl+gdVjAMmf6+te2vqrK2wDWdMxk3Sf
iyLI4d0s25vCybcY2fZWacq5iO9pSlSaOQWgCA==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
vYYu2Kvhv3RZi0pFbjRTQ/BBwfilCrGpkMls+Dz6HBGTZvSaC/anWgymoDS0XnoSENGG3Pz3EBF0
19OqLbyna95IHFe2bA7f8RgU9SEUffZ8eXGigfOjAWpZCN07Q77RkhGUKal7okWe3Q6xHtZy83l2
kW8ma3kOYL7GzQjtpbP3lINHLMqpGEo0dzbOHiJ5r6W5U6DsILGsoLQOXcw+MwrevvNRB0KkSklj
QnL8K2AK8PIsJGM6F8dj5KwRYhSBYNb1opuVpiJWlbHgADoeM+dhiRxBLmnaDE8PWs1ReY6uMzzH
SvvO6UEyxQtvS/Smm/uogr1eUFedUaBHPMEXnYlTAv/SKrh942GeknsqfrjGkZxWTN2NEnvpRUwT
fS0pyd/Err0s94b0srmcTYyxZfJGRUct2T8MCphZFaScAlhn655pxW9RaHMfcvDJUHpW8Qa+KhRt
9CWYScPIH6YNDByLQbhKL5BTpAYMNYPF2W7vM2ZzDob2NB7m6GGeKRr3

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QSNmIeTT4pBji+CTjknWXN6sH9Wff8+t8KF+AC3fIoIw08jtLtShcB9ZGeEKG02RGCO4lNIUf5YB
2TVYk6EJ5XyCav12qDhc60n56UVrnpfo7drorY0NmOypuxECgO43h6SDWp9W7px3r4CJnQ4+X2Mj
943GdP30WfL5kbWHZJC1Dz9cBIqRa1EbNXvvAqBvRPS2+aXBXAPOC4rNVZGeIUspn/33IW3yJLSp
Jm5GIct87ZuSoz8+DXhUvsTj4hq8lgirVhfz1qhHm8SfODcE91FGUPw3vbpGWXsBX73t2zxFC1Hz
/6m4YqQJVxd+H5iGE4kbHxHyHnH7FIerqc8Phw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UhfxKxECbuHK/o9ZExa2zP/MIPmFXuDNZwgpiawuBmPeRI1nJsYB7vzbBGMPKny4yIHLT8mHrQRc
fs05atkjIAbLea4+WNoCdCeg7/0PzuodM1ol3it6BHQ6Yzq4mnZbzlk8Xtwmk8ACAbzOr2SYxYWX
ueuUlimUSRusIe4+NiPvzbfHMAOVPjdmSY7zaSyeJuhdAR+fUGeHy5B23Xe2X6cDPeJ75IqcBeul
ox3dTXi3L8r/s1bTKX3FhxRyPZuh/xCWuEajsF2fEYdwWHKtLX6IQniLBJ5ZnVSS8D7IYPsvV4t0
9rWJqto5O1n3rAM44OvKvc9pOYXJupuv7g3gWg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
fmo66vhS7nigYtLDMjdj7hgUnDG/fnO+cIaY/3qHrcwT7u/paj5enLuWHovegu9O9WRq3pPNnjuN
6vZRpuCgz5p4VAV7dVg9fuzg99BAjThp1Q/+HIPfdQ2LM14ZpTh4FXxthHGkTyS5PJArvZ3/UMpW
zwfdYd5+k2/emJ4/nuqoJHQG8k+O5EjSprLTvNZ/wrE1cT/fW/Lu2pxI4msHqVVYAXz7sJ13cQ+C
7tKxCV8vTyf0rpStdE+kZXg+jrc7vFKuPJO0U9axMsC0nXyeYx2jzfAHptGWKvfQaPg/Eo9mgLyN
qSJfFS6aIycuxNmg7L82WK401aWhnUn7GNrudg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 43600)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
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
    reg GRESTORE_int;

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
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

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

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
