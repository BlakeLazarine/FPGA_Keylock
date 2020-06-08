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
	enable
    );
    /* I/O */
    input hwclk;
	input button_pressed;
	input enable;
	input [7:0] key;
	output [31:0] typed;

	reg [31:0] current = 0;
    /* Button Modules */
	assign typed = current;


/*	always @ (posedge reset) begin
        current = 0;
    end*/
    reg buttonWasPressed = 0;

    always @ (posedge hwclk) begin
        if(button_pressed & !buttonWasPressed & enable)
            current <= ((key < 7) & (key > 0)) ? 10 * current + key : current;
        else if(!enable)
            current = 0;
        buttonWasPressed = button_pressed;

    end
/*    always @ (posedge hwclk) begin
        current <= 1;
    end*/


endmodule
