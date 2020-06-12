// Code your testbench here
// or browse Examples
// Testbench

`timescale 1ns / 1ps

module ha2_task2_tb();
  reg hwclk, enable = 0;
  reg [31:0] typed;
  
  reg [7:0] key = 0;
  reg button_pressed = 0;

  integer i, j;
  keyList keyListTB(.hwclk(hwclk),.key(key),.button_pressed(button_pressed),.typed(typed),.enable(enable));

  //go through increasingly large pulse width
  initial begin
    #8
    hwclk = 1;
    #8
    hwclk = 0;
    enable = 1;
    #8
    hwclk = 1;  
    $dumpfile("dump.vcd"); $dumpvars;
    for(key = 1; key < 9; key = key + 1) begin
      $display("key %d", key);
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
    for(key = 7; key > 3; key = key - 1) begin
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
