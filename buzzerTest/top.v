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
    parameter [2847:0] clocks = 2848'h6a885ee3cfc0549cb9405ee3dc804fb84fb84fb84fb800c000005ee3549cdc804fb8cfc0549cf780470547054705470500c000006a885ee3cfc0549cb9405ee3dc804fb84fb84fb84fb800c000005ee3549cdc804fb8cfc0549cf7804705470547054705a5006a88cfc0549c8ac07eb0a5006a88cfc0549c8ac07eb0a5006a88cfc0549cb9405ee3dc804fb88ac07eb0b9405ee3dc804fb88ac07eb0b9405ee3dc804fb8b9405ee3dc804fb88ac07eb0b9405ee3dc804fb88ac07eb0b9405ee3dc804fb8b9405ee3f78047059c0070aeb9405ee3f78047059c0070aeb9405ee3f7804705a5006a88cfc0549c8ac07eb0a5006a88cfc0549c8ac07eb0a5006a88cfc0549cb9405ee3dc804fb88ac07eb0b9405ee3dc804fb88ac07eb0b9405ee3dc804fb8b9405ee3dc804fb88ac07eb0b9405ee3dc804fb88ac07eb0b9405ee3dc804fb8b9405ee3f78047059c0070aeb9405ee3f78047059c0070aeb9405ee3f7804705;
    parameter clockslen = 32;
    reg [4:0] i = 0;
    reg [15:0] completedCycles = 0000;
    /* always */
    always @ (posedge hwclk) begin
        buzz = (halfperiod == 0) ? 0 : counter < halfperiod;
    	if(counter > 2 * halfperiod) begin
            if(i == 32)
                i <= 0;
            else if(completedCycles > runthroughs) begin
        		halfperiod[0] <= [32 * i];
                halfperiod[1] <= [32 * i + 1];
                halfperiod[2] <= [32 * i + 2];
                halfperiod[3] <= [32 * i + 3];
                halfperiod[4] <= [32 * i + 4];
                halfperiod[5] <= [32 * i + 5];
                halfperiod[6] <= [32 * i + 6];
                halfperiod[7] <= [32 * i + 7];
                halfperiod[8] <= [32 * i + 8];
                halfperiod[9] <= [32 * i + 9];
                halfperiod[10] <= [32 * i + 10];
                halfperiod[11] <= [32 * i + 11];
                halfperiod[12] <= [32 * i + 12];
                halfperiod[13] <= [32 * i + 13];
                halfperiod[14] <= [32 * i + 14];
                halfperiod[15] <= [32 * i + 15];

                runthroughs[0] <= [32 * i];
                runthroughs[1] <= [32 * i + 1];
                runthroughs[2] <= [32 * i + 2];
                runthroughs[3] <= [32 * i + 3];
                runthroughs[4] <= [32 * i + 4];
                runthroughs[5] <= [32 * i + 5];
                runthroughs[6] <= [32 * i + 6];
                runthroughs[7] <= [32 * i + 7];
                runthroughs[8] <= [32 * i + 8];
                runthroughs[9] <= [32 * i + 9];
                runthroughs[10] <= [32 * i + 10];
                runthroughs[11] <= [32 * i + 11];
                runthroughs[12] <= [32 * i + 12];
                runthroughs[13] <= [32 * i + 13];
                runthroughs[14] <= [32 * i + 14];
                runthroughs[15] <= [32 * i + 15];

                i <= i + 1;
                completedCycles <= 0;
            end
    		counter <= 0;

    	end
        else
		counter <= counter + 1;
    end

endmodule
