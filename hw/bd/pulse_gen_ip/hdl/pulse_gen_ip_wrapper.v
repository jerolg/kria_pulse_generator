//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.2 (lin64) Build 5239630 Fri Nov 08 22:34:34 MST 2024
//Date        : Wed Nov 11 14:43:58 2026
//Host        : hp6g4-mlab-5 running 64-bit Ubuntu 22.04.5 LTS
//Command     : generate_target pulse_gen_ip_wrapper.bd
//Design      : pulse_gen_ip_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module pulse_gen_ip_wrapper
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
  input [31:0]CHA_BRAM_addr;
  input CHA_BRAM_clk;
  input [31:0]CHA_BRAM_din;
  output [31:0]CHA_BRAM_dout;
  input CHA_BRAM_en;
  input CHA_BRAM_rst;
  input [3:0]CHA_BRAM_we;
  input [31:0]SIGNAL_BRAM_addr;
  input SIGNAL_BRAM_clk;
  input [31:0]SIGNAL_BRAM_din;
  output [31:0]SIGNAL_BRAM_dout;
  input SIGNAL_BRAM_en;
  input SIGNAL_BRAM_rst;
  input [3:0]SIGNAL_BRAM_we;
  input aresetn;
  input [31:0]cha_len;
  input clk;
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
  wire [31:0]SIGNAL_BRAM_addr;
  wire SIGNAL_BRAM_clk;
  wire [31:0]SIGNAL_BRAM_din;
  wire [31:0]SIGNAL_BRAM_dout;
  wire SIGNAL_BRAM_en;
  wire SIGNAL_BRAM_rst;
  wire [3:0]SIGNAL_BRAM_we;
  wire aresetn;
  wire [31:0]cha_len;
  wire clk;
  wire [13:0]dac_out;
  wire done_ev;
  wire ena;
  wire [31:0]prob_thr;
  wire [0:0]pulse_trig;
  wire [13:0]ramp_test;
  wire [31:0]target_ev;

  pulse_gen_ip pulse_gen_ip_i
       (.CHA_BRAM_addr(CHA_BRAM_addr),
        .CHA_BRAM_clk(CHA_BRAM_clk),
        .CHA_BRAM_din(CHA_BRAM_din),
        .CHA_BRAM_dout(CHA_BRAM_dout),
        .CHA_BRAM_en(CHA_BRAM_en),
        .CHA_BRAM_rst(CHA_BRAM_rst),
        .CHA_BRAM_we(CHA_BRAM_we),
        .SIGNAL_BRAM_addr(SIGNAL_BRAM_addr),
        .SIGNAL_BRAM_clk(SIGNAL_BRAM_clk),
        .SIGNAL_BRAM_din(SIGNAL_BRAM_din),
        .SIGNAL_BRAM_dout(SIGNAL_BRAM_dout),
        .SIGNAL_BRAM_en(SIGNAL_BRAM_en),
        .SIGNAL_BRAM_rst(SIGNAL_BRAM_rst),
        .SIGNAL_BRAM_we(SIGNAL_BRAM_we),
        .aresetn(aresetn),
        .cha_len(cha_len),
        .clk(clk),
        .dac_out(dac_out),
        .done_ev(done_ev),
        .ena(ena),
        .prob_thr(prob_thr),
        .pulse_trig(pulse_trig),
        .ramp_test(ramp_test),
        .target_ev(target_ev));
endmodule
