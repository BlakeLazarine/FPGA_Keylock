// Code your testbench here
// or browse Examples
// Testbench

`timescale 1ns / 1ps

module ha2_task2_tb();
  reg hwclk, enabled = 0;
  reg done, active, out0, out1, out2, controlOut;
  reg [3:0] num = 0;
  

  integer i, j;
  sender senderTB(.hwclk(hwclk), .num(num), .enabled(enabled), .done(done), .out0(out0), .out1(out1), .out2(out2), .controlOut(controlOut), .active(active));
  
  //go through increasingly large pulse width
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    for(num = 0; num < 10; num = num + 1) begin
      #8
      hwclk = 0;
      $display("num %d", num);
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
      while(active) begin
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
  end
endmodule