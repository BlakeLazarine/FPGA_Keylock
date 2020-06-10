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
    assign done = completed;


    reg [3:0] ch = 0;
    reg enableSender = 0;
    reg doneSending;
    reg doneSendingReg = 0;
    sender send (.hwclk(hwclk), .num(ch), .enabled(enableSender), .done(doneSending),
        .out0(out0), .out1(out1), .out2(out2), .controlOut(controlOut));

    reg prevEnabled = 0;
    reg [17:0] numbers = 0;
    /* always */
    reg [31:0] i = 0;

    reg rdy = 0;
    reg prevDoneSending = 0;

    reg [31:0] num10 = 0;
    reg [31:0] num100 = 0;
    reg [31:0] num1000 = 0;
    reg [31:0] num10000 = 0;
    reg [31:0] num100000 = 0;
    reg [31:0] num1000000 = 0;

    always @ (posedge hwclk) begin
        if(enabled) begin
            if(!completed) begin
                rdy = prevDoneSending & doneSending;

                enableSender = (rdy) ? 1 : !doneSending;
                if(doneSending & !prevDoneSending) begin
  		//	ch[0] = i[0];
      		//	ch[1] = i[1];
		//	ch[2] = i[2];			
		    ch[0] = numbers[3 * i];
                    ch[1] = numbers[3 * i + 1];
                    ch[2] = numbers[3 * i + 2];

                    i <= i+1;
                end
	        if(i == 7) begin
                    completed = 1;
		    prevDoneSending = 0;
		    doneSendingReg = 0;
	        end else
                    prevDoneSending = doneSending;
            end
        end
	else begin
		num10 = num%10;
                num100 = (num/10)%10;
                num1000 = (num/100)%10;
                num10000 = (num/1000)%10;
                num100000 = (num/10000)%10;
                num1000000 = (num/100000)%10;

                numbers[15] = num10[0];
                numbers[16] = num10[1];
                numbers[17] = num10[2];

                numbers[12] = num100[0];
                numbers[13] = num100[1];
                numbers[14] = num100[2];

                numbers[9] = num1000[0];
                numbers[10] = num1000[1];
                numbers[11] = num1000[2];

                numbers[6] = num10000[0];
                numbers[7] = num10000[1];
                numbers[8] = num10000[2];

                numbers[3] = num100000[0];
                numbers[4] = num100000[1];
                numbers[5] = num100000[2];

                numbers[0] = num1000000[0];
                numbers[1] = num1000000[1];
                numbers[2] = num1000000[2];

                i = 0;
                ch = 0;
                rdy = 1;
                completed = 0;
		prevDoneSending = 1;
		doneSendingReg = 0;
		enableSender = 0;
	end
       prevEnabled <= enabled;
    end
endmodule
