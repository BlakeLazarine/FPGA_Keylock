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
    parameter [31:0] PC = 555116;
    reg [31:0] UC = 666666;

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


    reg [31:0] ontime, offtime;
    reg [7:0] patternReps;
    reg patternOn, patternBright, patternDone;
    pattern pat(.hwclk(hwclk), .ontime(ontime), .offtime(offtime),
      .reps(patternReps), .done(patternDone), .enable(patternOn), .bright(patternBright));

    reg checkPC, checkUC, checkValidUC, chillin, toggleLED1, openLED2, openLED3,
      ValidNewUC, match, reset, error;
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
      .match(match),
      .rdy(bstate), //do tests to see if bstate is high for only 1 clock cycle
      .reset(reset)
    );

    always @ (posedge toggleLED1) begin
        led1 = !led1;
    end

    reg [31:0] maybeNewUC = 0;
    wire recordKeys = checkUC | checkPC | checkValidUC;
    keyList list(.hwclk(hwclk), .key(button), .button_pressed(bstate), .enable(recordKeys), .typed(typed));

    always @ (posedge hwclk) begin
        if(checkValidUC)
            maybeNewUC <= typed;


        if(error) begin
            ontime = 12000000;
            offtime = 6000000;
            patternReps = 3;
            patternOn = 1;
        end else if(chillin) begin
            ontime = 2400000;
            offtime = 2400000;
            patternReps = 3;
            patternOn = 1;

            UC = maybeNewUC;
            maybeNewUC = 0;
        end
        else
            patternOn = 0;


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
