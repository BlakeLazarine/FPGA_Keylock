// Code your testbench here
// or browse Examples
// Testbench

`timescale 1ns / 1ps

module ha2_task2_tb();
  reg hwclk, enable = 0;
  reg done, bright;
  reg [31:0] ontime = 3;
  reg [31:0] offtime = 2;
  reg [7:0] reps = 3;

  integer i, j;
  pattern pat(.hwclk(hwclk), .ontime(ontime), .offtime(offtime), .reps(reps), .done(done), .enable(enable), .bright(bright));
  
  //go through increasingly large pulse width
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
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
    enable = 1;
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
    enable = 0;
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