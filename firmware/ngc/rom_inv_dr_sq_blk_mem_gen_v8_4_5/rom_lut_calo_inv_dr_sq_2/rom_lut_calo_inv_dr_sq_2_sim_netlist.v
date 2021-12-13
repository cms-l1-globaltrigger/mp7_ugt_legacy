// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Wed Dec  1 14:21:12 2021
// Host        : srv-b1b07-10-01.cern.ch running 64-bit unknown
// Command     : write_verilog -force -mode funcsim
//               /home/ugt-build/bergauer/github/cms-l1-globaltrigger/mp7_ugt_legacy/firmware/ngc/rom_lut_calo_inv_dr_sq_2/rom_lut_calo_inv_dr_sq_2_sim_netlist.v
// Design      : rom_lut_calo_inv_dr_sq_2
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7vx690tffg1927-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "rom_lut_calo_inv_dr_sq_2,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2021.2" *) 
(* NotValidForBitStream *)
module rom_lut_calo_inv_dr_sq_2
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
  (* C_INIT_FILE = "rom_lut_calo_inv_dr_sq_2.mem" *) 
  (* C_INIT_FILE_NAME = "rom_lut_calo_inv_dr_sq_2.mif" *) 
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
  rom_lut_calo_inv_dr_sq_2_blk_mem_gen_v8_4_5 U0
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
