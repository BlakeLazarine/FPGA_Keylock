module top (hwclk, led1, led2, led3, led4, led5, led6, led7, led8, buzz);
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
    output buzz;

    /* Counter register */
    reg [31:0] counter = 32'b0;

    reg [15:0] halfperiod = 0000;
    reg [15:0] runthroughs = 0000;
//    parameter [191:0] clocks = 192'h9c0070aeb9405ee3f78047059c0070ae0b945ee30f784705;
    parameter clockslen = 32;
    reg [4:0] i = 0;
    reg [15:0] completedCycles = 0000;
    /* always */
    always @ (posedge hwclk) begin
	    /*
        buzz = (halfperiod == 0) ? 0 : counter < halfperiod;
    	if(counter > 2 * halfperiod) begin
	   
//	    led2 = (i==2);
	    led3 = (i==3);
            led4 = (i==4);
            led5 = (i==5);
            led6 = (i==6);

            if(i == 5)
                i <= 0;
            else if(completedCycles > runthroughs) begin
        		halfperiod[0] <= clocks[32 * i];
                halfperiod[1] <= clocks[32 * i + 1];
                halfperiod[2] <= clocks[32 * i + 2];
                halfperiod[3] <= clocks[32 * i + 3];
                halfperiod[4] <= clocks[32 * i + 4];
                halfperiod[5] <= clocks[32 * i + 5];
                halfperiod[6] <= clocks[32 * i + 6];
                halfperiod[7] <= clocks[32 * i + 7];
                halfperiod[8] <= clocks[32 * i + 8];
                halfperiod[9] <= clocks[32 * i + 9];
                halfperiod[10] <= clocks[32 * i + 10];
                halfperiod[11] <= clocks[32 * i + 11];
                halfperiod[12] <= clocks[32 * i + 12];
                halfperiod[13] <= clocks[32 * i + 13];
                halfperiod[14] <= clocks[32 * i + 14];
                halfperiod[15] <= clocks[32 * i + 15];

                runthroughs[0] <= clocks[32 * i + 16];
                runthroughs[1] <= clocks[32 * i + 17];
                runthroughs[2] <= clocks[32 * i + 18];
                runthroughs[3] <= clocks[32 * i + 19];
                runthroughs[4] <= clocks[32 * i + 20];
                runthroughs[5] <= clocks[32 * i + 21];
                runthroughs[6] <= clocks[32 * i + 22];
                runthroughs[7] <= clocks[32 * i + 23];
                runthroughs[8] <= clocks[32 * i + 24];
                runthroughs[9] <= clocks[32 * i + 25];
                runthroughs[10] <= clocks[32 * i + 26];
                runthroughs[11] <= clocks[32 * i + 27];
                runthroughs[12] <= clocks[32 * i + 28];
                runthroughs[13] <= clocks[32 * i + 29];
                runthroughs[14] <= clocks[32 * i + 30];
                runthroughs[15] <= clocks[32 * i + 31];
led7 = !led7;
                i <= i + 1;
                completedCycles <= 0;
            end
	    else begin
                counter <= 0;
	        completedCycles <= completedCycles + 1;
		led8 = !led8;
	    end
    	end
	else begin
		counter <= counter + 1;
		led1 = !led1;
	end
	led2 = (runthroughs == 63360);*/
       if(counter[10])
	       buzz = !buzz;
       counter <= counter + 1;
       
    end

endmodule
