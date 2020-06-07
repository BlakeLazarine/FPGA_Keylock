// Blink an LED provided an input clock
/* module */
module keyList (
        // input hardware clock (12 MHz)
    hwclk, 
    // LED
    // Keypad lines
    key,
	button_pressed,
	typed,
	reset
    );
    /* I/O */
    input hwclk;
	input button_pressed;
	input reset;
	input [7:0] key;
	output [31:0] typed;

	reg [31:0] current = 0;
    /* Button Modules */
	assign typed = current;
	
	
	always @ (posedge reset) begin
        current = 0;
    end
	
    always @ (posedge button_pressed) begin
        current = 10 * current + key;
    end

endmodule
