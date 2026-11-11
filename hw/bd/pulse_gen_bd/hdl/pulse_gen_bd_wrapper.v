//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.2 (lin64) Build 5239630 Fri Nov 08 22:34:34 MST 2024
//Date        : Wed Nov 11 14:43:07 2026
//Host        : hp6g4-mlab-5 running 64-bit Ubuntu 22.04.5 LTS
//Command     : generate_target pulse_gen_bd_wrapper.bd
//Design      : pulse_gen_bd_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module pulse_gen_bd_wrapper
   (adc_clk,
    adc_data,
    dac_clk,
    dac_data,
    fan_en_b,
    led_0,
    led_1);
  output adc_clk;
  input [13:0]adc_data;
  output dac_clk;
  output [13:0]dac_data;
  output [0:0]fan_en_b;
  output [0:0]led_0;
  output [0:0]led_1;

  wire adc_clk;
  wire [13:0]adc_data;
  wire dac_clk;
  wire [13:0]dac_data;
  wire [0:0]fan_en_b;
  wire [0:0]led_0;
  wire [0:0]led_1;

  pulse_gen_bd pulse_gen_bd_i
       (.adc_clk(adc_clk),
        .adc_data(adc_data),
        .dac_clk(dac_clk),
        .dac_data(dac_data),
        .fan_en_b(fan_en_b),
        .led_0(led_0),
        .led_1(led_1));
endmodule
