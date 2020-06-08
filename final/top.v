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
    reg patternOn = 0;
    reg patternBright, patternDone;
    pattern pat(.hwclk(hwclk), .ontime(ontime), .offtime(offtime),
      .reps(patternReps), .done(patternDone), .enable(patternOn), .bright(patternBright));

    reg checkPC, checkUC, checkValidUC, chillin, toggleLED1, openLED2, openLED3, error, match;
    reg ValidUC, confirmUC;
    reg reset = 1;
    reg prevBState = 0;
    wire rdy = bstate & !prevBState;

    controller control (
      .CheckPC(checkPC),
      .CheckValidUC(checkValidUC),
      .Chillin(chillin),
      .LED2(openLED2),
      .LED3(openLED3),
      .LOCKING(checkUC),
      .ToggleLED1(toggleLED1),
      .error(error),
      .DoneBlink(patternDone),
      .ValidUC(ValidUC),
      .clk(hwclk),
      .keypress(button),
      .match(match),
      .rdy(rdy), //do tests to see if bstate is high for only 1 clock cycle
      .resetN(reset),
      .confirmUC(confirmUC)
    );

    always @ (posedge toggleLED1) begin
        led1 = !led1;
    end

    reg [31:0] maybeNewUC = 0;
    reg recordKeys = 0;
    reg prevCheckingValid = 0;
    keyList list(.hwclk(hwclk), .key(button), .button_pressed(bstate), .enable(recordKeys), .typed(typed));

    reg [31:0] compareReg = 0;
    compareMod comp (.hwclk(hwclk), .in(typed), .compare(compareReg), .match(match), .validUC(ValidUC));

    reg [7:0] count = 0;
    always @ (posedge hwclk) begin
        recordKeys = (checkValidUC ^ prevCheckingValid) ? 0 : checkUC | checkPC | checkValidUC | confirmUC;
        prevCheckingValid <= checkValidUC;

        prevBState = bstate;

        if(checkValidUC) begin
            maybeNewUC = typed;
            //compareReg = typed;
        end else if(checkUC)
            compareReg = UC;
        else if(checkPC)
            compareReg = PC;
        else if (confirmUC)
            compareReg = maybeNewUC;


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

        if(openLED3)
            if(error)
                led3 = patternBright;
            else
                led3 = 1;
        else
            led3 = 0;

    	led5 = checkValidUC;
	led6 = ValidUC;
	led7 = confirmUC;
//	led8 = rdy & (button==8);
    end

//   assign led2 = (typed == 0);
  
    always @ (posedge rdy) begin
        led8 = (button==8);

    end

endmodule
