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
    keyList list(.hwclk(hwclk), .key(button), .button_pressed(bstate), .reset(1'b0), .typed(typed));

    assign led8 = typeOutput[0];
    assign led7 = typeOutput[1];
    assign led6 = typeOutput[2];
    assign led5 = typeOutput[3];
    assign led4 = typeOutput[4];
    assign led3 = typeOutput[5];
    assign led2 = typeOutput[6];
    assign led1 = typeOutput[7];

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
    end

//   assign led2 = (typed == 0);
    /*
    always @ (posedge bstate) begin
        ledOn = !ledOn;
    end*/

endmodule
