module sender (hwclk, num, enabled, done, out0, out1, out2, controlOut, active, buzz);
    /* I/O */
    input hwclk;
    input [3:0] num;
    input enabled;
    output out0, out1, out2, controlOut;
    output done;
    output active;
    output buzz;

    parameter holdTime = 1200000; //1/10 second
    /* Counter register */
    reg [31:0] counter = 32'b0;
//    reg prevEnabled = 0;
    reg complete = 0;
    assign done = complete;
    /* always */
    always @ (posedge hwclk) begin
        if(enabled) begin

            if(num < 7) begin
                out0 = num[0];
                out1 = num[1];
                out2 = num[2];
            end
            else begin
                out0 = 0;
                out1 = 0;
                out2 = 0;
            end
            controlOut = (counter < holdTime);
            buzz = controlOut & counter[num + 9];
    
      	    if(counter > holdTime*2) begin
                complete = 1;
      		      active = 0;
            end
            else
                active = 1;
            counter = counter + 1;
        end
      	else begin
            counter = 0;
      	    complete = 0;
            out0 = 0;
      	    out1 = 0;
      	    out2 = 0;
      	    controlOut = 0;
      	end
//        prevEnabled = enabled;
    end
endmodule
