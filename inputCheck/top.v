// Blink an LED provided an input clock
/* module */
module top (
        // input hardware clock (12 MHz)
    hwclk, 
    // LED
    led1,
    led2,
    led3,
    led4,
    led5,
    led6,
    led7,
    led8,
    // Keypad lines
    keypad_r1,
    keypad_r2,
    keypad_r3,
    keypad_c1,
    keypad_c2,
    keypad_c3,
    );
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


    output keypad_r1;
    output keypad_r2;
    output keypad_r3;

    input keypad_c1;
    input keypad_c2;
    input keypad_c3;

    reg [3:0] ledvals;
    reg [2:0] row_outputs;

    reg [3:0] button;
    reg bstate;
    reg ledOn = 0;
//    assign led2 = ledOn;
    /* Button Modules */
    enterDigit dig(
    // input hardware clock (12 MHz)
    .hwclk(hwclk),
    // Keypad lines
    .keypad_r1(keypad_r1),
    .keypad_r2(keypad_r2),
    .keypad_r3(keypad_r3),
    .keypad_c1(keypad_c1),
    .keypad_c2(keypad_c2),
    .keypad_c3(keypad_c3),
    .button(button),
    .bstate(bstate)
    );

    reg [31:0] typed;
    reg [31:0] typeOutput;
    reg [1:0] validOutput;
    keyList list(.hwclk(hwclk), .key(button), .button_pressed(bstate), .reset(1'b0), .typed(typed));

    assign led8 = validOutput;

    always @ (posedge hwclk) begin
        //ledOn = typed[0];
	typeOutput[0] <= typed[0];
	typeOutput[1] <= typed[1];
	typeOutput[2] <= typed[2];
	typeOutput[3] <= typed[3];
	typeOutput[4] <= typed[4];
        typeOutput[5] <= typed[5];
        typeOutput[6] <= typed[6];
        typeOutput[7] <= typed[7];
	typeOutput[8] <= typed[8];
	typeOutput[9] <= typed[9];
	typeOutput[10] <= typed[10];
	typeOutput[11] <= typed[11];
	typeOutput[12] <= typed[12];
	typeOutput[13] <= typed[13];
	typeOutput[14] <= typed[14];
	typeOutput[15] <= typed[15];
	typeOutput[16] <= typed[16];
	typeOutput[17] <= typed[17];
	typeOutput[18] <= typed[18];
	typeOutput[19] <= typed[19];
	typeOutput[20] <= typed[20];
	typeOutput[21] <= typed[21];
	typeOutput[22] <= typed[22];
	typeOutput[23] <= typed[23];
	typeOutput[24] <= typed[24];
	typeOutput[25] <= typed[25];
	typeOutput[26] <= typed[26];
	typeOutput[27] <= typed[27];
	typeOutput[28] <= typed[28];
	typeOutput[29] <= typed[29];
	typeOutput[30] <= typed[30];
	typeOutput[31] <= typed[31];

	if(typeOutput[31:0] == 32'd1111 || typeOutput[31:0] == 32'd11111 || typeOutput[31:0] == 32'd111111) begin
	validOutput <= 1'b1;
	end
	else begin
	validOutput <= 1'b0;
	end
    end

//   assign led2 = (typed == 0);
    /*
    always @ (posedge bstate) begin
        ledOn = !ledOn;
    end*/

endmodule
