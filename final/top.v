// Blink an LED provided an input clock
/* module */
module top (
        // input hardware clock (12 MHz)
    input hwclk,
    // LED
    output led1, led2, led3, led4, led5, led6, led7, led8,
    // Keypad lines
    output keypad_r1, keypad_r2, keypad_r3,
    input keypad_c1, keypad_c2, keypad_c3,
    );
    /* I/O */
    input hwclk;

	/* Button Module */
    reg [3:0] button;
    reg bstate;

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

    reg [31:0] ontime, offtime;
    reg [7:0] patternReps;
    reg patternOn, patternBright, patternDone;
    pattern pat(.hwclk(hwclk), .ontime(ontime), .offtime(offtime), 
      .reps(patternReps), .done(patternDone), .enable(patternOn), .bright(patternBright));

    reg checkPC, checkUC, checkValidUC, chillin, toggleLED1, openLED2, openLED3,
      ValidNewUC, matchPC, matchUC, reset, error;
    controller contol (
      .CheckPC(checkPC),
      .CheckValidUC(checkValidUC),
      .Chillin(chillin),
      .LED2(openLED2),
      .LED3(openLED3),
      .LOCKING(checkUC),
      .ToggleLED1(toggleLED1),
      .error(error),
      .DoneBlink(patternDone),
      .ValidNewUC(ValidNewUC),
      .clk(hwclk),
      .keypres(button),
      .matchPC(matchPC),
      .matchUC(matchUC),
      .rdy(bstate), //do tests to see if bstate is high for only 1 clock cycle
      .reset(reset)
    );

    always @ (posedge toggleLED1) begin
        led1 = !led1;
    end

    always @ (posedge hwclk) begin
        if(error) begin

        end


        if(openLED2)
            if(error)
                led2 = patternBright;
            else
                led2 = 1;
        else
            led2 = 0;

        if(openLED2)
            if(error)
                led2 = patternBright;
            else
                led2 = 1;
        else
            led2 = 0;
    end


//   assign led2 = (typed == 0);
    /*
    always @ (posedge bstate) begin
        ledOn = !ledOn;
    end*/

endmodule
