module top (hwclk, led1, led2, led3, led4, led5, led6, led7, led8, buzz);
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
    output buzz;

    /* Counter register */
    reg [31:0] counter = 32'b0;

    parameter [31:0] halfperiod = 6000;

    /* always */
    always @ (posedge hwclk) begin
        buzz = counter < halfperiod;
        counter <= (counter > 2 * halfperiod) ? 0 : counter + 1;
    end

endmodule
