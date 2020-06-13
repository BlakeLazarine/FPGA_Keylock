// Blink an LED provided an input clock
/* module */
module compareMod (
        // input hardware clock (12 MHz)
    hwclk,
    // LED
    // Keypad lines
    in,
    compare,
    match,
    validUC
    );
    /* I/O */
    input hwclk;
	  input [31:0] in;
	  input [31:0] compare;
    output match;
    output validUC;


    reg matchReg = 0;
    reg validReg = 0;
    assign match = matchReg;
    assign validUC = validReg;
    always @ (posedge hwclk) begin
        matchReg = (in == compare);
        validReg = ((in < 666667) & (in > 1110));
    end

endmodule
