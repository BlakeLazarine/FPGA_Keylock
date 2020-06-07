// Blink an LED provided an input clock
/* module */
module top (hwclk, led1, led2, led3, led4, led5, led6, led7, led8 );
    /* I/O */
    input hwclk;
    output led1;
    output led2;
    output led3;
    output led4;
    output led5;
    output led6;
    output led7;
    output led8;

    /* Counter register */
    reg [31:0] counter = 32'b0;
    wire enab;
    reg on = 1;
    reg done;
    pattern Pat(.hwclk(hwclk), .ontime(32'd12000000), .offtime(32'd6000000), .reps(8'd3), .enable(on), .bright(enab), .done(done));
    assign led3 = enab;

    
    /* LED drivers */
   /* assign led1 = counter[18];
    assign led2 = counter[19];
    assign led3 = counter[20];
    assign led4 = counter[21];
    assign led5 = counter[22];
    assign led6 = counter[23];
    assign led7 = counter[24];
    assign led8 = counter[25];*/

    //parameter clkspeed = 32'd12000000;
    //parameter period = 32'd18000000;
    /* always */
    
    //assign led2 = enab;
    /*
    always @ (posedge hwclk) begin
        if(done)
		on = 0;
    end
*/
endmodule
