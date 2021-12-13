// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Wed Dec  1 14:24:51 2021
// Host        : srv-b1b07-10-01.cern.ch running 64-bit unknown
// Command     : write_verilog -force -mode funcsim
//               /home/ugt-build/bergauer/github/cms-l1-globaltrigger/mp7_ugt_legacy/firmware/ngc/rom_lut_calo_inv_dr_sq_3/rom_lut_calo_inv_dr_sq_3_sim_netlist.v
// Design      : rom_lut_calo_inv_dr_sq_3
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7vx690tffg1927-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "rom_lut_calo_inv_dr_sq_3,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2021.2" *) 
(* NotValidForBitStream *)
module rom_lut_calo_inv_dr_sq_3
   (clka,
    addra,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [11:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [11:0]douta;

  wire [11:0]addra;
  wire clka;
  wire [11:0]douta;
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
  wire [11:0]NLW_U0_doutb_UNCONNECTED;
  wire [11:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [11:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [11:0]NLW_U0_s_axi_rdata_UNCONNECTED;
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
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     3.511199 mW" *) 
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
  (* C_INIT_FILE = "rom_lut_calo_inv_dr_sq_3.mem" *) 
  (* C_INIT_FILE_NAME = "rom_lut_calo_inv_dr_sq_3.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "4096" *) 
  (* C_READ_DEPTH_B = "4096" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "12" *) 
  (* C_READ_WIDTH_B = "12" *) 
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
  (* C_WRITE_WIDTH_A = "12" *) 
  (* C_WRITE_WIDTH_B = "12" *) 
  (* C_XDEVICEFAMILY = "virtex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  rom_lut_calo_inv_dr_sq_3_blk_mem_gen_v8_4_5 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[11:0]),
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
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[11:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 35376)
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
