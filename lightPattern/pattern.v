module pattern (hwclk, ontime, offtime, reps, done, enable, bright);
    /* I/O */
    input hwclk;
    input [31:0] ontime;
    input [31:0] offtime;
    input [7:0] reps;
    input enable;
    output bright;
    output done;
    
    /* Counter register */
    reg [31:0] counter = 32'b0;
    reg enab = 1'b0;
    reg light = 1'b0;
    reg [7:0] cycles = 0;
    reg complete = 1'b0;
    /* LED drivers */
   /* assign led1 = counter[18];
    assign led2 = counter[19];
    assign led3 = counter[20];
    assign led4 = counter[21];
    assign led5 = counter[22];
    assign led6 = counter[23];
    assign led7 = counter[24];
    assign led8 = counter[25];*/

    //parameter clkspeed = 32'd12000000;
    reg[31:0] period = 0;//ontime + offtime;
    
    /* always */
    assign bright = light;
    assign done = complete;
    always @ (posedge hwclk) begin
	if(!done) begin
        if(!enab & enable) begin
            complete = 0;
            cycles = 0;
            period = ontime + offtime;
            counter = 0;
	    enab = 1;
	    light = 1;
        end

        if(cycles >= reps) begin
            complete = 1;
//	    bright = 0;
            light = 0;
	    enab = 0;
        end
        else begin
            counter <= counter + 1;
            if(counter < offtime)
               // bright = 0;
                light = 0;
            else if(counter < period)
   //             bright = 1;
                light = 1;
            else begin
                cycles <= cycles + 1;
                counter <= 0;
            end
        end
        end
    end
endmodule

