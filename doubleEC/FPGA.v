// Created by fizzim.pl version 5.20 on 2020:06:12 at 15:14:45 (www.fizzim.com)

// Warning T20: 10 bits specified as type "reg".  Type "reg" means they will be included in the state encoding.  With so many bits, this might take a very long time and/or consume large amounts of memory.  Consider converting some of them to type "regdp" or type "flag".  To suppress this message in the future, use "-nowarn T20"
module controller (
  output wire CheckPC,
  output wire CheckValidUC,
  output wire Chillin,
  output wire LED2,
  output wire LED3,
  output wire LOCKING,
  output wire ToggleLED1,
  output wire confirmUC,
  output wire error,
  output wire sendSecret,
  input wire DoneBlink,
  input wire ValidUC,
  input wire clk,
  input wire doneSend,
  input wire [3:0] keypress,
  input wire match,
  input wire rdy,
  input wire resetN
);

  // state bits
  parameter
  START            = 10'b0000000000, // sendSecret=0 error=0 confirmUC=0 ToggleLED1=0 LOCKING=0 LED3=0 LED2=0 Chillin=0 CheckValidUC=0 CheckPC=0
  BadLock          = 10'b0100001000, // sendSecret=0 error=1 confirmUC=0 ToggleLED1=0 LOCKING=0 LED3=0 LED2=1 Chillin=0 CheckValidUC=0 CheckPC=0
  BadRepro         = 10'b0100010000, // sendSecret=0 error=1 confirmUC=0 ToggleLED1=0 LOCKING=0 LED3=1 LED2=0 Chillin=0 CheckValidUC=0 CheckPC=0
  LockingUnlocking = 10'b0000101000, // sendSecret=0 error=0 confirmUC=0 ToggleLED1=0 LOCKING=1 LED3=0 LED2=1 Chillin=0 CheckValidUC=0 CheckPC=0
  ReproPhase1      = 10'b0000010001, // sendSecret=0 error=0 confirmUC=0 ToggleLED1=0 LOCKING=0 LED3=1 LED2=0 Chillin=0 CheckValidUC=0 CheckPC=1
  ReproPhase2      = 10'b0000010010, // sendSecret=0 error=0 confirmUC=0 ToggleLED1=0 LOCKING=0 LED3=1 LED2=0 Chillin=0 CheckValidUC=1 CheckPC=0
  ReproPhase3      = 10'b0010010000, // sendSecret=0 error=0 confirmUC=1 ToggleLED1=0 LOCKING=0 LED3=1 LED2=0 Chillin=0 CheckValidUC=0 CheckPC=0
  SUCCESS          = 10'b0000010100, // sendSecret=0 error=0 confirmUC=0 ToggleLED1=0 LOCKING=0 LED3=1 LED2=0 Chillin=1 CheckValidUC=0 CheckPC=0
  correctUC        = 10'b0001000000, // sendSecret=0 error=0 confirmUC=0 ToggleLED1=1 LOCKING=0 LED3=0 LED2=0 Chillin=0 CheckValidUC=0 CheckPC=0
  printOut         = 10'b1000000000; // sendSecret=1 error=0 confirmUC=0 ToggleLED1=0 LOCKING=0 LED3=0 LED2=0 Chillin=0 CheckValidUC=0 CheckPC=0

  reg [9:0] state;
  reg [9:0] nextstate;

  // comb always block
  always @* begin
    // Warning I2: Neither implied_loopback nor default_state_is_x attribute is set on state machine - defaulting to implied_loopback to avoid latches being inferred
    nextstate = state; // default to hold value because implied_loopback is set
    case (state)
      START           : begin
        // Warning P3: State START has multiple exit transitions, and transition trans0 has no defined priority
        // Warning P3: State START has multiple exit transitions, and transition trans32 has no defined priority
        // Warning P3: State START has multiple exit transitions, and transition trans8 has no defined priority
        if (rdy&(keypress==9)) begin
          nextstate = LockingUnlocking;
        end
        else if (rdy&(keypress==7)) begin
          nextstate = printOut;
        end
        else if (rdy&(keypress==8)) begin
          nextstate = ReproPhase1;
        end
        else begin
          nextstate = START;
        end
      end
      BadLock         : begin
        if (DoneBlink) begin
          nextstate = START;
        end
        else begin
          nextstate = BadLock;
        end
      end
      BadRepro        : begin
        if (DoneBlink) begin
          nextstate = START;
        end
        else begin
          nextstate = BadRepro;
        end
      end
      LockingUnlocking: begin
        // Warning P3: State LockingUnlocking has multiple exit transitions, and transition trans2 has no defined priority
        // Warning P3: State LockingUnlocking has multiple exit transitions, and transition trans3 has no defined priority
        // Warning P3: State LockingUnlocking has multiple exit transitions, and transition trans35 has no defined priority
        // Warning P3: State LockingUnlocking has multiple exit transitions, and transition trans4 has no defined priority
        if (!rdy | (keypress !=7 & keypress != 9)) begin
          nextstate = LockingUnlocking;
        end
        else if (rdy & (keypress == 9) & match) begin
          nextstate = correctUC;
        end
        else if (rdy & (keypress ==7)) begin
          nextstate = BadRepro;
        end
        else if (rdy & (keypress == 9) & !match) begin
          nextstate = BadLock;
        end
      end
      ReproPhase1     : begin
        // Warning P3: State ReproPhase1 has multiple exit transitions, and transition trans11 has no defined priority
        // Warning P3: State ReproPhase1 has multiple exit transitions, and transition trans17 has no defined priority
        // Warning P3: State ReproPhase1 has multiple exit transitions, and transition trans27 has no defined priority
        if (!rdy | (keypress !=7 & keypress != 8)) begin
          nextstate = ReproPhase1;
        end
        else if (rdy & (keypress == 8) & match) begin
          nextstate = ReproPhase2;
        end
        else if (rdy & (((keypress == 8) & !match) | (keypress==7))) begin
          nextstate = BadRepro;
        end
      end
      ReproPhase2     : begin
        // Warning P3: State ReproPhase2 has multiple exit transitions, and transition trans18 has no defined priority
        // Warning P3: State ReproPhase2 has multiple exit transitions, and transition trans26 has no defined priority
        if (rdy & (keypress == 8) & ValidUC) begin
          nextstate = ReproPhase3;
        end
        else if (rdy&((keypress==7) | ((keypress == 8) & !ValidUC))) begin
          nextstate = BadRepro;
        end
        else begin
          nextstate = ReproPhase2;
        end
      end
      ReproPhase3     : begin
        // Warning P3: State ReproPhase3 has multiple exit transitions, and transition trans19 has no defined priority
        // Warning P3: State ReproPhase3 has multiple exit transitions, and transition trans25 has no defined priority
        if (rdy & (keypress == 8) & match) begin
          nextstate = SUCCESS;
        end
        else if (rdy&((keypress==7) | ((keypress == 8) & !match))) begin
          nextstate = BadRepro;
        end
        else begin
          nextstate = ReproPhase3;
        end
      end
      SUCCESS         : begin
        if (DoneBlink) begin
          nextstate = START;
        end
        else begin
          nextstate = SUCCESS;
        end
      end
      correctUC       : begin
        begin
          nextstate = START;
        end
      end
      printOut        : begin
        if (!doneSend) begin
          nextstate = printOut;
        end
        else begin
          nextstate = START;
        end
      end
    endcase
  end

  // Assign reg'd outputs to state bits
  assign CheckPC = state[0];
  assign CheckValidUC = state[1];
  assign Chillin = state[2];
  assign LED2 = state[3];
  assign LED3 = state[4];
  assign LOCKING = state[5];
  assign ToggleLED1 = state[6];
  assign confirmUC = state[7];
  assign error = state[8];
  assign sendSecret = state[9];

  // sequential always block
  always @(posedge clk or negedge resetN) begin
    if (!resetN)
      state <= START;
    else
      state <= nextstate;
  end

  // This code allows you to see state names in simulation
  `ifndef SYNTHESIS
  reg [127:0] statename;
  always @* begin
    case (state)
      START           :
        statename = "START";
      BadLock         :
        statename = "BadLock";
      BadRepro        :
        statename = "BadRepro";
      LockingUnlocking:
        statename = "LockingUnlocking";
      ReproPhase1     :
        statename = "ReproPhase1";
      ReproPhase2     :
        statename = "ReproPhase2";
      ReproPhase3     :
        statename = "ReproPhase3";
      SUCCESS         :
        statename = "SUCCESS";
      correctUC       :
        statename = "correctUC";
      printOut        :
        statename = "printOut";
      default         :
        statename = "XXXXXXXXXXXXXXXX";
    endcase
  end
  `endif

endmodule
