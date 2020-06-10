module multisend (hwclk, num, enabled, out0, out1, out2, controlOut, done);
    /* I/O */
    input hwclk;
    input [31:0] num;
    input enabled;
    output out0, out1, out2, controlOut;
    output done;

    parameter holdTime = 1200000; //1/10 second
    /* Counter register */
    reg prevEnabled = 0;
    reg complete = 0;
    assign done = complete;


    reg [3:0] ch = 0;
    reg enableSender = 0;
    reg doneSending;
    sender send (.hwclk(hwclk), .num(ch), .enabled(enableSender), .done(doneSending),
        .out0(out0), .out1(out1), .out2(out2), .controlOut(controlOut));

    reg prevEnabled = 0;
    reg [17:0] numbers = 0;
    /* always */
    reg [31:0] i = 0;

    reg rdy = 0;
    reg prevDoneSending = 0;
    always @ (posedge hwclk) begin
        if(enabled) begin
            if(!prevEnabled) begin

                numbers[15] = (num % 10)[0];
                numbers[16] = (num % 10)[1];
                numbers[17] = (num % 10)[2];

                numbers[12] = (num % 100)[0];
                numbers[13] = (num % 100)[1];
                numbers[14] = (num % 100)[2];

                numbers[9] = (num % 1000)[0];
                numbers[10] = (num % 1000)[1];
                numbers[11] = (num % 1000)[2];

                numbers[6] = (num % 10000)[0];
                numbers[7] = (num % 10000)[1];
                numbers[8] = (num % 10000)[2];

                numbers[3] = (num % 100000)[0];
                numbers[4] = (num % 100000)[1];
                numbers[5] = (num % 100000)[2];

                numbers[0] = (num % 1000000)[0];
                numbers[1] = (num % 1000000)[1];
                numbers[2] = (num % 1000000)[2];

                i <= 0;
                ch <= 0;
                rdy <= 1;
                complete <= 0;
            end
            else if(!completed)
                rdy = prevDoneSending;

            enableSender = (rdy) ? 1 : !doneSending;
            if(doneSending & !completed) begin
                ch[0] = numbers[3 * i];
                ch[1] = numbers[3 * i + 1];
                ch[2] = numbers[3 * i + 2];

                i <= i+1;
            end
            if(i == 9)
                completed = 1;

        end
        prevDoneSending = doneSending;
        prevEnabled = enabled;
    end
endmodule
