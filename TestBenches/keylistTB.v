// Code your testbench here
// or browse Examples
// Testbench

`timescale 1ns / 1ps

module ha2_task2_tb();
  reg hwclk, enable = 0;
  reg [31:0] typed = 3;
  reg [31:0] offtime = 2;
  reg [7:0] key = 0;

  integer i, j;
  keyList keyListTB(.hwclk(hwclk),.key(key),.button_pressed(button_pressed),.typed(typed),.enable(enable));

  //go through increasingly large pulse width
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    for(key = 1; key < 10; key = key + 1) begin
      #8
      hwclk = 0;
      #8
      hwclk = 1;
      #8
      hwclk = 0;
      button_pressed = 1;
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
      button_pressed = 0;
    end
    #8
    hwclk = 1;
    #8
    hwclk = 0;
    #8
    hwclk = 1;
    #8
    hwclk = 0;
    for(key = 7; key < 13; key = key - 1) begin
      #8
      hwclk = 0;
      #8
      hwclk = 1;
      #8
      hwclk = 0;
      button_pressed = 1;
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
      button_pressed = 0;
    end

  end
endmodule
