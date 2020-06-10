module multisend (hwclk, num, enabled, rdy, done, out0, out1, out2, controlOut);
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
        .out0(led6), .out1(led7), .out2(led8), .controlOut(led5));

    reg prevEnabled = 0;
    reg [29:0] numbers = 0;
    reg [31:0] tempNum = 10;
    /* always */
    reg [31:0] i = 0;

    reg rdy = 0;
    reg prevDoneSending = 0;
    always @ (posedge hwclk) begin
        if(enabled) begin
            if(!prevEnabled) begin
                tempNum = 10;
                int idx = 0;
                for(idx = 0; idx < 6; idx = idx + 1) begin
                    int localNum = num % tempNum;
                    numbers[3 * i] = localNum[0];
                    numbers[3 * i + 1] = localNum[1];
                    numbers[3 * i + 2] = localNum[2];
                    tempNum = tempNum * 10;
                end
                i <= 0;
                ch <= 0;
                rdy <= 1;
            end
            else
                rdy = prevDoneSending;

            enableSender = (rdy) ? 1 : !doneSending;
            if(doneSending) begin
                ch[0] = numbers[3 * i];
                ch[1] = numbers[3 * i + 1];
                ch[2] = numbers[3 * i + 2];

                i <= i+1;
            end


        end
        prevDoneSending = doneSending;
        prevEnabled = enabled;
    end
endmodule
