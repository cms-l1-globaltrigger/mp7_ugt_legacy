// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Wed Dec  1 14:27:47 2021
// Host        : srv-b1b07-10-01.cern.ch running 64-bit unknown
// Command     : write_verilog -force -mode funcsim
//               /home/ugt-build/bergauer/github/cms-l1-globaltrigger/mp7_ugt_legacy/firmware/ngc/rom_lut_calo_inv_dr_sq_4/rom_lut_calo_inv_dr_sq_4_sim_netlist.v
// Design      : rom_lut_calo_inv_dr_sq_4
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7vx690tffg1927-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "rom_lut_calo_inv_dr_sq_4,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2021.2" *) 
(* NotValidForBitStream *)
module rom_lut_calo_inv_dr_sq_4
   (clka,
    addra,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [11:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [10:0]douta;

  wire [11:0]addra;
  wire clka;
  wire [10:0]douta;
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
  wire [10:0]NLW_U0_doutb_UNCONNECTED;
  wire [11:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [11:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [10:0]NLW_U0_s_axi_rdata_UNCONNECTED;
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     3.483999 mW" *) 
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
  (* C_INIT_FILE = "rom_lut_calo_inv_dr_sq_4.mem" *) 
  (* C_INIT_FILE_NAME = "rom_lut_calo_inv_dr_sq_4.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "4096" *) 
  (* C_READ_DEPTH_B = "4096" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "11" *) 
  (* C_READ_WIDTH_B = "11" *) 
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
  (* C_WRITE_WIDTH_A = "11" *) 
  (* C_WRITE_WIDTH_B = "11" *) 
  (* C_XDEVICEFAMILY = "virtex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  rom_lut_calo_inv_dr_sq_4_blk_mem_gen_v8_4_5 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[10:0]),
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
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[10:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 35408)
`pragma protect data_block
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
0Jo4JgpIHKKVHi4=
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
