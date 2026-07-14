//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
//Date        : Tue Jul 14 17:14:52 2026
//Host        : DESKTOP-5CC134L running 64-bit major release  (build 9200)
//Command     : generate_target pulse_gen_ip.bd
//Design      : pulse_gen_ip
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "pulse_gen_ip,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=pulse_gen_ip,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=15,numReposBlks=15,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=10,numPkgbdBlks=0,bdsource=USER,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "pulse_gen_ip.hwdef" *) 
module pulse_gen_ip
   (CHA_BRAM_addr,
    CHA_BRAM_clk,
    CHA_BRAM_din,
    CHA_BRAM_dout,
    CHA_BRAM_en,
    CHA_BRAM_rst,
    CHA_BRAM_we,
    SIGNAL_BRAM_addr,
    SIGNAL_BRAM_clk,
    SIGNAL_BRAM_din,
    SIGNAL_BRAM_dout,
    SIGNAL_BRAM_en,
    SIGNAL_BRAM_rst,
    SIGNAL_BRAM_we,
    aresetn,
    cha_len,
    clk,
    dac_out,
    done_ev,
    ena,
    prob_thr,
    pulse_trig,
    ramp_test,
    target_ev);
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CHA_BRAM ADDR" *) (* X_INTERFACE_MODE = "Slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CHA_BRAM, MASTER_TYPE BRAM_CTRL, MEM_ECC NONE, MEM_SIZE 32768, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_WRITE" *) input [31:0]CHA_BRAM_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CHA_BRAM CLK" *) input CHA_BRAM_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CHA_BRAM DIN" *) input [31:0]CHA_BRAM_din;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CHA_BRAM DOUT" *) output [31:0]CHA_BRAM_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CHA_BRAM EN" *) input CHA_BRAM_en;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CHA_BRAM RST" *) input CHA_BRAM_rst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 CHA_BRAM WE" *) input [3:0]CHA_BRAM_we;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 SIGNAL_BRAM ADDR" *) (* X_INTERFACE_MODE = "Slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME SIGNAL_BRAM, MASTER_TYPE BRAM_CTRL, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_WRITE" *) input [31:0]SIGNAL_BRAM_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 SIGNAL_BRAM CLK" *) input SIGNAL_BRAM_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 SIGNAL_BRAM DIN" *) input [31:0]SIGNAL_BRAM_din;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 SIGNAL_BRAM DOUT" *) output [31:0]SIGNAL_BRAM_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 SIGNAL_BRAM EN" *) input SIGNAL_BRAM_en;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 SIGNAL_BRAM RST" *) input SIGNAL_BRAM_rst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 SIGNAL_BRAM WE" *) input [3:0]SIGNAL_BRAM_we;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.ARESETN RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.ARESETN, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input aresetn;
  input [31:0]cha_len;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, ASSOCIATED_RESET aresetn, CLK_DOMAIN pulse_gen_ip_clk_0, FREQ_HZ 49999500, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk;
  output [13:0]dac_out;
  output done_ev;
  input ena;
  input [31:0]prob_thr;
  input [0:0]pulse_trig;
  output [13:0]ramp_test;
  input [31:0]target_ev;

  wire [31:0]CHA_BRAM_addr;
  wire CHA_BRAM_clk;
  wire [31:0]CHA_BRAM_din;
  wire [31:0]CHA_BRAM_dout;
  wire CHA_BRAM_en;
  wire CHA_BRAM_rst;
  wire [3:0]CHA_BRAM_we;
  wire Net;
  wire [31:0]Net3;
  wire [31:0]SIGNAL_BRAM_addr;
  wire SIGNAL_BRAM_clk;
  wire [31:0]SIGNAL_BRAM_din;
  wire [31:0]SIGNAL_BRAM_dout;
  wire SIGNAL_BRAM_en;
  wire SIGNAL_BRAM_rst;
  wire [3:0]SIGNAL_BRAM_we;
  wire [31:0]Xoshiro32bit_0_Data;
  wire [31:0]Xoshiro32bit_1_Data;
  wire aresetn;
  wire [0:0]c_shift_ram_0_Q;
  wire [31:0]cha_len;
  wire clk;
  wire [13:0]dac_out;
  wire done_ev;
  wire ena;
  wire [31:0]pileup_manager_0_BRAM_PORT_ADDR;
  wire pileup_manager_0_BRAM_PORT_CLK;
  wire [31:0]pileup_manager_0_BRAM_PORT_DOUT;
  wire pileup_manager_0_BRAM_PORT_EN;
  wire pileup_manager_0_BRAM_PORT_RST;
  wire [7167:0]pileup_manager_0_data_out;
  wire pileup_manager_0_data_valid;
  wire pileup_manager_0_trig_ch1;
  wire pileup_manager_0_trig_ch2;
  wire pileup_manager_0_trig_ch3;
  wire [31:0]prob_thr;
  wire [0:0]pulse_trig;
  wire [13:0]ramp_test;
  wire [31:0]rand_to_channel_0_BRAM_PORT_ADDR;
  wire rand_to_channel_0_BRAM_PORT_CLK;
  wire rand_to_channel_0_BRAM_PORT_EN;
  wire rand_to_channel_0_BRAM_PORT_RST;
  wire signal_send_0_busy;
  wire [13:0]signal_send_0_dac_out;
  wire signal_send_1_busy;
  wire [13:0]signal_send_1_dac_out;
  wire signal_send_2_busy;
  wire [13:0]signal_send_2_data_out;
  wire [31:0]target_ev;
  wire [127:0]xlconstant_0_dout;
  wire [127:0]xlconstant_1_dout;

  pulse_gen_ip_CDF_BRAM_0 CDF_BRAM
       (.addra(CHA_BRAM_addr),
        .addrb(rand_to_channel_0_BRAM_PORT_ADDR),
        .clka(CHA_BRAM_clk),
        .clkb(rand_to_channel_0_BRAM_PORT_CLK),
        .dina(CHA_BRAM_din),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0}),
        .douta(CHA_BRAM_dout),
        .doutb(Net3),
        .ena(CHA_BRAM_en),
        .enb(rand_to_channel_0_BRAM_PORT_EN),
        .rsta(CHA_BRAM_rst),
        .rstb(rand_to_channel_0_BRAM_PORT_RST),
        .wea(CHA_BRAM_we),
        .web({1'b0,1'b0,1'b0,1'b0}));
  pulse_gen_ip_PRNG_AMP_SAMPLING_0 PRNG_AMP_SAMPLING
       (.Clk(clk),
        .Data(Xoshiro32bit_0_Data),
        .Pull(1'b1),
        .ResetVal(xlconstant_0_dout),
        .aresetn(aresetn));
  pulse_gen_ip_PRNG_EV_SAMPLING_0 PRNG_EV_SAMPLING
       (.Clk(clk),
        .Data(Xoshiro32bit_1_Data),
        .Pull(1'b1),
        .ResetVal(xlconstant_1_dout),
        .aresetn(aresetn));
  pulse_gen_ip_SIGNAL_BRAM_0 SIGNAL_BRAM
       (.addra(SIGNAL_BRAM_addr),
        .addrb(pileup_manager_0_BRAM_PORT_ADDR),
        .clka(SIGNAL_BRAM_clk),
        .clkb(pileup_manager_0_BRAM_PORT_CLK),
        .dina(SIGNAL_BRAM_din),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0}),
        .douta(SIGNAL_BRAM_dout),
        .doutb(pileup_manager_0_BRAM_PORT_DOUT),
        .ena(SIGNAL_BRAM_en),
        .enb(pileup_manager_0_BRAM_PORT_EN),
        .rsta(SIGNAL_BRAM_rst),
        .rstb(pileup_manager_0_BRAM_PORT_RST),
        .wea(SIGNAL_BRAM_we),
        .web({1'b0,1'b0,1'b0,1'b0}));
  pulse_gen_ip_bernoulli_trial_0_0 bernoulli_trial_0
       (.aresetn(aresetn),
        .clk(clk),
        .done(done_ev),
        .en(ena),
        .ev_flag(Net),
        .prob_thr(prob_thr),
        .rnd(Xoshiro32bit_1_Data),
        .target_events(target_ev));
  pulse_gen_ip_c_shift_ram_0_0 c_shift_ram_0
       (.CLK(clk),
        .D(Net),
        .Q(c_shift_ram_0_Q));
  pulse_gen_ip_dac_ramp_0_0 dac_ramp_0
       (.clk(clk),
        .dac_data(ramp_test));
  pulse_gen_ip_pileup_adder_0_0 pileup_adder_0
       (.ch1_in(signal_send_0_dac_out),
        .ch2_in(signal_send_1_dac_out),
        .ch3_in(signal_send_2_data_out),
        .clk(clk),
        .dac_out(dac_out),
        .rst_n(aresetn));
  pulse_gen_ip_pileup_manager_0_0 pileup_manager_0
       (.bram_addr(pileup_manager_0_BRAM_PORT_ADDR),
        .bram_clk(pileup_manager_0_BRAM_PORT_CLK),
        .bram_dout(pileup_manager_0_BRAM_PORT_DOUT),
        .bram_en(pileup_manager_0_BRAM_PORT_EN),
        .bram_rst(pileup_manager_0_BRAM_PORT_RST),
        .busy_ch1(signal_send_0_busy),
        .busy_ch2(signal_send_1_busy),
        .busy_ch3(signal_send_2_busy),
        .clk(clk),
        .data_out(pileup_manager_0_data_out),
        .data_valid(pileup_manager_0_data_valid),
        .pulse_trig_in(c_shift_ram_0_Q),
        .rst_n(aresetn),
        .trig_ch1(pileup_manager_0_trig_ch1),
        .trig_ch2(pileup_manager_0_trig_ch2),
        .trig_ch3(pileup_manager_0_trig_ch3),
        .update_trigger(pulse_trig));
  pulse_gen_ip_rand_to_channel_0_0 rand_to_channel_0
       (.addr_lim(cha_len),
        .bram_clk(rand_to_channel_0_BRAM_PORT_CLK),
        .bram_en(rand_to_channel_0_BRAM_PORT_EN),
        .bram_rst(rand_to_channel_0_BRAM_PORT_RST),
        .chan_out(rand_to_channel_0_BRAM_PORT_ADDR),
        .clk(clk),
        .ev_flag(Net),
        .rand_in(Xoshiro32bit_0_Data));
  pulse_gen_ip_signal_send_0_0 signal_send_0
       (.amplitude(Net3),
        .aresetn(aresetn),
        .busy(signal_send_0_busy),
        .clk(clk),
        .data_in(pileup_manager_0_data_out),
        .data_out(signal_send_0_dac_out),
        .data_valid(pileup_manager_0_data_valid),
        .trigger(pileup_manager_0_trig_ch1));
  pulse_gen_ip_signal_send_1_0 signal_send_1
       (.amplitude(Net3),
        .aresetn(aresetn),
        .busy(signal_send_1_busy),
        .clk(clk),
        .data_in(pileup_manager_0_data_out),
        .data_out(signal_send_1_dac_out),
        .data_valid(pileup_manager_0_data_valid),
        .trigger(pileup_manager_0_trig_ch2));
  pulse_gen_ip_signal_send_2_0 signal_send_2
       (.amplitude(Net3),
        .aresetn(aresetn),
        .busy(signal_send_2_busy),
        .clk(clk),
        .data_in(pileup_manager_0_data_out),
        .data_out(signal_send_2_data_out),
        .data_valid(pileup_manager_0_data_valid),
        .trigger(pileup_manager_0_trig_ch3));
  pulse_gen_ip_xlconstant_0_0 xlconstant_0
       (.dout(xlconstant_0_dout));
  pulse_gen_ip_xlconstant_1_0 xlconstant_1
       (.dout(xlconstant_1_dout));
endmodule
