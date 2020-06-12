// Code your testbench here
// or browse Examples
// Testbench

`timescale 1ns / 1ps

module ha2_task2_tb();
  reg CLK, RST, DIN;
  wire DOUT_SHORT, DOUT_LONG;
  integer i, j;
  ha2_task2 ha2_task2_tb(.CLK(CLK),.DIN(DIN),.RST(RST),.DOUT_SHORT(DOUT_SHORT), .DOUT_LONG(DOUT_LONG));
  
  //go through increasingly large pulse width
  initial begin
    for (i=6'b1;i<12;i=i+1) begin
      #8
      RST = 1;
      #8
      CLK = 0;
      #8
      CLK = 1;
      #8
      RST = 0;
      CLK = 0;
      //have DIN be high for i clock cycles and low for i clock cycles. Reapting
      for(j=6'b0;j<128;j=j+1) begin
        #8
        DIN = (j / (2 * i)) % 2;
        #8
        CLK = j % 2;
        #8
        if(CLK)
          $display("i %d DIN %b SHORT %b LONG %b", i, DIN, DOUT_SHORT, DOUT_LONG);
        
      end
    end
  end
endmodule