// Code your testbench here
// or browse Examples
// Testbench

`timescale 1ns / 1ps

module ha2_task2_tb();
  reg hwclk = 0;
  reg [31:0] in = 0;
  reg [31:0] compare = 555116;
  reg match, validUC;

  compareMod compareTB(.hwclk(hwclk), .in(in), .compare(compare), .match(match), .validUC(validUC));

  //go through increasingly large pulse width
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    $display("in %d", in);
    #8
    hwclk = 1;
    #8
    hwclk = 0;
    #4
    in = 5;
    #4
    hwclk = 1;
    #8
    hwclk = 0;
    #8
    hwclk = 1;
    #8
    hwclk = 0;
    #4
    in = 55;
    #4
    hwclk = 1;
    #8
    hwclk = 0;
    #8
    hwclk = 1;
    #8
    hwclk = 0;
    #4
    in = 555;
    #4
    hwclk = 1;
    #8
    hwclk = 0;
    #8
    hwclk = 1;
    #8
    hwclk = 0;
    #4
    in = 5551;
    #4
    hwclk = 1;
    #8
    hwclk = 0;
    #8
    hwclk = 1;
    #8
    hwclk = 0;
    $display("in %d", in);
    #4
    in = 55511;
    #4
    hwclk = 1;
    #8
    hwclk = 0;
    #8
    hwclk = 1;
    #8
    hwclk = 0;
    #4
    in = 555116;
    #4
    hwclk = 1;
    #8
    hwclk = 0;
    $display("in %d", in);
    #8
    hwclk = 1;
    #8
    hwclk = 0;
    #4
    in = 5551161;
    #4
    hwclk = 1;
    #8
    hwclk = 0;
    #8
    hwclk = 1;
    #8
    hwclk = 0;
  end
endmodule
