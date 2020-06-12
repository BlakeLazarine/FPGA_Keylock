// Code your testbench here
// or browse Examples
// Testbench

`timescale 1ns / 1ps

module ha2_task2_tb();
  reg hwclk, enabled = 0;
  reg done, out0, out1, out2, controlOut;
  reg [31:0] num = 555116;
  

  integer i, j;
  multisend multisendTB(.hwclk(hwclk), .num(num), .enabled(enabled), .out0(out0), .out1(out1), .out2(out2), .controlOut(controlOut), .done(done));
  
  //go through increasingly large pulse width
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    #8
    hwclk = 0;
    #8
    hwclk = 1;
    #8
    hwclk = 0;
    #8
    hwclk = 1;
    #8
    hwclk = 0;
    #8
    hwclk = 1;
    #8
    hwclk = 0;
    #4
    enabled = 1;
    #4
    hwclk = 1;
    #8
    hwclk = 0;
    while(!done) begin
      #8
      hwclk = 1;
      #8
      hwclk = 0;
    end
    enabled = 0;
    #8
    hwclk = 1;
    #8
    hwclk = 0;
    #8
    hwclk = 1;
    #8
    hwclk = 0;
    #8
    hwclk = 1;
    #8
    hwclk = 0;
  
  end
endmodule